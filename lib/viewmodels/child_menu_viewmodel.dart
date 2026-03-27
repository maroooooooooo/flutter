import 'package:flutter/foundation.dart';
import 'package:projects/models/child_model.dart';

class ChildMenuViewModel extends ChangeNotifier {
  List<Child> _children = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Child> get children => _children;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasChildren => _children.isNotEmpty;

  ChildMenuViewModel() {
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    _isLoading = true;
    notifyListeners();

    // Mock data
    await Future.delayed(const Duration(milliseconds: 500));

    _children = [
      Child(
        id: '1',
        name: 'Mario',
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
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addChild(String name) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final newChild = Child(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      overallProgress: 0,
      lastTestName: 'None',
      lastTestDate: 'Never',
      assessmentSteps: [
        AssessmentStep(
          stepNumber: 1,
          name: 'Q-Chat',
          status: 'in_progress',
          subtitle: 'Start your first assessment',
        ),
        AssessmentStep(
          stepNumber: 2,
          name: 'Eye gaze',
          status: 'locked',
          subtitle: 'Complete Q-Chat first',
        ),
      ],
    );

    _children.add(newChild);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteChild(String childId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _children.removeWhere((child) => child.id == childId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> editChild(String childId, String newName) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    final index = _children.indexWhere((child) => child.id == childId);
    if (index != -1) {
      _children[index] = Child(
        id: _children[index].id,
        name: newName,
        avatarUrl: _children[index].avatarUrl,
        overallProgress: _children[index].overallProgress,
        lastTestName: _children[index].lastTestName,
        lastTestDate: _children[index].lastTestDate,
        assessmentSteps: _children[index].assessmentSteps,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
