import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/question.dart';

abstract class IQuizRemoteDataSource {
  Future<List<Question>> fetchQuestions({String? examId});
}

class QuizRemoteDataSource implements IQuizRemoteDataSource {
  static const String _defaultAssetPath = 'assets/json/quiz_questions.json';
  static const String _examAssetPath = 'assets/json/exam_questions.json';
  static const Duration _simulatedDelay = Duration(milliseconds: 300);

  @override
  Future<List<Question>> fetchQuestions({String? examId}) async {
    await Future.delayed(_simulatedDelay);

    // Default quiz (dashboard “Play Quiz”)
    if (examId == null) {
      final jsonString = await rootBundle.loadString(_defaultAssetPath);
      final Map<String, dynamic> json =
          jsonDecode(jsonString) as Map<String, dynamic>;
      final List<dynamic> list = json['questions'] as List<dynamic>;
      return list
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Exam‑specific questions
    final jsonString = await rootBundle.loadString(_examAssetPath);
    final Map<String, dynamic> json =
        jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> exams = json['exams'] as List<dynamic>;

    final Map<String, dynamic>? examJson = exams
        .cast<Map<String, dynamic>>()
        .firstWhere((e) => e['examId'] == examId, orElse: () => {});

    if (examJson == null || examJson.isEmpty || examJson['questions'] == null) {
      throw Exception('No questions configured for exam $examId');
    }

    final List<dynamic> list = examJson['questions'] as List<dynamic>;
    return list
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
