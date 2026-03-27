// Model: represents a single child's data
// TODO: Map this to your backend API / Firestore document structure

class ChildModel {
  final String name;
  final String language;
  final String dateOfBirth;
  final String gender;
  final bool hadDiagnosis;
  final String country;
  final String city;
  final String workingNumber;
  final List<String> selectedDoctors;

  ChildModel({
    this.name = '',
    this.language = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.hadDiagnosis = false,
    this.country = '',
    this.city = '',
    this.workingNumber = '',
    this.selectedDoctors = const [],
  });

  ChildModel copyWith({
    String? name,
    String? language,
    String? dateOfBirth,
    String? gender,
    bool? hadDiagnosis,
    String? country,
    String? city,
    String? workingNumber,
    List<String>? selectedDoctors,
  }) {
    return ChildModel(
      name: name ?? this.name,
      language: language ?? this.language,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      hadDiagnosis: hadDiagnosis ?? this.hadDiagnosis,
      country: country ?? this.country,
      city: city ?? this.city,
      workingNumber: workingNumber ?? this.workingNumber,
      selectedDoctors: selectedDoctors ?? this.selectedDoctors,
    );
  }

  // TODO: fromJson / toJson when connecting to backend
  Map<String, dynamic> toJson() => {
        'name': name,
        'language': language,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'had_diagnosis': hadDiagnosis,
        'country': country,
        'city': city,
        'working_number': workingNumber,
        'selected_doctors': selectedDoctors,
      };
}
class Child {
  final String id;
  final String name;
  final String? avatarUrl;
  final int overallProgress;
  final String lastTestName;
  final String lastTestDate;
  final List<AssessmentStep> assessmentSteps;

  const Child({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.overallProgress,
    required this.lastTestName,
    required this.lastTestDate,
    required this.assessmentSteps,
  });

  // 🔥 copyWith (VERY IMPORTANT for ViewModels)
  Child copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? overallProgress,
    String? lastTestName,
    String? lastTestDate,
    List<AssessmentStep>? assessmentSteps,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      overallProgress: overallProgress ?? this.overallProgress,
      lastTestName: lastTestName ?? this.lastTestName,
      lastTestDate: lastTestDate ?? this.lastTestDate,
      assessmentSteps: assessmentSteps ?? this.assessmentSteps,
    );
  }
}
class AssessmentStep {
  final int stepNumber;
  final String name;
  final String status; // 'complete', 'in_progress', 'locked'
  final String subtitle;

  const AssessmentStep({
    required this.stepNumber,
    required this.name,
    required this.status,
    required this.subtitle,
  });

  // 🔥 Helper getters (VERY useful for UI)
  bool get isComplete => status == 'complete';
  bool get isInProgress => status == 'in_progress';
  bool get isLocked => status == 'locked';

  // 🔥 copyWith
  AssessmentStep copyWith({
    int? stepNumber,
    String? name,
    String? status,
    String? subtitle,
  }) {
    return AssessmentStep(
      stepNumber: stepNumber ?? this.stepNumber,
      name: name ?? this.name,
      status: status ?? this.status,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}