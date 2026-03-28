class GraphmotorQuestion {
  final int questionNumber;
  final int totalQuestions;
  final String letter;
  final String instruction;
  final String uploadPrompt;

  const GraphmotorQuestion({
    required this.questionNumber,
    required this.totalQuestions,
    required this.letter,
    required this.instruction,
    required this.uploadPrompt,
  });
}

class GraphmotorResult {
  final String letter;
  final String uploadedImagePath;
  final DateTime submittedAt;

  const GraphmotorResult({
    required this.letter,
    required this.uploadedImagePath,
    required this.submittedAt,
  });
}
