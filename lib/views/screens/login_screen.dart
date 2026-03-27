import 'package:flutter/material.dart';
import 'package:projects/viewmodels/login_viewmodel.dart';
import 'package:projects/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// LOGIN SCREEN (entry point)
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

// ════════════════════════════════════════════════════════════════════════════
// LOGIN VIEW
// ════════════════════════════════════════════════════════════════════════════

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
                SizedBox(height: 240),
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
                  width: 200,
                  height: 200,
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
      decoration: fieldDecoration(
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
      decoration: fieldDecoration(
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
        SocialButton(
          onTap: vm.isLoading ? null : () => vm.signInWithGoogle(context),
          child: const GoogleIcon(),
        ),
        const SizedBox(width: 20),
        SocialButton(
          onTap: vm.isLoading ? null : () => vm.signInWithApple(context),
          child: const Icon(Icons.apple, size: 26, color: Colors.black),
        ),
        const SizedBox(width: 20),
        SocialButton(
          onTap: vm.isLoading ? null : () => vm.signInWithGmail(context),
          child: const GmailIcon(),
        ),
      ],
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
// HOME SCREEN  (destination after sign-up tap)
// ════════════════════════════════════════════════════════════════════════════

/*class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
