// models/splash_model.dart

class SplashModel {
  final Duration logoDuration;
  final Duration textDuration;
  final Duration taglineDuration;
  final Duration navDelay;

  const SplashModel({
    this.logoDuration    = const Duration(milliseconds: 900),
    this.textDuration    = const Duration(milliseconds: 700),
    this.taglineDuration = const Duration(milliseconds: 600),
    this.navDelay        = const Duration(milliseconds: 3200),
  });
}
