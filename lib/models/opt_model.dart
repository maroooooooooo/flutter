import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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