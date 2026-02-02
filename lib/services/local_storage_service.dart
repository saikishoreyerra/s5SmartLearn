import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';

abstract class ILocalStorageService {
  Future<void> saveLoginResponse(LoginResponse response, String password);

  Future<LoginResponse?> getLoginResponse();

  Future<String?> getSavedPassword();

  Future<void> clearLogin();
}

class LocalStorageService implements ILocalStorageService {
  static const _loginResponseKey = 'login_response';
  static const _passwordKey = 'password';

  @override
  Future<void> saveLoginResponse(LoginResponse response, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _loginResponseKey,
      jsonEncode({
        'res': response.res != null
            ? {
                'unm': response.res!.unm,
                'user_id': response.res!.userId,
                'role_id': response.res!.roleId,
                'emp_id': response.res!.empId,
                'utype': response.res!.utype,
                'ust': response.res!.ust,
                'stu_id': response.res!.stuId,
                'roles': response.res!.roles,
                'role_name': response.res!.roleName,
                'role_code': response.res!.roleCode,
                'fnm': response.res!.fnm,
                'lnm': response.res!.lnm,
                'mnm': response.res!.mnm,
                'email': response.res!.email,
                'father_nm': response.res!.fatherNm,
                'dob': response.res!.dob,
                'add': response.res!.add,
                'bgrp': response.res!.bgrp,
                'ins_name': response.res!.insName,
                'comp_id': response.res!.compId,
              }
            : null,
        'suc': response.suc,
        'err': response.err,
        'status': response.status,
        'token': response.token,
      }),
    );
    await prefs.setString(_passwordKey, password);
  }

  @override
  Future<LoginResponse?> getLoginResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_loginResponseKey);
    if (jsonStr == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return LoginResponse.fromJson(jsonMap);
  }

  @override
  Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  @override
  Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginResponseKey);
    await prefs.remove(_passwordKey);
  }
}

