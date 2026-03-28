class StereotypicalQuestion {
  final int questionNumber;
  final int totalQuestions;
  final String activityImagePath; // emoji or asset path
  final String activityTitle;
  final String instruction;
  final String recordPrompt;

  const StereotypicalQuestion({
    required this.questionNumber,
    required this.totalQuestions,
    required this.activityImagePath,
    required this.activityTitle,
    required this.instruction,
    required this.recordPrompt,
  });
}

class StereotypicalResult {
  final int questionNumber;
  final String activityTitle;
  final String uploadedVideoName;
  final int videoSizeBytes;
  final DateTime submittedAt;

  const StereotypicalResult({
    required this.questionNumber,
    required this.activityTitle,
    required this.uploadedVideoName,
    required this.videoSizeBytes,
    required this.submittedAt,
  });
}
