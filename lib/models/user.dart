import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String unm;
  final int userId;
  final int roleId;
  final int? empId;
  final String utype;
  final String ust;
  final String stuId;
  final String roles;
  final String roleName;
  final String roleCode;
  final String fnm;
  final String lnm;
  final String mnm;
  final String email;
  final String fatherNm;
  final String dob;
  final String add;
  final String bgrp;
  final String insName;
  final int compId;

  const User({
    required this.unm,
    required this.userId,
    required this.roleId,
    this.empId,
    required this.utype,
    required this.ust,
    required this.stuId,
    required this.roles,
    required this.roleName,
    required this.roleCode,
    required this.fnm,
    required this.lnm,
    required this.mnm,
    required this.email,
    required this.fatherNm,
    required this.dob,
    required this.add,
    required this.bgrp,
    required this.insName,
    required this.compId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      unm: json['unm'] ?? '',
      userId: json['user_id'] ?? 0,
      roleId: json['role_id'] ?? 0,
      empId: json['emp_id'],
      utype: json['utype'] ?? '',
      ust: json['ust'] ?? '',
      stuId: json['stu_id'] ?? '',
      roles: json['roles'] ?? '',
      roleName: json['role_name'] ?? '',
      roleCode: json['role_code'] ?? '',
      fnm: json['fnm'] ?? '',
      lnm: json['lnm'] ?? '',
      mnm: json['mnm'] ?? '',
      email: json['email'] ?? '',
      fatherNm: json['father_nm'] ?? '',
      dob: json['dob'] ?? '',
      add: json['add'] ?? '',
      bgrp: json['bgrp'] ?? '',
      insName: json['ins_name'] ?? '',
      compId: json['comp_id'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        unm,
        userId,
        roleId,
        empId,
        utype,
        ust,
        stuId,
        roles,
        roleName,
        roleCode,
        fnm,
        lnm,
        mnm,
        email,
        fatherNm,
        dob,
        add,
        bgrp,
        insName,
        compId,
      ];
}
