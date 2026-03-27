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
