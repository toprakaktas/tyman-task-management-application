import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tyman/data/services/auth_service.dart';
import 'package:tyman/data/services/task_service.dart';
import 'package:tyman/data/services/user_service.dart';
import 'package:tyman/domain/usecases/auth/sign_in.dart';
import 'package:tyman/domain/usecases/auth/sign_up.dart';
import 'package:tyman/domain/usecases/task/add_task.dart';
import 'package:tyman/domain/usecases/task/fetch_task_counts_for_categories.dart';
import 'package:tyman/domain/usecases/user/fetch_user_profile.dart';
import 'package:tyman/features/authentication/presentation/sign_in_page.dart';
import 'package:tyman/features/authentication/presentation/sign_up_page.dart';
import 'package:tyman/features/tasks/presentation/home.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool showLogin = true;

  void toggleScreens() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return HomePage(
            fetchTaskCounts: FetchTaskCountsForCategories(TaskService()),
            addTask: AddTask(TaskService()),
            fetchUserProfile: FetchUserProfile(UserService()),
          ); // User is logged in
        } else {
          return showLogin
              ? SignInPage(toggleScreens, signIn: SignIn(AuthService()))
              : SignUpPage(toggleScreens, signUp: SignUp(AuthService()));
        }
      },
    );
  }
}
