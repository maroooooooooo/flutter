import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// COMMON WIDGETS
// ════════════════════════════════════════════════════════════════════════════

// ── Shared input decoration ───────────────────────────────────────────────

InputDecoration fieldDecoration({
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

// ── Social button shell ───────────────────────────────────────────────────

class SocialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const SocialButton({super.key, required this.child, this.onTap});

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

// ── Google "G" icon ───────────────────────────────────────────────────────

class GoogleIcon extends StatefulWidget {
  const GoogleIcon({super.key});

  @override
  State<GoogleIcon> createState() => _GoogleIconState();
}

class _GoogleIconState extends State<GoogleIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return CustomPaint(
            painter: GooglePainter(controller.value), // ✅ FIX
          );
        },
      ),
    );
  }
}

class GooglePainter extends CustomPainter {
  final double animationValue;

  GooglePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final segments = [
      (0.0, 0.5, const Color(0xFF4285F4)),
      (0.5, 0.75, const Color(0xFF34A853)),
      (0.75, 0.92, const Color(0xFFFBBC05)),
      (0.92, 1.0, const Color(0xFFEA4335)),
    ];

    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];

      final paint = Paint()
        ..color = seg.$3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      // 🔥 Wave / rotation effect
      final shift = animationValue * 2 * 3.14159;
      final delay = i * 0.3; // makes wave between segments

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 2),
        (seg.$1 * 2 * 3.14159) + shift + delay,
        (seg.$2 - seg.$1) * 2 * 3.14159,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GooglePainter oldDelegate) => true;
}
class AnimatedGoogleLoader extends StatefulWidget {
  const AnimatedGoogleLoader({super.key});

  @override
  State<AnimatedGoogleLoader> createState() => _AnimatedGoogleLoaderState();
}

class _AnimatedGoogleLoaderState extends State<AnimatedGoogleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // 🔥 infinite loop
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return CustomPaint(
          size: const Size(40, 40),
          painter: GooglePainter(controller.value),
        );
      },
    );
  }
}

// ── Gmail "M" icon ────────────────────────────────────────────────────────

class GmailIcon extends StatelessWidget {
  const GmailIcon({super.key});

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

// ════════════════════════════════════════════════════════════════════════════
// COMMON WIDGETS
// ════════════════════════════════════════════════════════════════════════════

// ── Stanford Logo ─────────────────────────────────────────────────────────

class StanfordLogo extends StatelessWidget {
  const StanfordLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 52,
          height: 60,
          child: CustomPaint(painter: ShieldPainter()),
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

// ── Shield Painter ────────────────────────────────────────────────────────

class ShieldPainter extends CustomPainter {
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