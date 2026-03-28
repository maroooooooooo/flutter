import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../../models/graphmotor_model.dart';

class GraphmotorViewModel extends ChangeNotifier {
  final List<GraphmotorQuestion> _questions = const [
    GraphmotorQuestion(
      questionNumber: 1,
      totalQuestions: 5,
      letter: 'A',
      instruction: 'Please look at the letter carefully',
      uploadPrompt: 'Write the same letter on a white paper, then upload the photo of it.',
    ),
    GraphmotorQuestion(
      questionNumber: 2,
      totalQuestions: 5,
      letter: 'B',
      instruction: 'Please look at the letter carefully',
      uploadPrompt: 'Write the same letter on a white paper, then upload the photo of it.',
    ),
    GraphmotorQuestion(
      questionNumber: 3,
      totalQuestions: 5,
      letter: 'C',
      instruction: 'Please look at the letter carefully',
      uploadPrompt: 'Write the same letter on a white paper, then upload the photo of it.',
    ),
    GraphmotorQuestion(
      questionNumber: 4,
      totalQuestions: 5,
      letter: 'D',
      instruction: 'Please look at the letter carefully',
      uploadPrompt: 'Write the same letter on a white paper, then upload the photo of it.',
    ),
    GraphmotorQuestion(
      questionNumber: 5,
      totalQuestions: 5,
      letter: 'E',
      instruction: 'Please look at the letter carefully',
      uploadPrompt: 'Write the same letter on a white paper, then upload the photo of it.',
    ),
  ];

  int _currentIndex = 0;
  PlatformFile? _uploadedImage;
  bool _isUploading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  final List<GraphmotorResult> _results = [];

  // ── Getters ──────────────────────────────────────────────────────────────────

  GraphmotorQuestion get currentQuestion => _questions[_currentIndex];
  PlatformFile? get uploadedImage => _uploadedImage;
  bool get isUploading => _isUploading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get hasImage => _uploadedImage != null;
  bool get canContinue => hasImage && !_isSubmitting;
  bool get isLastQuestion => _currentIndex == _questions.length - 1;
  List<GraphmotorResult> get results => List.unmodifiable(_results);
  double get progress => (_currentIndex + 1) / _questions.length;

  // ── Actions ──────────────────────────────────────────────────────────────────

  Future<void> pickImage() async {
    _errorMessage = null;
    _isUploading = true;
    notifyListeners();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // important for web support
      );

      if (result != null && result.files.isNotEmpty) {
        _uploadedImage = result.files.first;
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image. Please try again.';
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void removeImage() {
    _uploadedImage = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitAndContinue() async {
    if (!canContinue) return false;

    _isSubmitting = true;
    notifyListeners();

    // Simulate upload/submit
    await Future.delayed(const Duration(milliseconds: 600));

    _results.add(GraphmotorResult(
      letter: currentQuestion.letter,
      uploadedImagePath: _uploadedImage!.name, // was .path
      submittedAt: DateTime.now(),
    ));

    if (isLastQuestion) {
      _isSubmitting = false;
      notifyListeners();
      return true; // signal completion
    }

    _currentIndex++;
    _uploadedImage = null;
    _isSubmitting = false;
    notifyListeners();
    return false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
