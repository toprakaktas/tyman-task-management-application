import 'package:flutter/material.dart';
import 'package:tyman/domain/services/auth_repository.dart';

class SignUp {
  final AuthRepository repository;
  SignUp(this.repository);

  Future<void> call(String email, String password, String passwordConfirm,
      BuildContext context) async {
    return await repository.signUp(email, password, passwordConfirm, context);
  }
}
