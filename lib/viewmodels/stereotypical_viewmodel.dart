import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/stereotypical_model.dart';

class StereotypicalViewModel extends ChangeNotifier {
  final List<StereotypicalQuestion> _questions = const [
    StereotypicalQuestion(
      questionNumber: 1,
      totalQuestions: 4,
      activityImagePath: '🚪',
      activityTitle: 'Door Spinning',
      instruction: 'Please look at the activity carefully',
      recordPrompt:
          'Look at the activity well then it\'s your turn — record your child doing the same.',
    ),
    StereotypicalQuestion(
      questionNumber: 2,
      totalQuestions: 4,
      activityImagePath: '🤲',
      activityTitle: 'Hand Flapping',
      instruction: 'Please look at the activity carefully',
      recordPrompt:
          'Look at the activity well then it\'s your turn — record your child doing the same.',
    ),
    StereotypicalQuestion(
      questionNumber: 3,
      totalQuestions: 4,
      activityImagePath: '🔄',
      activityTitle: 'Body Rocking',
      instruction: 'Please look at the activity carefully',
      recordPrompt:
          'Look at the activity well then it\'s your turn — record your child doing the same.',
    ),
    StereotypicalQuestion(
      questionNumber: 4,
      totalQuestions: 4,
      activityImagePath: '👀',
      activityTitle: 'Eye Contact',
      instruction: 'Please look at the activity carefully',
      recordPrompt:
          'Look at the activity well then it\'s your turn — record your child doing the same.',
    ),
  ];

  int _currentIndex = 0;
  PlatformFile? _uploadedVideo;
  bool _isUploading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  final List<StereotypicalResult> _results = [];

  // ── Getters ──────────────────────────────────────────────────────────────────

  StereotypicalQuestion get currentQuestion => _questions[_currentIndex];
  PlatformFile? get uploadedVideo => _uploadedVideo;
  bool get isUploading => _isUploading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  bool get hasVideo => _uploadedVideo != null;
  bool get canContinue => hasVideo && !_isSubmitting;
  bool get isLastQuestion => _currentIndex == _questions.length - 1;
  List<StereotypicalResult> get results => List.unmodifiable(_results);
  double get progress => (_currentIndex + 1) / _questions.length;

  String get videoSizeLabel {
    if (_uploadedVideo == null) return '';
    final bytes = _uploadedVideo!.size;
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // ── Actions ──────────────────────────────────────────────────────────────────

  Future<void> pickVideo() async {
    _errorMessage = null;
    _isUploading = true;
    notifyListeners();

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        _uploadedVideo = result.files.first;
      }
    } catch (e) {
      _errorMessage = 'Could not pick video. Please try again.';
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void removeVideo() {
    _uploadedVideo = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> submitAndContinue() async {
    if (!canContinue) return false;

    _isSubmitting = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    _results.add(StereotypicalResult(
      questionNumber: currentQuestion.questionNumber,
      activityTitle: currentQuestion.activityTitle,
      uploadedVideoName: _uploadedVideo!.name,
      videoSizeBytes: _uploadedVideo!.size,
      submittedAt: DateTime.now(),
    ));

    if (isLastQuestion) {
      _isSubmitting = false;
      notifyListeners();
      return true;
    }

    _currentIndex++;
    _uploadedVideo = null;
    _isSubmitting = false;
    notifyListeners();
    return false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
