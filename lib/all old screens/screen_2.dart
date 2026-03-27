/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projects/screen_3.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ════════════════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════════════════

class LoginModel {
  final String username;
  final String password;
  final bool rememberMe;

  const LoginModel({
    this.username = '',
    this.password = '',
    this.rememberMe = false,
  });

  LoginModel copyWith({
    String? username,
    String? password,
    bool? rememberMe,
  }) =>
      LoginModel(
        username: username ?? this.username,
        password: password ?? this.password,
        rememberMe: rememberMe ?? this.rememberMe,
      );
}

enum LoginStatus { idle, loading, success, error }

enum SocialProvider { google, apple, gmail }

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
      MaterialPageRoute(builder: (_) => const _HomeScreen()),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// VIEW
// ════════════════════════════════════════════════════════════════════════════

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Form — no scroll, fills screen ───────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(height: 260),
                _WelcomeText(),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: _UsernameField(),
                ),
                SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: _PasswordField(),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: _RememberForgotRow(),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: _LoginButton(),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: _OrDivider(),
                ),
                SizedBox(height: 20),
                _SocialButtons(),
                SizedBox(height: 32),
                _SignUpRow(),
              ],
            ),

            // ── Logo floats on top ────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: 210,
                  height: 210,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App Logo ──────────────────────────────────────────────────────────────

// class _AppLogo extends StatelessWidget {
//   const _AppLogo();

//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(
//       'assets/images/logo.jpg',
//       width: 290,    // ← matches screenshot proportions
//       height: 290,
//       fit: BoxFit.contain,
//     );
//   }
// }

// ── Welcome text ──────────────────────────────────────────────────────────

class _WelcomeText extends StatelessWidget {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'welcome back',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4D96FF),
        letterSpacing: 0.3,
      ),
    );
  }
}

// ── Shared input decoration ───────────────────────────────────────────────

InputDecoration _fieldDecoration({
  required String hint,
  required IconData prefixIcon,
  Widget? suffix,
  String? errorText,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
    errorText: errorText,
    prefixIcon: Icon(prefixIcon, color: const Color(0xFFBBBBBB), size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF4D96FF), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
  );
}

// ── Username field ────────────────────────────────────────────────────────

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return TextFormField(
      onChanged: context.read<LoginViewModel>().updateUsername,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: _fieldDecoration(
        hint: 'Username',
        prefixIcon: Icons.person_outline,
        errorText: vm.usernameError,
      ),
    );
  }
}

// ── Password field ────────────────────────────────────────────────────────

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return TextFormField(
      obscureText: !vm.passwordVisible,
      onChanged: context.read<LoginViewModel>().updatePassword,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: _fieldDecoration(
        hint: 'Password',
        prefixIcon: Icons.lock_outline,
        errorText: vm.passwordError,
        suffix: IconButton(
          icon: Icon(
            vm.passwordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFFBBBBBB),
            size: 20,
          ),
          onPressed: context.read<LoginViewModel>().togglePasswordVisibility,
        ),
      ),
    );
  }
}

// ── Remember me + Forgot password row ────────────────────────────────────

class _RememberForgotRow extends StatelessWidget {
  const _RememberForgotRow();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return Row(
      children: [
        // Checkbox
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: vm.model.rememberMe,
            onChanged: (_) => context.read<LoginViewModel>().toggleRememberMe(),
            activeColor: const Color(0xFF4D96FF),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(color: Color(0xFF4D96FF), width: 1.5),
          ),
        ),
        const SizedBox(width: 8),
        const Text('Remember Me',
            style: TextStyle(fontSize: 13, color: Colors.black87)),

        const Spacer(),

        // Forgot password
        GestureDetector(
          onTap: () =>
              context.read<LoginViewModel>().forgotPassword(context),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Login button ──────────────────────────────────────────────────────────

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: vm.isLoading ? null : () => vm.login(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4D96FF),
          disabledBackgroundColor: const Color(0xFF4D96FF).withOpacity(0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: vm.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : const Text(
                'Login',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2),
              ),
      ),
    );
  }
}

// ── "Or Continue With" divider ────────────────────────────────────────────

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('Or Continue With',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }
}

// ── Social buttons ────────────────────────────────────────────────────────

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _SocialButton(
          onTap: vm.isLoading ? null : () => vm.signInWithGoogle(context),
          child: _GoogleIcon(),
        ),
        const SizedBox(width: 20),
        // Apple
        _SocialButton(
          onTap: vm.isLoading ? null : () => vm.signInWithApple(context),
          child: const Icon(Icons.apple, size: 26, color: Colors.black),
        ),
        const SizedBox(width: 20),
        // Gmail (Google)
        _SocialButton(
          onTap: vm.isLoading ? null : () => vm.signInWithGmail(context),
          child: _GmailIcon(),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _SocialButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: onTap == null ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE5E5E5), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

// Inline Google "G" icon painted with correct brand colors
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw colored arc segments
    final segments = [
      (0.0, 0.5, const Color(0xFF4285F4)),   // Blue
      (0.5, 0.75, const Color(0xFF34A853)),  // Green
      (0.75, 0.92, const Color(0xFFFBBC05)), // Yellow
      (0.92, 1.0, const Color(0xFFEA4335)),  // Red
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg.$3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 2),
        seg.$1 * 2 * 3.14159,
        (seg.$2 - seg.$1) * 2 * 3.14159,
        false,
        paint,
      );
    }

    // White cutout for the "G" crossbar area
    final cut = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2, size.height / 2 - 2, size.width / 2 + 1, 4),
      cut,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// Gmail "M" icon
class _GmailIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'M',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Color(0xFFEA4335),
        fontFamily: 'serif',
      ),
    );
  }
}

// ── Sign up row ───────────────────────────────────────────────────────────

class _SignUpRow extends StatelessWidget {
  const _SignUpRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an Account? ",
          style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
        ),
        GestureDetector(
          onTap: () => context.read<LoginViewModel>().goToSignUp(context),
          child: const Text(
            'SIGN IN',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4D96FF),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HOME SCREEN  (destination after successful login)
// ════════════════════════════════════════════════════════════════════════════

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF4D96FF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline,
                    size: 44, color: Color(0xFF4D96FF)),
              ),
              const SizedBox(height: 24),
              const Text(
                'You\'re logged in!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              const SizedBox(height: 12),
              const Text(
                'Welcome back 👋',
                style: TextStyle(fontSize: 15, color: Color(0xFF888888)),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(
                          builder: (_) => const LoginScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D96FF),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text('Log out',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/