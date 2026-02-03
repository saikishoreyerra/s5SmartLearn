import '../datasources/quiz_remote_datasource.dart';
import '../models/question.dart';

abstract class IQuizRepository {
  Future<List<Question>> getQuestions();
}

class QuizRepository implements IQuizRepository {
  final IQuizRemoteDataSource _remoteDataSource;

  QuizRepository(this._remoteDataSource);

  @override
  Future<List<Question>> getQuestions() {
    return _remoteDataSource.fetchQuestions();
  }
}
