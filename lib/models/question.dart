/// Model for a single quiz question with options and correct answer index.
class Question {
  final String question;
  final List<String> options;
  final int correctAnsIndex;

  const Question({
    required this.question,
    required this.options,
    required this.correctAnsIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correctAnsIndex: json['correctAnsIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options,
        'correctAnsIndex': correctAnsIndex,
      };
}
