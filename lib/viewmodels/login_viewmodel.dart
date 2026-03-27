import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projects/views/screens/home_screen.dart';
import 'package:projects/views/screens/terms_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/login_model.dart';

// ════════════════════════════════════════════════════════════════════════════
// VIEW-MODEL
// ════════════════════════════════════════════════════════════════════════════

class LoginViewModel extends ChangeNotifier {
  LoginModel _model = const LoginModel();
  LoginStatus _status = LoginStatus.idle;
  bool _passwordVisible = false;
  String _errorMessage = '';
  String? _usernameError;
  String? _passwordError;

  // Getters
  LoginModel get model => _model;
  LoginStatus get status => _status;
  bool get passwordVisible => _passwordVisible;
  String get errorMessage => _errorMessage;
  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;
  bool get isLoading => _status == LoginStatus.loading;

  // ── Field updates ─────────────────────────────────────────────────────────
  void updateUsername(String value) {
    _model = _model.copyWith(username: value);
    if (_usernameError != null) _usernameError = null;
    notifyListeners();
  }

  void updatePassword(String value) {
    _model = _model.copyWith(password: value);
    if (_passwordError != null) _passwordError = null;
    notifyListeners();
  }

  void toggleRememberMe() {
    _model = _model.copyWith(rememberMe: !_model.rememberMe);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  // ── Validation ────────────────────────────────────────────────────────────
  bool _validate() {
    bool valid = true;
    if (_model.username.trim().isEmpty) {
      _usernameError = 'Username is required';
      valid = false;
    } else {
      _usernameError = null;
    }
    if (_model.password.trim().isEmpty) {
      _passwordError = 'Password is required';
      valid = false;
    } else if (_model.password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      valid = false;
    } else {
      _passwordError = null;
    }
    notifyListeners();
    return valid;
  }

  // ── Login with username/password ──────────────────────────────────────────
  Future<void> login(BuildContext context) async {
    if (!_validate()) return;

    _status = LoginStatus.loading;
    _errorMessage = '';
    notifyListeners();

    // Simulate API call — replace with your real auth logic
    await Future.delayed(const Duration(seconds: 2));

    // Mock: accept any non-empty credentials
    _status = LoginStatus.success;
    notifyListeners();

    if (context.mounted) {
      _navigateToHome(context);
    }
  }

  // ── Forgot password ───────────────────────────────────────────────────────
  void forgotPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Password',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'A reset link will be sent to your registered email address.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reset link sent! Check your email.'),
                  backgroundColor: Color(0xFF007AFF),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Send Link',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Google Sign-In ────────────────────────────────────────────────────────
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      _status = LoginStatus.loading;
      notifyListeners();

      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final account = await googleSignIn.signIn();

      if (account == null) {
        // User cancelled
        _status = LoginStatus.idle;
        notifyListeners();
        return;
      }

      debugPrint('✅ Google Sign-In: ${account.email}');

      _status = LoginStatus.success;
      notifyListeners();

      if (context.mounted) _navigateToHome(context);
    } catch (e) {
      _status = LoginStatus.error;
      _errorMessage = 'Google sign-in failed. Please try again.';
      notifyListeners();
      debugPrint('Google Sign-In error: $e');
    }
  }

  // ── Apple Sign-In ─────────────────────────────────────────────────────────
  Future<void> signInWithApple(BuildContext context) async {
    try {
      _status = LoginStatus.loading;
      notifyListeners();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      debugPrint('✅ Apple Sign-In: ${credential.email}');

      _status = LoginStatus.success;
      notifyListeners();

      if (context.mounted) _navigateToHome(context);
    } catch (e) {
      _status = LoginStatus.error;
      _errorMessage = 'Apple sign-in failed. Please try again.';
      notifyListeners();
      debugPrint('Apple Sign-In error: $e');
    }
  }

  // ── Gmail (same as Google) ────────────────────────────────────────────────
  Future<void> signInWithGmail(BuildContext context) =>
      signInWithGoogle(context);

  // ── Navigate after success ────────────────────────────────────────────────
  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const TermsScreen(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0); // slide from right
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  // ── Sign up ───────────────────────────────────────────────────────────────
  void goToSignUp(BuildContext context) {
    // Replace with your actual sign-up screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
