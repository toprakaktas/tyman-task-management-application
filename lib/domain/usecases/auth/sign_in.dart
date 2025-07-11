import 'package:flutter/material.dart';
import 'package:tyman/domain/services/auth_repository.dart';

class SignIn {
  final AuthRepository repository;
  SignIn(this.repository);

  Future<void> call(String email, String password, BuildContext context) async {
    return await repository.signIn(email, password, context);
  }
}
