class Test {
  final String year;
  final String level;
  final Map<String, List<Question>> questions;

  Test({
    required this.year,
    required this.level,
    required this.questions,
  });
}

class Question {
  final String? image;
  final String questionText;
  final List<String> answers;
  final int? correctAnswerIndex;

  Question({
    this.image,
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
  });
}
