import 'package:appwrite/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/apis/auth_api.dart';
import 'package:twitterclone/apis/user_api.dart';
import 'package:twitterclone/core/utils.dart';
import 'package:twitterclone/features/auth/view/login_view.dart';
import 'package:twitterclone/features/home/view/home_view.dart';
import 'package:twitterclone/features/auth/view/signup_view.dart';
import 'package:twitterclone/models/user_models.dart';

final authControlerProvider = StateNotifierProvider<AuthControler, bool>((ref) {
  return AuthControler(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authControler = ref.watch(authControlerProvider.notifier);
  return authControler.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authControler = ref.watch(authControlerProvider.notifier);
  return authControler.currentUser();
});

class AuthControler extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthControler({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signup(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.savUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Signed up successfully. Please login');
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.push(context, HomeView.route());
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final res = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(res.data);
    return updatedUser;
  }
}
