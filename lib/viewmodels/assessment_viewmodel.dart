import 'package:flutter/foundation.dart';
import '../../models/assessment_model.dart';

class AssessmentViewModel extends ChangeNotifier {
  List<Assessment> _assessments = [];
  bool _isLoading = false;
  String? _errorMessage;
  AssessmentFilter _activeFilter = AssessmentFilter.all;

  List<Assessment> get assessments => _filteredAssessments();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AssessmentFilter get activeFilter => _activeFilter;

  int get completedCount =>
      _assessments.where((a) => a.isComplete).length;
  int get totalCount => _assessments.length;
  double get overallProgress =>
      totalCount == 0 ? 0 : completedCount / totalCount;

  AssessmentViewModel() {
    _loadAssessments();
  }

  void _loadAssessments() {
    _isLoading = true;
    notifyListeners();

    // Simulate async load
    Future.delayed(const Duration(milliseconds: 300), () {
      _assessments = _mockAssessments();
      _isLoading = false;
      notifyListeners();
    });
  }

  List<Assessment> _filteredAssessments() {
    switch (_activeFilter) {
      case AssessmentFilter.completed:
        return _assessments.where((a) => a.isComplete).toList();
      case AssessmentFilter.inProgress:
        return _assessments.where((a) => a.isInProgress).toList();
      case AssessmentFilter.locked:
        return _assessments.where((a) => a.isLocked).toList();
      case AssessmentFilter.all:
      default:
        return List.from(_assessments);
    }
  }

  void setFilter(AssessmentFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  Future<void> refreshAssessments() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _assessments = _mockAssessments();
    _isLoading = false;
    notifyListeners();
  }

  void startAssessment(String id) {
    final index = _assessments.indexWhere((a) => a.id == id);
    if (index == -1) return;

    final updated = List<Assessment>.from(_assessments);
    final a = updated[index];
    if (a.isLocked) return;

    updated[index] = Assessment(
      id: a.id,
      name: a.name,
      description: a.description,
      imagePath: a.imagePath,
      status: AssessmentStatus.inProgress,
      requirementText: a.requirementText,
      availabilityText: a.availabilityText,
      progressValue: 0.1,
      lastTestDate: a.lastTestDate,
      orderIndex: a.orderIndex,
    );
    _assessments = updated;
    notifyListeners();
  }

  List<Assessment> _mockAssessments() => [
        const Assessment(
          id: '1',
          name: 'Q-Chat',
          description: 'Communication screening test',
          imagePath: '📋',
          status: AssessmentStatus.inProgress,
          progressValue: 0.65,
          lastTestDate: 'Today',
          orderIndex: 1,
        ),
        const Assessment(
          id: '2',
          name: 'Eye Gaze',
          description: 'Visual attention test',
          imagePath: '👁️',
          status: AssessmentStatus.locked,
          requirementText: 'Complete Q-Chat first',
          orderIndex: 2,
        ),
        const Assessment(
          id: '3',
          name: 'Stereotypical',
          description: 'Repetitive behavior test',
          imagePath: '🔄',
          status: AssessmentStatus.locked,
          availabilityText: 'Available at age 2+',
          orderIndex: 3,
        ),
        const Assessment(
          id: '4',
          name: 'Social Emotional',
          description: 'Social emotional skills test',
          imagePath: '🤝',
          status: AssessmentStatus.locked,
          requirementText: 'Complete Q-Chat first',
          orderIndex: 4,
        ),
        const Assessment(
          id: '5',
          name: 'Graphmotor',
          description: 'Fine motor skills test',
          imagePath: '✏️',
          status: AssessmentStatus.locked,
          availabilityText: 'Available at age 4+',
          orderIndex: 5,
        ),
        const Assessment(
          id: '6',
          name: 'Audio',
          description: 'Auditory processing test',
          imagePath: '🎧',
          status: AssessmentStatus.locked,
          requirementText: 'Complete Q-Chat first',
          orderIndex: 6,
        ),
      ];
}

enum AssessmentFilter { all, inProgress, completed, locked }
