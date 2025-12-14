import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyman/data/services/auth_service.dart';
import 'package:tyman/domain/usecases/auth/sign_in.dart';
import 'package:tyman/domain/usecases/auth/sign_in_with_google.dart';
import 'package:tyman/domain/usecases/auth/sign_out.dart';
import 'package:tyman/domain/usecases/auth/sign_up.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final signInProvider =
    Provider<SignIn>((ref) => SignIn(ref.read(authServiceProvider)));

final signUpProvider =
    Provider<SignUp>((ref) => SignUp(ref.read(authServiceProvider)));

final signOutProvider =
    Provider<SignOut>((ref) => SignOut(ref.read(authServiceProvider)));

final signInWithGoogleProvider = Provider<SignInWithGoogle>(
    (ref) => SignInWithGoogle(ref.read(authServiceProvider)));
