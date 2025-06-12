import 'package:flutter/material.dart';
import 'package:tyman/domain/services/auth_repository.dart';

class LogIn {
  final AuthRepository repository;
  LogIn(this.repository);

  Future<void> call(String email, String password, BuildContext context) async {
    return await repository.logIn(email, password, context);
  }
}
