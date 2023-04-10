// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_swim_lane/core/common/constants/utils.dart';
import 'package:flutter_swim_lane/core/feature/auth/repository/auth_repository.dart';
import 'package:flutter_swim_lane/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);
// user 로그인되었는지

final authStateChangeProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateCahnge;
});

final getUserDataProvider =
    StreamProvider.family<UserModel, String>((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository authRepository;
  final Ref ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  }) : super(false);

  Stream<User?> get authStateCahnge => authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await authRepository.signInWithGoogle();
    print('auth-controller: sign in success!');
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) => ref.read(userProvider.notifier).update(
        (state) {
          print('chage userModel : ${userModel}');
          return userModel;
        },
      ),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return authRepository.getUserData(uid);
  }

  void signOut() async {
    authRepository.signOut();
  }
}
