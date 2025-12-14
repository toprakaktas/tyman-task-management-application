import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tyman/core/utils/snackbar_helper.dart';
import 'package:tyman/data/services/user_service.dart';
import 'package:tyman/domain/services/auth_repository.dart';

class AuthService implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  Future<void> signUp(String email, String password, String passwordConfirm,
      BuildContext context) async {
    if (email.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      showSnackBar(context, 'Please fill in all fields.');
      return;
    }

    if (password != passwordConfirm) {
      showSnackBar(context, 'Passwords do not match.');
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await UserService().createUser(email);
      showSnackBar(context, 'Successfully signed up!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, 'Please fill in all fields.');
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Login failed.');
    }
  }

  @override
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      showSnackBar(context, 'Successfully logged out!');
    } catch (e) {
      showSnackBar(context, 'Failed to logout.');
    }
  }

  @override
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      _googleSignIn.initialize();
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential =
          GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          await UserService().createUser(user.email ?? '');
        }
      }
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
