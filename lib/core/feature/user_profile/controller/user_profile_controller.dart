// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_swim_lane/core/common/providers/storage_repository_provider.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/user_profile/repository/user_profile_repository.dart';
import 'package:flutter_swim_lane/models/post_model.dart';
import 'package:flutter_swim_lane/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/constants/utils.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(fbStorageProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(userProfileControllerProvider.notifier).getUserPosts(uid);
});
final getUserPostProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository userProfileRepository;
  final Ref ref;
  final StorageRepository storageRepository;
  UserProfileController({
    required this.userProfileRepository,
    required this.ref,
    required this.storageRepository,
  }) : super(false);

  void editUser({
    required File? profilePicFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = ref.read(userProvider)!;
    if (profilePicFile != null) {
      final res = await storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profilePicFile,
      );
      res.fold((l) {
        return showSnackBar(context, l.message);
      }, (r) {
        return user = user.copyWith(profilePic: r);
      });
    }

    user = user.copyWith(name: name);
    final res = await userProfileRepository.editUser(user);
    state = false;
    res.fold((l) {
      return showSnackBar(context, l.message);
    }, (r) {
      ref.read(userProvider.notifier).update((state) => user);
      return Routemaster.of(context).pop();
    });
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return userProfileRepository.getUserPosts(uid);
  }

  Stream<List<PostModel>> getUserPost(String uid) {
    return userProfileRepository.getUserPosts(uid);
  }
}
