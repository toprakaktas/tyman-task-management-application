import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/core/providers/auth_providers.dart';

final signInPasswordObscuredProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final signInEmailFocusProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final signInPasswordFocusProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends ConsumerState<SignInPage> {
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode1.addListener(() {
      ref.read(signInEmailFocusProvider.notifier).state = focusNode1.hasFocus;
    });
    focusNode2.addListener(() {
      ref.read(signInPasswordFocusProvider.notifier).state =
          focusNode2.hasFocus;
    });
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmailFocused = ref.watch(signInEmailFocusProvider);
    final isPasswordFocused = ref.watch(signInPasswordFocusProvider);
    final obscurePassword = ref.watch(signInPasswordObscuredProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: BackgroundDecoration.decoration),
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
                    Image.asset(
                      'assets/images/userAvatar.png',
                    ),
                    const SizedBox(height: 50),
                    textField(email, focusNode1, 'Email', Icons.email_rounded,
                        isEmailFocused),
                    const SizedBox(height: 10),
                    textField(
                      password,
                      focusNode2,
                      'Password',
                      Icons.password_rounded,
                      isPasswordFocused,
                      isPasswordField: true,
                      obscureText: obscurePassword,
                      onToggleVisibility: () {
                        final notifier =
                            ref.read(signInPasswordObscuredProvider.notifier);
                        notifier.state = !notifier.state;
                      },
                    ),
                    const SizedBox(height: 8),
                    account(),
                    const SizedBox(height: 20),
                    loginBottom()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget account() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Don't you have an account?",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => context.go('/signup'),
            child: const Text(
              'Sign Up',
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

  Widget loginBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: GestureDetector(
        onTap: () {
          ref.watch(signInProvider)(email.text, password.text, context);
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: const Color(0xFF3E3E3E),
              borderRadius: BorderRadius.circular(10)),
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: Color(0xFFAEAEAE),
              fontSize: 18.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(
    TextEditingController controller,
    FocusNode focusNode,
    String typeName,
    IconData icon,
    bool isFocused, {
    bool isPasswordField = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
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
          obscureText: isPasswordField ? obscureText : false,
          style: const TextStyle(
              fontSize: 17, color: Color(0xFF3E3E3E), letterSpacing: 3),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                color: isFocused ? const Color(0xFF414040) : Colors.blueGrey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: typeName,
            suffixIcon: isPasswordField
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueGrey, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black87, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}
