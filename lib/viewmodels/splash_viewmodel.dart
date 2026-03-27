// viewmodels/splash_viewmodel.dart

import '../models/splash_model.dart';

class SplashViewModel {
  final SplashModel model;

  SplashViewModel({SplashModel? model})
      : model = model ?? const SplashModel();

  // Staggered delays so each element animates in sequence
  Duration get logoDelay    => Duration.zero;
  Duration get textDelay    => const Duration(milliseconds: 700);
  Duration get taglineDelay => const Duration(milliseconds: 1200);
  Duration get ringDelay    => const Duration(milliseconds: 300);
  Duration get navDelay     => model.navDelay;
}
