/*import 'package:flutter/material.dart';
import 'package:projects/screen_4.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════════════════

class TermsModel {
  final String body;
  const TermsModel({required this.body});
}

const _termsContent = TermsModel(
  body:
      'Welcome to [Your App Name]. By using this application, you agree to the '
      'following Terms and Conditions. If you do not agree, please discontinue use of the app.\n\n'
      '[Your App Name] is designed to support early autism screening and behavioral '
      'observation for children. The app is intended for parents, caregivers, and '
      'healthcare professionals. The information and screening results provided are for '
      'educational and informational purposes only and do not constitute a medical '
      'diagnosis or professional medical advice.\n\n'
      'By using this app, you acknowledge that all data collected, including videos, '
      'is handled in accordance with our Privacy Policy. Video recordings may be used '
      'for research and scientific purposes based on your consent selections above.\n\n'
      'You agree not to misuse the application or attempt to access it in unauthorized '
      'ways. Affiliated institutions are not liable for decisions made based on app output.\n\n'
      'By tapping "I Accept," you confirm that you have read, understood, and agree to these terms.',
);

const List<String> _consentLabels = [
  'My video(s) can be shown to the public for research and scientific purposes only.',
  'My video(s) can be shown to the public for research and scientific purposes only.',
  'My video(s) can be shown to the public for research and scientific purposes only.',
];

// ════════════════════════════════════════════════════════════════════════════
// VIEW-MODEL
// ════════════════════════════════════════════════════════════════════════════

class TermsViewModel extends ChangeNotifier {
  final List<bool> _switches = [false, false, false];

  bool switchAt(int i) => _switches[i];
  bool get allAccepted => _switches.every((s) => s);

  void toggle(int index) {
    _switches[index] = !_switches[index];
    notifyListeners();
  }

  void acceptTerms() {
    if (!allAccepted) return;
    debugPrint('Terms accepted!');
    // TODO: navigate to next screen
  }
}

// ════════════════════════════════════════════════════════════════════════════
// VIEW  –  entry point
// ════════════════════════════════════════════════════════════════════════════

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TermsViewModel(),
      child: const _TermsView(),
    );
  }
}

// ── Root scaffold ─────────────────────────────────────────────────────────

class _TermsView extends StatelessWidget {
  const _TermsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back chevron
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black87),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 10),
                    Center(child: _StanfordLogo()),
                    SizedBox(height: 36),
                    _ConsentSwitches(),
                    SizedBox(height: 24),
                    _TermsBody(),
                    SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _AcceptButton(),
    );
  }
}

// ── Stanford Logo ─────────────────────────────────────────────────────────

class _StanfordLogo extends StatelessWidget {
  const _StanfordLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 52,
          height: 60,
          child: CustomPaint(painter: _ShieldPainter()),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'STANFORD',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF8C1515),
                letterSpacing: 1.5,
                height: 1.1,
              ),
            ),
            Text(
              'SCHOOL OF MEDICINE',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8C1515),
                letterSpacing: 1.8,
                height: 1.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const red = Color(0xFF8C1515);
    const gold = Color(0xFFB6862C);

    final shield = Path()
      ..moveTo(size.width * 0.1, 0)
      ..lineTo(size.width * 0.9, 0)
      ..lineTo(size.width * 0.9, size.height * 0.65)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.95, size.width * 0.5, size.height)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.95, size.width * 0.1, size.height * 0.65)
      ..close();

    canvas.drawPath(shield, Paint()..color = red);
    canvas.drawPath(
      shield,
      Paint()
        ..color = gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // White cross
    final cross = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * .5, size.height * .12), Offset(size.width * .5, size.height * .75), cross);
    canvas.drawLine(Offset(size.width * .22, size.height * .38), Offset(size.width * .78, size.height * .38), cross);

    // Simple tree
    final tree = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawRect(Rect.fromLTWH(size.width * .46, size.height * .62, size.width * .08, size.height * .16), tree);
    final foliage = Path()
      ..moveTo(size.width * .5, size.height * .18)
      ..lineTo(size.width * .35, size.height * .48)
      ..lineTo(size.width * .40, size.height * .48)
      ..lineTo(size.width * .30, size.height * .65)
      ..lineTo(size.width * .70, size.height * .65)
      ..lineTo(size.width * .60, size.height * .48)
      ..lineTo(size.width * .65, size.height * .48)
      ..close();
    canvas.drawPath(foliage, tree);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ── Consent switches ──────────────────────────────────────────────────────

class _ConsentSwitches extends StatelessWidget {
  const _ConsentSwitches();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TermsViewModel>();
    return Column(
      children: List.generate(
        _consentLabels.length,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  value: vm.switchAt(i),
                  onChanged: (_) => context.read<TermsViewModel>().toggle(i),
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF34C759),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE5E5EA),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _consentLabels[i],
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF333333),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Terms body text ───────────────────────────────────────────────────────

class _TermsBody extends StatelessWidget {
  const _TermsBody();

  @override
  Widget build(BuildContext context) {
    return Text(
      _termsContent.body,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF333333),
        height: 1.55,
      ),
    );
  }
}

// ── Accept button ─────────────────────────────────────────────────────────

class _AcceptButton extends StatelessWidget {
  const _AcceptButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TermsViewModel>();
    final enabled = vm.allAccepted;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: enabled
                    ? () {
                        final vm = context.read<TermsViewModel>();
                        vm.acceptTerms();

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (_, __, ___) => const WhatAreYouScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0), // from right
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                child: child,
                              );
                            },
                          ),
                        );
                      }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              disabledBackgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'I Accept',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/