import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tyman/domain/services/auth_repository.dart';

class AuthService implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//TODO: Fix// user won't added to the firebase database
  @override
  Future<void> signUp(String email, String password, String passwordConfirm,
      BuildContext context) async {
    if (email.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      _showMessage(context, 'Please fill in all fields.');
      return;
    }

    if (password != passwordConfirm) {
      _showMessage(context, 'Passwords do not match.');
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _showMessage(context, 'Successfully signed up!');
    } on FirebaseAuthException catch (e) {
      _showMessage(context, e.message ?? 'Something went wrong.');
    }
  }

  @override
  Future<void> logIn(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      _showMessage(context, 'Please fill in all fields.');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _showMessage(context, e.message ?? 'Login failed.');
    }
  }

  @override
  Future<void> logOut(BuildContext context) async {
    try {
      await _auth.signOut();
      _showMessage(context, 'Successfully logged out!');
    } catch (e) {
      _showMessage(context, 'Failed to logout.');
    }
  }

  void _showMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
