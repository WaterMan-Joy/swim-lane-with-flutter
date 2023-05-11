// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/firebase_constants.dart';
import 'package:flutter_swim_lane/core/common/constants/type_defs.dart';
import 'package:flutter_swim_lane/core/common/providers/firebase_providers.dart';
import 'package:flutter_swim_lane/models/post_model.dart';
import 'package:flutter_swim_lane/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../common/constants/failure.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(
      firebaseFirestore: ref.watch(firebaseFirestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore firebaseFirestore;
  UserProfileRepository({
    required this.firebaseFirestore,
  });

  CollectionReference get _users =>
      firebaseFirestore.collection(FirebaseConstants.usersCollection);

  CollectionReference get _posts =>
      firebaseFirestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editUser(UserModel userModel) async {
    try {
      return right(_users.doc(userModel.uid).update(userModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => PostModel.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  Stream<List<PostModel>> getUserPost(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => PostModel.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }
}
