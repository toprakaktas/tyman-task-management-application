import 'package:flutter/material.dart';
import 'package:tyman/domain/services/auth_repository.dart';

class LogOut {
  final AuthRepository repository;

  LogOut(this.repository);

  Future<void> call(BuildContext context) async {
    return await repository.logOut(context);
  }
}
