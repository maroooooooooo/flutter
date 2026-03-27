/*import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════════════════

class OtpModel {
  final String phoneNumber;     // e.g. "+201001234567"
  final String maskedNumber;    // e.g. "+20 100****8665"
  final int otpLength;

  const OtpModel({
    required this.phoneNumber,
    required this.maskedNumber,
    this.otpLength = 4,
  });

  /// Masks the middle digits:  +201001238665  →  +20 100****8665
  factory OtpModel.fromPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final visible = digits.length >= 4 ? digits.substring(digits.length - 4) : digits;
    final countryCode = digits.startsWith('+20') ? '+20' : '';
    final rest = digits.replaceFirst(countryCode, '');
    final prefix = rest.length > 4 ? rest.substring(0, rest.length - 4) : '';
    final masked = '$countryCode ${prefix.substring(0, prefix.length.clamp(0, 3))}****$visible';
    return OtpModel(phoneNumber: digits, maskedNumber: masked);
  }
}

enum OtpStatus { idle, sending, codeSent, verifying, success, error }

// ════════════════════════════════════════════════════════════════════════════
// TWILIO SERVICE  (swap credentials in the constants below)
// ════════════════════════════════════════════════════════════════════════════

class TwilioOtpService {
  // ── 🔑 Replace these with your Twilio credentials ──────────────────────
  // IMPORTANT: In production move these to a backend — never ship secrets in
  // a mobile app binary.  Use your own server endpoint to proxy Twilio calls.
  static const String _accountSid  = 'YOUR_TWILIO_ACCOUNT_SID';
  static const String _authToken   = 'YOUR_TWILIO_AUTH_TOKEN';
  static const String _serviceSid  = 'YOUR_TWILIO_VERIFY_SERVICE_SID';
  // ────────────────────────────────────────────────────────────────────────

  static const String _baseUrl = 'https://verify.twilio.com/v2/Services';

  /// Sends a 4-digit OTP via Twilio Verify to [phoneNumber] (E.164 format).
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_serviceSid/Verifications'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_accountSid:$_authToken'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'To': phoneNumber,
          'Channel': 'sms',
        },
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /// Verifies the [code] entered by the user against Twilio Verify.
  Future<bool> verifyOtp(String phoneNumber, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$_serviceSid/VerificationCheck'),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$_accountSid:$_authToken'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'To': phoneNumber,
          'Code': code,
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['status'] == 'approved';
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// VIEW-MODEL
// ════════════════════════════════════════════════════════════════════════════

class OtpViewModel extends ChangeNotifier {
  OtpViewModel({required this.model}) {
    _digits = List.filled(model.otpLength, '');
    _sendOtp(); // auto-send on open
  }

  final OtpModel model;
  final TwilioOtpService _service = TwilioOtpService();

  late List<String> _digits;
  OtpStatus _status = OtpStatus.idle;
  String _errorMessage = '';
  int _resendCooldown = 0;
  Timer? _timer;

  // ── Getters ──────────────────────────────────────────────────────────────
  List<String> get digits => List.unmodifiable(_digits);
  OtpStatus get status => _status;
  String get errorMessage => _errorMessage;
  int get resendCooldown => _resendCooldown;
  bool get canResend => _resendCooldown == 0 && _status != OtpStatus.sending;
  bool get canVerify =>
      _digits.every((d) => d.isNotEmpty) && _status != OtpStatus.verifying;

  String get _fullCode => _digits.join();

  // ── OTP digit input ──────────────────────────────────────────────────────
  void setDigit(int index, String value) {
    if (value.length > 1) value = value[value.length - 1];
    _digits[index] = value;
    _errorMessage = '';
    notifyListeners();
  }

  void clearDigit(int index) {
    _digits[index] = '';
    notifyListeners();
  }

  // ── Send OTP ─────────────────────────────────────────────────────────────
  Future<void> _sendOtp() async {
    _status = OtpStatus.sending;
    _errorMessage = '';
    notifyListeners();

    final success = await _service.sendOtp(model.phoneNumber);

    if (success) {
      _status = OtpStatus.codeSent;
      _startResendTimer();
    } else {
      _status = OtpStatus.error;
      _errorMessage = 'Failed to send OTP. Please try again.';
    }
    notifyListeners();
  }

  Future<void> resendOtp() async {
    if (!canResend) return;
    _digits = List.filled(model.otpLength, '');
    await _sendOtp();
  }

  // ── Verify OTP ───────────────────────────────────────────────────────────
  Future<void> verify() async {
    if (!canVerify) return;
    _status = OtpStatus.verifying;
    _errorMessage = '';
    notifyListeners();

    final success = await _service.verifyOtp(model.phoneNumber, _fullCode);

    if (success) {
      _status = OtpStatus.success;
      // TODO: navigate to step 3
      debugPrint('OTP verified successfully!');
    } else {
      _status = OtpStatus.error;
      _errorMessage = 'Invalid code. Please try again.';
      _digits = List.filled(model.otpLength, '');
    }
    notifyListeners();
  }

  // ── Resend cooldown timer (30 s) ─────────────────────────────────────────
  void _startResendTimer([int seconds = 30]) {
    _timer?.cancel();
    _resendCooldown = seconds;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCooldown <= 0) {
        t.cancel();
      } else {
        _resendCooldown--;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Step indicator
  static const int totalSteps = 4;
  static const int currentStep = 2;
}

// ════════════════════════════════════════════════════════════════════════════
// VIEW
// ════════════════════════════════════════════════════════════════════════════

class OtpScreen extends StatelessWidget {
  /// Pass the phone from the previous screen (CreateAccount).
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpViewModel(model: OtpModel.fromPhone(phoneNumber)),
      child: const _OtpView(),
    );
  }
}

// ── Root scaffold ─────────────────────────────────────────────────────────

class _OtpView extends StatelessWidget {
  const _OtpView();

  @override
  Widget build(BuildContext context) {
    final status = context.select<OtpViewModel, OtpStatus>((v) => v.status);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black87),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),

            // Step indicator
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _StepIndicator(),
            ),

            const SizedBox(height: 28),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const _Header(),
                    const SizedBox(height: 36),
                    const _OtpBoxes(),
                    const SizedBox(height: 12),
                    const _ErrorText(),
                    const SizedBox(height: 16),
                    const _ResendRow(),
                  ],
                ),
              ),
            ),

            // Sending / verifying overlay indicator
            if (status == OtpStatus.sending || status == OtpStatus.verifying)
              const LinearProgressIndicator(
                minHeight: 2,
                color: Color(0xFF007AFF),
                backgroundColor: Color(0xFFE5E5E5),
              ),

            const _VerifyButton(),
          ],
        ),
      ),
    );
  }
}

// ── Step indicator (reused pattern) ──────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    const total = OtpViewModel.totalSteps;
    const current = OtpViewModel.currentStep;

    return Row(
      children: List.generate(total * 2 - 1, (i) {
        if (i.isOdd) {
          final leftStep = (i ~/ 2) + 1;
          final isCompleted = leftStep < current;
          return Expanded(
            child: Container(
              height: 1.5,
              color: isCompleted ? const Color(0xFF007AFF) : const Color(0xFFDDDDDD),
            ),
          );
        }
        final step = i ~/ 2 + 1;
        final isActive = step == current;
        final isCompleted = step < current;

        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? const Color(0xFF007AFF) : Colors.white,
            border: Border.all(
              color: isActive || isCompleted ? const Color(0xFF007AFF) : const Color(0xFFCCCCCC),
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? const Color(0xFF007AFF) : const Color(0xFFAAAAAA),
                    ),
                  ),
          ),
        );
      }),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final masked = context.select<OtpViewModel, String>((v) => v.model.maskedNumber);
    return Column(
      children: [
        const Text(
          'Enter your OTP',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          'Please enter the 4-digit verification code\nsent to  $masked  via SMS.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Color(0xFF888888), height: 1.5),
        ),
      ],
    );
  }
}

// ── OTP input boxes ───────────────────────────────────────────────────────

class _OtpBoxes extends StatelessWidget {
  const _OtpBoxes();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OtpViewModel>();
    final length = vm.model.otpLength;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _OtpBox(index: i),
        );
      }),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final int index;
  const _OtpBox({required this.index});

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  late final TextEditingController _controller;
  late final FocusNode _focus;

  // Global list so boxes can move focus between each other
  static final List<FocusNode> _allFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focus = FocusNode();

    // Register focus node at this index
    if (widget.index >= _allFocusNodes.length) {
      _allFocusNodes.add(_focus);
    } else {
      _allFocusNodes[widget.index] = _focus;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final vm = context.read<OtpViewModel>();

    if (value.isEmpty) {
      vm.clearDigit(widget.index);
      // Move focus back
      if (widget.index > 0) {
        _allFocusNodes[widget.index - 1].requestFocus();
      }
      return;
    }

    // Accept last character only (handles paste or quick type)
    final digit = value.replaceAll(RegExp(r'\D'), '');
    if (digit.isEmpty) {
      _controller.clear();
      return;
    }

    final char = digit[digit.length - 1];
    _controller.text = char;
    _controller.selection = TextSelection.collapsed(offset: 1);
    vm.setDigit(widget.index, char);

    // Auto-advance
    if (widget.index < _allFocusNodes.length - 1) {
      _allFocusNodes[widget.index + 1].requestFocus();
    } else {
      _focus.unfocus();
      // Auto-verify when last box filled
      Future.microtask(() => vm.verify());
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OtpViewModel>();
    final digit = vm.digits[widget.index];
    final hasError = vm.status == OtpStatus.error;
    final isFilled = digit.isNotEmpty;

    // Sync controller text with VM (e.g. after reset)
    if (_controller.text != digit) {
      _controller.text = digit;
    }

    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 2, // allow 2 so we can read new char on top of old
        onChanged: _onChanged,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError
                  ? Colors.redAccent
                  : isFilled
                      ? const Color(0xFF007AFF)
                      : const Color(0xFFDDDDDD),
              width: isFilled ? 1.8 : 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
          ),
        ),
      ),
    );
  }
}

// ── Error text ────────────────────────────────────────────────────────────

class _ErrorText extends StatelessWidget {
  const _ErrorText();

  @override
  Widget build(BuildContext context) {
    final error = context.select<OtpViewModel, String>((v) => v.errorMessage);
    if (error.isEmpty) return const SizedBox.shrink();
    return Text(
      error,
      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
    );
  }
}

// ── Resend row ────────────────────────────────────────────────────────────

class _ResendRow extends StatelessWidget {
  const _ResendRow();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OtpViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Didn't receive the code? ",
            style: TextStyle(fontSize: 13, color: Color(0xFF888888))),
        GestureDetector(
          onTap: vm.canResend ? vm.resendOtp : null,
          child: Text(
            vm.canResend ? 'Resend' : 'Resend in ${vm.resendCooldown}s',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: vm.canResend ? const Color(0xFF007AFF) : const Color(0xFFAAAAAA),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Verify button ─────────────────────────────────────────────────────────

class _VerifyButton extends StatelessWidget {
  const _VerifyButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OtpViewModel>();
    final isVerifying = vm.status == OtpStatus.verifying;
    final isSuccess = vm.status == OtpStatus.success;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: vm.canVerify ? vm.verify : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isSuccess ? Colors.green : const Color(0xFF007AFF),
            disabledBackgroundColor: const Color(0xFF007AFF).withOpacity(0.5),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: isVerifying
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: Colors.white),
                )
              : Text(
                  isSuccess ? '✓ Verified' : 'Verify',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 0.2),
                ),
        ),
      ),
    );
  }
}*/