// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/constants.dart';
import 'package:flutter_swim_lane/core/common/constants/failure.dart';
import 'package:flutter_swim_lane/core/common/constants/firebase_constants.dart';
import 'package:flutter_swim_lane/core/common/constants/type_defs.dart';
import 'package:flutter_swim_lane/core/common/providers/firebase_providers.dart';
import 'package:flutter_swim_lane/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    firebaseAuth: ref.read(firebaseAuthProvider),
    firebaseFirestore: ref.read(firebaseFirestoreProvider),
    googleSignIn: ref.read(googleSignInProvier),
  );
});

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  CollectionReference get _users =>
      firebaseFirestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();
  // User 는 firebase auth 의 User 타입이다

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final credential = GoogleAuthProvider.credential(
        accessToken: (await googleUser?.authentication)?.accessToken,
        idToken: (await googleUser?.authentication)?.idToken,
      );
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      late UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            uid: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? 'No Name',
            profilePic:
                userCredential.user!.photoURL ?? Constants.avatarDefault);
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
        print('auth-repository: ${userCredential.user?.email}');
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
        print('auth-repository: ${userCredential.user?.email}');
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  void signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
