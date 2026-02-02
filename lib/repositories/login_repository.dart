import '../models/login_response.dart';
import '../services/login_service.dart';

abstract class ILoginRepository {
  Future<LoginResponse> login(String username, String password);
}

class LoginRepository implements ILoginRepository {
  final ILoginService _loginService;

  LoginRepository(this._loginService);

  @override
  Future<LoginResponse> login(String username, String password) {
    return _loginService.login(username, password);
  }
}
