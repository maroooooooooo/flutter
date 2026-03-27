import 'package:flutter/foundation.dart';
import '../../models/child_model.dart';

class HomeViewModel extends ChangeNotifier {
  Child? _currentChild;
  bool _isLoading = false;
  String? _errorMessage;

  Child? get currentChild => _currentChild;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasChild => _currentChild != null;

  HomeViewModel() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _currentChild = Child(
      id: '1',
      name: 'Mario',
      avatarUrl: null, // Will use emoji
      overallProgress: 60,
      lastTestName: 'Q-chat',
      lastTestDate: 'Today',
      assessmentSteps: [
        AssessmentStep(
          stepNumber: 1,
          name: 'Q-Chat',
          status: 'complete',
          subtitle: 'Last test: Today',
        ),
        AssessmentStep(
          stepNumber: 2,
          name: 'Eye gaze',
          status: 'locked',
          subtitle: 'Q-chat required',
        ),
      ],
    );
    notifyListeners();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void updateChildProgress(int newProgress) {
    if (_currentChild != null) {
      _currentChild = Child(
        id: _currentChild!.id,
        name: _currentChild!.name,
        avatarUrl: _currentChild!.avatarUrl,
        overallProgress: newProgress,
        lastTestName: _currentChild!.lastTestName,
        lastTestDate: _currentChild!.lastTestDate,
        assessmentSteps: _currentChild!.assessmentSteps,
      );
      notifyListeners();
    }
  }

  void completeAssessmentStep(int stepNumber) {
    if (_currentChild != null) {
      final updatedSteps = _currentChild!.assessmentSteps.map((step) {
        if (step.stepNumber == stepNumber) {
          return AssessmentStep(
            stepNumber: step.stepNumber,
            name: step.name,
            status: 'complete',
            subtitle: step.subtitle,
          );
        } else if (step.stepNumber == stepNumber + 1 && step.isLocked) {
          return AssessmentStep(
            stepNumber: step.stepNumber,
            name: step.name,
            status: 'in_progress',
            subtitle: step.subtitle,
          );
        }
        return step;
      }).toList();

      _currentChild = Child(
        id: _currentChild!.id,
        name: _currentChild!.name,
        avatarUrl: _currentChild!.avatarUrl,
        overallProgress: _currentChild!.overallProgress,
        lastTestName: _currentChild!.lastTestName,
        lastTestDate: _currentChild!.lastTestDate,
        assessmentSteps: updatedSteps,
      );
      notifyListeners();
    }
  }

  void selectChild(Child child) {
    _currentChild = child;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
