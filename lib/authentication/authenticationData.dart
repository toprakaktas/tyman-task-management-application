// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tyman/authentication/authenticationPage.dart';
import 'package:tyman/screens/home/home.dart';
import 'package:tyman/services/firestore_services.dart';

abstract class AutenticationDataSource {
  Future<void> signUp(String email, String password, String passwordConfirm,
      BuildContext context);
  Future<void> logIn(String email, String password, BuildContext context);
  Future<void> logout(BuildContext context);
}

class AuthenticationData extends AutenticationDataSource {
  @override
  Future<void> logIn(
      String email, String password, BuildContext context) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully logged in!'),
          behavior: SnackBarBehavior.floating));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Future<void> signUp(String email, String password, String passwordConfirm,
      BuildContext context) async {
    if (passwordConfirm == password) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then((value) {
        FirestoreService().createUser(email);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Successfully signed up!'),
            behavior: SnackBarBehavior.floating));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      });
    }
  }

  @override
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthenticationService()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error signing out. Try again.')));
    }
  }
}
