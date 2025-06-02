import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tyman/features/authentication/presentation/authentication_wrapper.dart';
import 'package:tyman/features/tasks/presentation/home.dart';
import 'package:tyman/data/services/firestore_services.dart';

abstract class AuthenticationDataSource {
  Future<void> signUp(String email, String password, String passwordConfirm,
      BuildContext context);
  Future<void> logIn(String email, String password, BuildContext context);
  Future<void> logout(BuildContext context);
}

class AuthenticationData extends AuthenticationDataSource {
  @override
  Future<void> logIn(
      String email, String password, BuildContext context) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .then((value) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Successfully logged in!'),
            behavior: SnackBarBehavior.floating));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
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
        if (context.mounted) {
          FirestoreService().createUser(email);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Successfully signed up!'),
              behavior: SnackBarBehavior.floating));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      });
    }
  }

  @override
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AuthenticationWrapper()));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error signing out. Try again.')));
      }
    }
  }
}
