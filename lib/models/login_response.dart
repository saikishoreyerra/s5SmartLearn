import 'package:equatable/equatable.dart';
import 'user.dart';

class LoginResponse extends Equatable {
  final User? res;
  final bool suc;
  final String? err;
  final int status;
  final String? token;

  const LoginResponse({
    this.res,
    required this.suc,
    this.err,
    required this.status,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      res: json['res'] != null ? User.fromJson(json['res']) : null,
      suc: json['suc'] ?? false,
      err: json['err'],
      status: json['status'] ?? 0,
      token: json['token'],
    );
  }

  @override
  List<Object?> get props => [res, suc, err, status, token];
}
