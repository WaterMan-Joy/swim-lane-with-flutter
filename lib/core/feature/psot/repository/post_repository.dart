// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/failure.dart';
import 'package:flutter_swim_lane/core/common/constants/firebase_constants.dart';
import 'package:flutter_swim_lane/core/common/constants/type_defs.dart';
import 'package:flutter_swim_lane/core/common/providers/firebase_providers.dart';
import 'package:flutter_swim_lane/models/post_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../models/lane_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
      firebaseFirestore: ref.watch(firebaseFirestoreProvider));
});

class PostRepository {
  final FirebaseFirestore firebaseFirestore;
  PostRepository({
    required this.firebaseFirestore,
  });

  CollectionReference get _posts =>
      firebaseFirestore.collection(FirebaseConstants.postsCollection);

  FutureVoid appPost(PostModel postModel) async {
    try {
      return right(_posts.doc(postModel.id).set(postModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> fetchUserPosts(List<LaneModel> lanes) {
    return _posts
        .where('selectedLane', whereIn: lanes.map((e) => e.name).toList())
        .orderBy('createAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deletePost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(PostModel post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove([userId]),
        },
      );
    }

    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove([userId]),
        },
      );
    } else {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayUnion([userId]),
        },
      );
    }
  }

  void downvote(PostModel post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'upvotes': FieldValue.arrayRemove([userId]),
        },
      );
    }

    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayRemove([userId]),
        },
      );
    } else {
      _posts.doc(post.id).update(
        {
          'downvotes': FieldValue.arrayUnion([userId]),
        },
      );
    }
  }
}
