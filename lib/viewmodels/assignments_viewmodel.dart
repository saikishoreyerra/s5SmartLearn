import 'package:flutter/foundation.dart';

import '../models/exam.dart';
import '../repositories/assignments_repository.dart';

class AssignmentsViewModel extends ChangeNotifier {
  final IAssignmentsRepository _assignmentsRepository;

  AssignmentsViewModel(this._assignmentsRepository);

  List<Exam> _exams = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedTab = 0;

  static const int tabActive = 0;
  static const int tabCompleted = 1;
  static const int tabUnattended = 2;
  static const int tabAll = 3;

  List<Exam> get allExams => List.unmodifiable(_exams);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedTab => _selectedTab;

  List<Exam> get filteredExams {
    switch (_selectedTab) {
      case tabActive:
        return _exams.where((e) => e.isActive).toList();
      case tabCompleted:
        return _exams.where((e) => e.isCompleted).toList();
      case tabUnattended:
        return _exams.where((e) => e.isUnattended).toList();
      case tabAll:
        return List.from(_exams);
      default:
        return _exams;
    }
  }

  Future<void> loadAssignments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exams = await _assignmentsRepository.getExams();
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _exams = [];
      notifyListeners();
    }
  }

  void setSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }
}
