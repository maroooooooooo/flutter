import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/graphmotor_viewmodel.dart';

class GraphmotorScreen extends StatefulWidget {
  const GraphmotorScreen({Key? key}) : super(key: key);

  @override
  State<GraphmotorScreen> createState() => _GraphmotorScreenState();
}

class _GraphmotorScreenState extends State<GraphmotorScreen>
    with TickerProviderStateMixin {
  late AnimationController _letterController;
  late AnimationController _cardController;
  late Animation<double> _letterScale;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();
    _letterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _letterScale = CurvedAnimation(
      parent: _letterController,
      curve: Curves.elasticOut,
    );
    _cardFade = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOut,
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutCubic,
    ));

    _letterController.forward();
    _cardController.forward();
  }

  void _animateToNext() {
    _letterController.reset();
    _cardController.reset();
    _letterController.forward();
    _cardController.forward();
  }

  @override
  void dispose() {
    _letterController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GraphmotorViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        body: SafeArea(
          child: Consumer<GraphmotorViewModel>(
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

  Widget _buildTopBar(BuildContext context, GraphmotorViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // Back button
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
          // Progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${vm.currentQuestion.questionNumber}',
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    child: LinearProgressIndicator(
                      value: vm.progress,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF3B82F6),
                      ),
                      minHeight: 7,
                    ),
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

  Widget _buildTitle(GraphmotorViewModel vm) {
    return Column(
      children: [
        const Text(
          'Graphmotor test',
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

  Widget _buildMainCard(GraphmotorViewModel vm) {
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
              // Letter display area
              _buildLetterArea(vm),

              // Divider with dots
              Padding(
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
              ),

              // Upload area
              _buildUploadArea(vm),
            ],
          ),
        ),
      ),
    );
  }

  // ── LETTER AREA ──────────────────────────────────────────────────────────────

  Widget _buildLetterArea(GraphmotorViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
      child: ScaleTransition(
        scale: _letterScale,
        child: Text(
          vm.currentQuestion.letter,
          style: const TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D4A7A),
            height: 1.0,
          ),
        ),
      ),
    );
  }

  // ── UPLOAD AREA ──────────────────────────────────────────────────────────────

  Widget _buildUploadArea(GraphmotorViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        children: [
          // Instruction text
          Text(
            vm.currentQuestion.uploadPrompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),

          // Upload button / preview
          if (vm.hasImage)
            _buildImagePreview(vm)
          else
            _buildUploadButton(vm),

          // Error message
          if (vm.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

  Widget _buildUploadButton(GraphmotorViewModel vm) {
    return GestureDetector(
      onTap: vm.isUploading ? null : vm.pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: vm.isUploading
              ? const Color(0xFFEFF6FF)
              : const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(14),
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 18,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Upload photo',
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

  Widget _buildImagePreview(GraphmotorViewModel vm) {
    final file = vm.uploadedImage!;

    // Build the image widget depending on platform
    Widget imageWidget;
    if (kIsWeb && file.bytes != null) {
      imageWidget = Image.memory(file.bytes!, fit: BoxFit.cover);
    } else if (!kIsWeb && file.path != null) {
      imageWidget = Image.file(File(file.path!), fit: BoxFit.cover);
    } else {
      imageWidget = const Center(
        child: Icon(Icons.image_rounded, size: 48, color: Color(0xFF10B981)),
      );
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF10B981), width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageWidget,
          ),
        ),

        // Success badge
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_rounded, size: 12, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Uploaded',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Remove button
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: vm.removeImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF64748B)),
            ),
          ),
        ),
      ],
    );
  }

  // ── CONTINUE BUTTON ──────────────────────────────────────────────────────────

  Widget _buildContinueButton(BuildContext context, GraphmotorViewModel vm) {
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
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
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
                'You have completed the Graphmotor test. Your results have been submitted.',
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
                    Navigator.pop(context); // back to assessment screen
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
