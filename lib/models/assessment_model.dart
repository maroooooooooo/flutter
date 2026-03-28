class Assessment {
  final String id;
  final String name;
  final String description;
  final String imagePath; // emoji or asset
  final AssessmentStatus status;
  final String? requirementText;
  final String? availabilityText;
  final double? progressValue; // 0.0 to 1.0, null if not started
  final String? lastTestDate;
  final int orderIndex;

  const Assessment({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.status,
    this.requirementText,
    this.availabilityText,
    this.progressValue,
    this.lastTestDate,
    required this.orderIndex,
  });

  bool get isLocked => status == AssessmentStatus.locked;
  bool get isComplete => status == AssessmentStatus.complete;
  bool get isInProgress => status == AssessmentStatus.inProgress;
  bool get isAvailable => status == AssessmentStatus.available;
}

enum AssessmentStatus {
  inProgress,
  available,
  complete,
  locked,
}
