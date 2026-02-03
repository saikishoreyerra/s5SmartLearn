import '../datasources/assignments_remote_datasource.dart';
import '../models/exam.dart';

abstract class IAssignmentsRepository {
  Future<List<Exam>> getExams();
}

class AssignmentsRepository implements IAssignmentsRepository {
  final IAssignmentsRemoteDataSource _remoteDataSource;

  AssignmentsRepository(this._remoteDataSource);

  @override
  Future<List<Exam>> getExams() {
    return _remoteDataSource.fetchExams();
  }
}
