import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:twitterclone/common/loading_page.dart';
import 'package:twitterclone/features/auth/controller/auth_controller.dart';
import 'package:twitterclone/features/auth/view/signup_view.dart';
import 'package:twitterclone/features/home/view/home_view.dart';
import 'package:twitterclone/theme/theme.dart';
import 'package:twitterclone/common/common.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Twitter Clone',
        theme: AppTheme.theme,
        home: ref.watch(currentUserAccountProvider).when(
              data: (user) {
                // print(user!.email);
                if (user != null) {
                  return const HomeView();
                }
                return const SignUpView();
              },
              error: (error, st) => ErrorPage(
                error: error.toString(),
              ),
              loading: () => const LoadingPage(),
            ));
  }
}
