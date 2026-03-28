import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/stereotypical_viewmodel.dart';

class StereotypicalScreen extends StatefulWidget {
  const StereotypicalScreen({Key? key}) : super(key: key);

  @override
  State<StereotypicalScreen> createState() => _StereotypicalScreenState();
}

class _StereotypicalScreenState extends State<StereotypicalScreen>
    with TickerProviderStateMixin {
  late AnimationController _illustrationController;
  late AnimationController _cardController;
  late AnimationController _pulseController;

  late Animation<double> _illustrationScale;
  late Animation<double> _illustrationFade;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _illustrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _illustrationScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _illustrationController,
        curve: Curves.elasticOut,
      ),
    );
    _illustrationFade = CurvedAnimation(
      parent: _illustrationController,
      curve: Curves.easeOut,
    );
    _cardFade = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOut,
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));
    _pulse = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _illustrationController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _cardController.forward();
    });
  }

  void _animateToNext() {
    _illustrationController.reset();
    _cardController.reset();
    _illustrationController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _cardController.forward();
    });
  }

  @override
  void dispose() {
    _illustrationController.dispose();
    _cardController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StereotypicalViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: SafeArea(
          child: Consumer<StereotypicalViewModel>(
            builder: (context, vm, _) {
              return Column(
                children: [
                  _buildTopBar(context, vm),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          _buildTitle(vm),
                          const SizedBox(height: 24),
                          _buildMainCard(vm),
                          const SizedBox(height: 24),
                          _buildContinueButton(context, vm),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ── TOP BAR ─────────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context, StereotypicalViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Activity ${vm.currentQuestion.questionNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      '${vm.currentQuestion.questionNumber}/${vm.currentQuestion.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: vm.progress,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF3B82F6),
                    ),
                    minHeight: 7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TITLE ────────────────────────────────────────────────────────────────────

  Widget _buildTitle(StereotypicalViewModel vm) {
    return Column(
      children: [
        const Text(
          'Stereotypical test',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A202C),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          vm.currentQuestion.instruction,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── MAIN CARD ────────────────────────────────────────────────────────────────

  Widget _buildMainCard(StereotypicalViewModel vm) {
    return FadeTransition(
      opacity: _cardFade,
      child: SlideTransition(
        position: _cardSlide,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildIllustrationArea(vm),
              _buildDividerDots(),
              _buildRecordArea(vm),
            ],
          ),
        ),
      ),
    );
  }

  // ── ILLUSTRATION AREA ────────────────────────────────────────────────────────

  Widget _buildIllustrationArea(StereotypicalViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: FadeTransition(
        opacity: _illustrationFade,
        child: ScaleTransition(
          scale: _illustrationScale,
          child: Column(
            children: [
              // Activity label chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.play_circle_rounded,
                      size: 14,
                      color: Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vm.currentQuestion.activityTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Illustration placeholder — emoji + animated ring
              ScaleTransition(
                scale: _pulse,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow ring
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEFF6FF),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.15),
                          width: 2,
                        ),
                      ),
                    ),
                    // Inner circle
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          vm.currentQuestion.activityImagePath,
                          style: const TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Watch instruction
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_rounded,
                      size: 15,
                      color: Color(0xFF64748B),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Watch the activity carefully',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── DIVIDER DOTS ─────────────────────────────────────────────────────────────

  Widget _buildDividerDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFFCBD5E1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── RECORD AREA ──────────────────────────────────────────────────────────────

  Widget _buildRecordArea(StereotypicalViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        children: [
          Text(
            vm.currentQuestion.recordPrompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),

          // Video upload / preview
          if (vm.hasVideo)
            _buildVideoPreview(vm)
          else
            _buildRecordButton(vm),

          // Error
          if (vm.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vm.errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecordButton(StereotypicalViewModel vm) {
    return GestureDetector(
      onTap: vm.isUploading ? null : vm.pickVideo,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: vm.isUploading
              ? const Color(0xFFEFF6FF)
              : const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF3B82F6),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: vm.isUploading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.videocam_outlined,
                      size: 20,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Record child',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildVideoPreview(StereotypicalViewModel vm) {
    final video = vm.uploadedVideo!;

    return Column(
      children: [
        // Video info card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF10B981),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Video icon container
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Color(0xFF10B981),
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),

              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A202C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_rounded,
                                size: 11,
                                color: Colors.white,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Uploaded',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          vm.videoSizeLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Remove button
              GestureDetector(
                onTap: vm.removeVideo,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Re-upload option
        GestureDetector(
          onTap: vm.pickVideo,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.refresh_rounded,
                size: 15,
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(width: 5),
              const Text(
                'Choose a different video',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── CONTINUE BUTTON ──────────────────────────────────────────────────────────

  Widget _buildContinueButton(
      BuildContext context, StereotypicalViewModel vm) {
    final canTap = vm.canContinue;

    return GestureDetector(
      onTap: canTap
          ? () async {
              final isDone = await vm.submitAndContinue();
              if (isDone && context.mounted) {
                _showCompletionDialog(context);
              } else {
                _animateToNext();
              }
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: canTap
              ? const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: canTap ? null : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(18),
          boxShadow: canTap
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: vm.isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
                  vm.isLastQuestion ? 'Finish' : 'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: canTap ? Colors.white : const Color(0xFFB0BEC5),
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }

  // ── COMPLETION DIALOG ────────────────────────────────────────────────────────

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 42,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Test Complete!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A202C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You have completed the Stereotypical test. All recordings have been submitted successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // back to assessments
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to Assessments',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
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
