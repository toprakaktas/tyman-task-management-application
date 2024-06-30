// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tyman/screens/myPage/loginPage.dart';
import 'package:tyman/screens/myPage/signUpPage.dart';

class AuthenticationService extends StatefulWidget {
  const AuthenticationService({super.key});

  @override
  State<AuthenticationService> createState() => AuthenticationPageState();
}

class AuthenticationPageState extends State<AuthenticationService> {
  bool state = true;
  void to() {
    if (mounted) {
      setState(() {
        state = !state;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (state) {
      return LoginPage(to);
    } else {
      return SignUpPage(to);
    }
  }
}
