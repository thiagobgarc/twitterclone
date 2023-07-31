import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/common/loading_page.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/auth/view/signup_view.dart';
import 'package:twitterclone/features/auth/widgets/auth_field.dart';
import 'package:twitterclone/theme/theme.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void onLogin() {
    ref.read(authControlerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControlerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // textfield 1
                    AuthField(
                      controller: emailController,
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 25),
                    // textfield 2
                    AuthField(
                      controller: passwordController,
                      hintText: 'Password',
                    ),
                    const SizedBox(height: 40),
                    // button
                    Align(
                      alignment: Alignment.topRight,
                      child: RoundedSmallButton(
                        onTap: onLogin,
                        label: 'Done',
                      ),
                    ),
                    // textspan
                    const SizedBox(height: 40),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: ' Sign up',
                            style: TextStyle(
                              color: Pallete.blueColor,
                              fontSize: 16,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  SignUpView.route(),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ),
    );
  }
}
