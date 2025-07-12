import 'package:flutter/material.dart';

abstract class AuthRepository {
  Future<void> signUp(String email, String password, String passwordConfirm,
      BuildContext context);

  Future<void> signIn(String email, String password, BuildContext context);

  Future<void> signOut(BuildContext context);
}
