import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/question.dart';

abstract class IQuizRemoteDataSource {
  Future<List<Question>> fetchQuestions();
}

class QuizRemoteDataSource implements IQuizRemoteDataSource {
  static const String _assetPath = 'assets/json/quiz_questions.json';
  static const Duration _simulatedDelay = Duration(milliseconds: 300);

  @override
  Future<List<Question>> fetchQuestions() async {
    await Future.delayed(_simulatedDelay);
    final String jsonString = await rootBundle.loadString(_assetPath);
    final Map<String, dynamic> json =
        jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> list = json['questions'] as List<dynamic>;
    return list
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
