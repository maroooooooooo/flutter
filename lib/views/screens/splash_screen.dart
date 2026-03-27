// views/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:projects/viewmodels/splash_viewmodel.dart';
import 'package:projects/views/screens/login_screen.dart';

 // 👈 replace with your actual import path

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  final _vm = SplashViewModel();

  // Animation controllers
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _taglineCtrl;
  late final AnimationController _ringCtrl;
  late final AnimationController _pulseCtrl;

  // Animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset>  _textSlide;
  late final Animation<double> _textOpacity;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // ── Logo: scale up + fade in ──────────────────────────────────────────
    _logoCtrl = AnimationController(
        vsync: this, duration: _vm.model.logoDuration);
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _logoCtrl,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));

    // ── Brand name: slide up + fade in ────────────────────────────────────
    _textCtrl = AnimationController(
        vsync: this, duration: _vm.model.textDuration);
    _textSlide = Tween<Offset>(
            begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _textCtrl, curve: Curves.easeOutCubic));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));

    // ── Tagline: fade in ──────────────────────────────────────────────────
    _taglineCtrl = AnimationController(
        vsync: this, duration: _vm.model.taglineDuration);
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeIn));

    // ── Decorative ring: expand + fade out ────────────────────────────────
    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _ringScale = Tween<double>(begin: 0.6, end: 1.6).animate(
        CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));
    _ringOpacity = Tween<double>(begin: 0.35, end: 0.0).animate(
        CurvedAnimation(parent: _ringCtrl, curve: Curves.easeOut));

    // ── Gentle pulse on logo ──────────────────────────────────────────────
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.06).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(_vm.ringDelay);
    if (!mounted) return;
    _ringCtrl.forward();

    await Future.delayed(_vm.logoDelay);
    if (!mounted) return;
    _logoCtrl.forward();

    await Future.delayed(_vm.textDelay);
    if (!mounted) return;
    _textCtrl.forward();

    await Future.delayed(_vm.taglineDelay);
    if (!mounted) return;
    _taglineCtrl.forward();

    await Future.delayed(_vm.navDelay);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity:
              CurvedAnimation(parent: animation, curve: Curves.easeIn),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _taglineCtrl.dispose();
    _ringCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Logo with ring burst ────────────────────────────────────
            SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ring 1
                  AnimatedBuilder(
                    animation: _ringCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _ringOpacity.value,
                      child: Transform.scale(
                        scale: _ringScale.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF4D96FF),
                                width: 2.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Ring 2
                  AnimatedBuilder(
                    animation: _ringCtrl,
                    builder: (_, __) => Opacity(
                      opacity:
                          (_ringOpacity.value * 0.5).clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale:
                            (_ringScale.value * 0.75).clamp(0.0, 2.0),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF6BCB77),
                                width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Logo image
                  AnimatedBuilder(
                    animation:
                        Listenable.merge([_logoCtrl, _pulseCtrl]),
                    builder: (_, __) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value * _pulse.value,
                        child: Image.asset(
                          'assets/images/logo2.jpg',
                          width: 210,
                          height: 210,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Brand name ──────────────────────────────────────────────
            AnimatedBuilder(
              animation: _textCtrl,
              builder: (_, __) => FadeTransition(
                opacity: _textOpacity,
                child: SlideTransition(
                  position: _textSlide,
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        const LinearGradient(colors: [
                      Color(0xFF4D96FF),
                      Color(0xFF6BCB77),
                    ]).createShader(bounds),
                    child: const Text(
                      'NeuroSense',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Tagline ─────────────────────────────────────────────────
            AnimatedBuilder(
              animation: _taglineCtrl,
              builder: (_, __) => FadeTransition(
                opacity: _taglineOpacity,
                child: const Text(
                  'Understanding every child, together.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFFAAAAAA),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            // ── Loading dots ────────────────────────────────────────────
            AnimatedBuilder(
              animation: _taglineCtrl,
              builder: (_, __) => FadeTransition(
                opacity: _taglineOpacity,
                child: const _LoadingDots(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated loading dots (private widget — belongs to this view) ─────────

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  static const _colors = [
    Color(0xFF4D96FF),
    Color(0xFF6BCB77),
    Color(0xFFFFD93D),
    Color(0xFFFF6B6B),
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      final ctrl = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500));
      final anim = Tween<double>(begin: 0.0, end: -10.0).animate(
          CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
      _controllers.add(ctrl);
      _animations.add(anim);
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _animations[i].value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                  color: _colors[i], shape: BoxShape.circle),
            ),
          ),
        );
      }),
    );
  }
}
