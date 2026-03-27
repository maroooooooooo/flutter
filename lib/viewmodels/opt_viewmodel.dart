import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projects/models/opt_model.dart';

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