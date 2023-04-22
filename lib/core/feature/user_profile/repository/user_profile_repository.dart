// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/firebase_constants.dart';
import 'package:flutter_swim_lane/core/common/constants/type_defs.dart';
import 'package:flutter_swim_lane/core/common/providers/firebase_providers.dart';
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

  FutureVoid editUser(UserModel userModel) async {
    try {
      return right(_users.doc(userModel.uid).update(userModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
