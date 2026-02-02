import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/login_response.dart';

abstract class ILoginService {
  Future<LoginResponse> login(String username, String password);
}

class LoginService implements ILoginService {
  @override
  Future<LoginResponse> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(microseconds: 200));

    // Mock login logic: use "priya" as username and any password for success
    if (username.toLowerCase() == 'priya' && password.isNotEmpty) {
      final String response = await rootBundle.loadString('assets/json/login_success.json');
      final Map<String, dynamic> jsonData = json.decode(response);
      return LoginResponse.fromJson(jsonData);
    } else {
      final String response = await rootBundle.loadString('assets/json/login_failure.json');
      final Map<String, dynamic> jsonData = json.decode(response);
      return LoginResponse.fromJson(jsonData);
    }
  }
}
