import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/core/providers/auth_providers.dart';
import 'package:tyman/core/providers/theme_provider.dart';
import 'package:tyman/core/utils/snackbar_helper.dart';

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
    final themeMode = ref.watch(themeNotifierProvider);

    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration:
            BoxDecoration(gradient: BackgroundDecoration.getGradient(context)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
                color: theme.cardColor,
                shadowColor: theme.shadowColor,
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            themeMode == ThemeMode.dark
                                ? Icons.light_mode
                                : Icons.dark_mode,
                          ),
                          onPressed: () {
                            ref
                                .read(themeNotifierProvider.notifier)
                                .toggleTheme();
                          },
                        ),
                      ),
                      Image.asset(
                        'assets/images/userAvatar.png',
                      ),
                      const SizedBox(height: 50),
                      textField(context, email, focusNode1, 'Email',
                          Icons.email_rounded, isEmailFocused),
                      const SizedBox(height: 10),
                      textField(
                        context,
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
                      account(context),
                      const SizedBox(height: 20),
                      loginBottom(context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget account(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Don't you have an account?",
            style: TextStyle(
                color: theme.textTheme.bodyLarge!.color, fontSize: 14),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => context.go('/signup'),
            child: Text(
              'Sign Up',
              style: TextStyle(
                  color: theme.textTheme.bodyLarge!.color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget loginBottom(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: Column(
        spacing: 5,
        children: [
          ElevatedButton(
            onPressed: () {
              ref.read(signInProvider)(email.text, password.text, context);
            },
            style: ElevatedButton.styleFrom(
              elevation: 2,
              minimumSize: Size(double.infinity, 54),
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Icon(
                  Icons.email,
                  size: 24,
                ),
                const Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          Divider(
            color: theme.colorScheme.primary,
          ),
          ElevatedButton(
            onPressed: () async {
              final user =
                  await ref.read(signInWithGoogleProvider).call(context);
              if (user != null && context.mounted) {
                context.go('/home');
              } else if (context.mounted) {
                showSnackBar(context, 'Failed to sign in with Google.');
                return;
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 2,
              minimumSize: Size(double.infinity, 54),
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.primary,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    width: 24,
                    height: 24,
                  ),
                  Text('Google',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5))
                ]),
          )
        ],
      ),
    );
  }

  Widget textField(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    String typeName,
    IconData icon,
    bool isFocused, {
    bool isPasswordField = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPasswordField ? obscureText : false,
          style: TextStyle(
              fontWeight: theme.textTheme.bodyMedium!.fontWeight,
              fontSize: 17,
              color: theme.textTheme.bodyMedium!.color,
              letterSpacing: 3),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                color: isFocused
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withAlpha(100)),
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
              borderSide: BorderSide(color: theme.cardColor, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.shadowColor, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}
