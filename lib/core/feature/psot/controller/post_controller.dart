import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/providers/firebase_providers.dart';

import 'package:flutter_swim_lane/core/common/providers/storage_repository_provider.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/psot/repository/post_repository.dart';
import 'package:flutter_swim_lane/models/lane_model.dart';
import 'package:flutter_swim_lane/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../common/constants/utils.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(fbStorageProvider);
  return PostController(
      postRepository: postRepository,
      storageRepository: storageRepository,
      ref: ref);
});

final userPostsProvider =
    StreamProvider.family<List<PostModel>, List<LaneModel>>(
        (ref, List<LaneModel> lanes) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(lanes);
});

class PostController extends StateNotifier<bool> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;
  final Ref ref;
  PostController({
    required this.postRepository,
    required this.storageRepository,
    required this.ref,
  }) : super(false);

  void addPost({
    required BuildContext context,
    required LaneModel selectedLane,
    required String title,
    required String meter,
    required String count,
    required String cycle,
    required String description,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = ref.read(userProvider)!;
    final imageRes = await storageRepository.storeFile(
      path: "posts/${selectedLane.name}",
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final PostModel post = PostModel(
        id: postId,
        title: title,
        meter: meter,
        count: count,
        cycle: cycle,
        description: description,
        selectedLane: selectedLane.name,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        createAt: DateTime.now(),
        link: r,
      );
      final res = await postRepository.appPost(post);

      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, "포스트 업로드 완료");
        Routemaster.of(context).pop();
      });
      state = false;
    });
  }

  Stream<List<PostModel>> fetchUserPosts(List<LaneModel> lanes) {
    if (lanes.isNotEmpty) {
      return postRepository.fetchUserPosts(lanes);
    }
    return Stream.value([]);
  }
}
