import 'package:flutter/material.dart';
import 'package:tyman/domain/services/auth_repository.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> call(BuildContext context) async {
    return await repository.signOut(context);
  }
}
