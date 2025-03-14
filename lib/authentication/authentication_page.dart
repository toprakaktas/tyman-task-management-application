import 'package:flutter/material.dart';
import 'package:tyman/screens/myPage/login_page.dart';
import 'package:tyman/screens/myPage/sign_up_page.dart';

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
