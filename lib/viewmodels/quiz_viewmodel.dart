import 'package:flutter/foundation.dart';

import '../models/question.dart';
import '../repositories/quiz_repository.dart';

class QuizViewModel extends ChangeNotifier {
  final IQuizRepository _quizRepository;

  QuizViewModel(this._quizRepository);

  List<Question> _questions = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _questionNumber = 1;
  bool _isAnswered = false;
  int? _selectedAns;
  int? _correctAns;

  List<Question> get questions => List.unmodifiable(_questions);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get questionNumber => _questionNumber;
  bool get isAnswered => _isAnswered;
  int? get selectedAns => _selectedAns;
  int? get correctAns => _correctAns;

  bool get isQuizComplete =>
      _questions.isNotEmpty && _questionNumber > _questions.length;

  bool get hasQuestions => _questions.isNotEmpty;

  Future<void> loadQuestions({String? examId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _questions = await _quizRepository.getQuestions(examId: examId);
      _isLoading = false;
      _errorMessage = null;
      _questionNumber = 1;
      _isAnswered = false;
      _selectedAns = null;
      _correctAns = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _questions = [];
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_questionNumber < _questions.length) {
      _questionNumber++;
      _isAnswered = false;
      _selectedAns = null;
      _correctAns = null;
      notifyListeners();
    }
  }

  void checkAns(Question question, int selectedIndex) {
    if (_isAnswered) return;
    _isAnswered = true;
    _selectedAns = selectedIndex;
    _correctAns = question.correctAnsIndex;
    notifyListeners();
  }

  void updateQuestionNumber(int index) {
    _questionNumber = index + 1;
    notifyListeners();
  }
}
