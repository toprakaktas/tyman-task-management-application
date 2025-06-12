import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/domain/usecases/auth/sign_up.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback show;
  final SignUp signUp;
  const SignUpPage(this.show, {super.key, required this.signUp});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();

  bool passwordVisible = true;
  bool passwordConfirmVisible = true;

  @override
  void initState() {
    super.initState();
    focusNode1.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    focusNode2.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    focusNode3.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  tileMode: TileMode.mirror,
                  colors: [
                    kBlack,
                    kGreyDark,
                    kGrey,
                    kGreyLight,
                    kWhiteGrey,
                  ],
                  transform: GradientRotation(pi / 4)),
            ),
            child: Center(
                child: SingleChildScrollView(
                    child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              ),
              color: const Color(0xFF717171),
              shadowColor: const Color(0xFF484848),
              surfaceTintColor: const Color(0xFF2C2C2C),
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.co_present_outlined,
                        size: 60, color: Color(0xFF272525)),
                    const SizedBox(height: 50),
                    textField(email, focusNode1, 'Email', Icons.email_rounded),
                    const SizedBox(height: 10),
                    textField(password, focusNode2, 'Password',
                        Icons.password_rounded),
                    const SizedBox(height: 10),
                    textField(passwordConfirm, focusNode3, 'Password Confirm',
                        Icons.password_rounded),
                    const SizedBox(height: 8),
                    account(),
                    const SizedBox(height: 20),
                    signUpBottom()
                  ],
                ),
              ),
            )))));
  }

  Widget account() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Do you have an account?",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: widget.show,
            child: const Text(
              'Login',
              style: TextStyle(
                  color: Color(0xFF2D2D2D),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget signUpBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: GestureDetector(
        onTap: () {
          widget.signUp(
              email.text, password.text, passwordConfirm.text, context);
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: const Color(0xFF3E3E3E),
              borderRadius: BorderRadius.circular(10)),
          child: const Text(
            'Sign Up',
            style: TextStyle(
                color: Color(0xFFAEAEAE),
                fontSize: 18.5,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget textField(TextEditingController controller, FocusNode focusNode,
      String typeName, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: typeName == 'Password'
              ? passwordVisible
              : typeName == 'Password Confirm'
                  ? passwordConfirmVisible
                  : false,
          style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF3E3E3E),
              letterSpacing: 3,
              wordSpacing: 4),
          decoration: InputDecoration(
              prefixIcon: Icon(icon,
                  color: focusNode.hasFocus
                      ? const Color(0xFF414040)
                      : Colors.blueGrey),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: typeName,
              suffixIcon: typeName.contains('Password')
                  ? IconButton(
                      icon: Icon(typeName == 'Password'
                          ? passwordVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded
                          : passwordConfirmVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded),
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            if (typeName == 'Password') {
                              passwordVisible = !passwordVisible;
                            } else if (typeName == 'Password Confirm') {
                              passwordConfirmVisible = !passwordConfirmVisible;
                            }
                          });
                        }
                      },
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Colors.blueGrey, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.black87, width: 2.0))),
        ),
      ),
    );
  }
}
