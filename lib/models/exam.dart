/// Represents an exam/assignment entry for the assignments list.
enum ExamStatus {
  ongoing,
  completed,
  unattended,
}

/// One question's result for a completed exam: correct answer and user's choice.
class ExamAnswer {
  final String question;
  final List<String> options;
  final int correctAnsIndex;
  final int userSelectedIndex;

  const ExamAnswer({
    required this.question,
    required this.options,
    required this.correctAnsIndex,
    required this.userSelectedIndex,
  });

  factory ExamAnswer.fromJson(Map<String, dynamic> json) {
    return ExamAnswer(
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correctAnsIndex: json['correctAnsIndex'] as int,
      userSelectedIndex: json['userSelectedIndex'] as int,
    );
  }

  bool get isCorrect => userSelectedIndex == correctAnsIndex;
}

class Exam {
  final String id;
  final String title;
  final String? subtitle;
  final ExamStatus status;
  final DateTime endDate;
  final String reviewType;
  final String? marks;
  final String typeTag;
  /// For completed exams: question-wise correct vs user answers. Empty/null if not available.
  final List<ExamAnswer>? answers;

  const Exam({
    required this.id,
    required this.title,
    this.subtitle,
    required this.status,
    required this.endDate,
    required this.reviewType,
    this.marks,
    required this.typeTag,
    this.answers,
  });

  String get statusLabel {
    switch (status) {
      case ExamStatus.ongoing:
        return 'On going';
      case ExamStatus.completed:
        return 'Completed';
      case ExamStatus.unattended:
        return 'Unattended';
    }
  }

  bool get isActive => status == ExamStatus.ongoing;
  bool get isCompleted => status == ExamStatus.completed;
  bool get isUnattended => status == ExamStatus.unattended;

  factory Exam.fromJson(Map<String, dynamic> json) {
    List<ExamAnswer>? answers;
    final answersList = json['answers'] as List<dynamic>?;
    if (answersList != null && answersList.isNotEmpty) {
      answers = answersList
          .map((e) => ExamAnswer.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return Exam(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      status: _statusFromString(json['status'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reviewType: json['reviewType'] as String,
      marks: json['marks'] as String?,
      typeTag: json['typeTag'] as String,
      answers: answers,
    );
  }

  static ExamStatus _statusFromString(String value) {
    switch (value) {
      case 'ongoing':
        return ExamStatus.ongoing;
      case 'completed':
        return ExamStatus.completed;
      case 'unattended':
        return ExamStatus.unattended;
      default:
        return ExamStatus.ongoing;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'status': status.name,
        'endDate': endDate.toIso8601String(),
        'reviewType': reviewType,
        'marks': marks,
        'typeTag': typeTag,
        if (answers != null)
          'answers': answers!.map((e) => {
                'question': e.question,
                'options': e.options,
                'correctAnsIndex': e.correctAnsIndex,
                'userSelectedIndex': e.userSelectedIndex,
              }).toList(),
      };

  bool get hasViewableAnswers =>
      status == ExamStatus.completed &&
      answers != null &&
      answers!.isNotEmpty;
}
