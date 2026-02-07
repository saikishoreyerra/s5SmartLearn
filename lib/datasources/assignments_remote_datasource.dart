import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/exam.dart';

abstract class IAssignmentsRemoteDataSource {
  Future<List<Exam>> fetchExams();
}

class AssignmentsRemoteDataSource implements IAssignmentsRemoteDataSource {
  static const String _assetPath = 'assets/json/assignments.json';
  static const Duration _simulatedDelay = Duration(milliseconds: 600);

  @override
  Future<List<Exam>> fetchExams() async {
    await Future.delayed(_simulatedDelay);
    final String jsonString = await rootBundle.loadString(_assetPath);
    final Map<String, dynamic> json =
        jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> list = json['exams'] as List<dynamic>;
    return list.map((e) => Exam.fromJson(e as Map<String, dynamic>)).toList();
  }
}
