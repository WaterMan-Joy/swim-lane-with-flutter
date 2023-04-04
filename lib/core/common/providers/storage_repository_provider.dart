// ignore_for_file: public_member_api_docs, sort_constructors_firstimport 'dart:io';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/failure.dart';
import 'package:flutter_swim_lane/core/common/constants/type_defs.dart';
import 'package:flutter_swim_lane/core/common/providers/firebase_providers.dart';
import 'package:fpdart/fpdart.dart';

final fbStorageProvider = Provider((ref) {
  return StorageRepository(firebaseStorage: ref.watch(firebaseStorageProvider));
});

class StorageRepository {
  final FirebaseStorage firebaseStorage;
  StorageRepository({
    required this.firebaseStorage,
  });

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
