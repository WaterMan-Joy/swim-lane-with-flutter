// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/failure.dart';
import 'package:flutter_swim_lane/core/common/constants/firebase_constants.dart';
import 'package:flutter_swim_lane/core/common/constants/type_defs.dart';
import 'package:flutter_swim_lane/core/common/providers/firebase_providers.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../models/lane_model.dart';

final laneRepositoryProvider = Provider((ref) {
  return LaneRepository(
      firebaseFirestore: ref.watch(firebaseFirestoreProvider));
});

class LaneRepository {
  final FirebaseFirestore firebaseFirestore;
  LaneRepository({
    required this.firebaseFirestore,
  });

  CollectionReference get _lanes =>
      firebaseFirestore.collection(FirebaseConstants.lanesCollection);

  FutureVoid createLane(LaneModel laneModel) async {
    try {
      var laneDoc = await _lanes.doc(laneModel.name).get();
      if (laneDoc.exists) {
        throw '레인 이름이 이미 있습니다';
      }
      return right(await _lanes.doc(laneModel.name).set(laneModel.toMap()));
    } on FirebaseException catch (e) {
      // return left(Failure(e.message!));
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<LaneModel>> getUserLanes(String uid) {
    return _lanes.where('members', arrayContains: uid).snapshots().map((event) {
      List<LaneModel> lanes = [];
      for (var doc in event.docs) {
        lanes.add(LaneModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return lanes;
    });
  }

  Stream<LaneModel> getLaneByName(String name) {
    return _lanes.doc(name).snapshots().map((event) {
      return LaneModel.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  FutureVoid editLane(LaneModel laneModel) async {
    try {
      return right(_lanes.doc(laneModel.name).update(laneModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<LaneModel>> searchLane(String query) {
    return _lanes
        .where('name',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(
                      query.codeUnitAt(query.length - 1) + 1,
                    ))
        .snapshots()
        .map((event) {
      List<LaneModel> lanes = [];
      for (var lane in event.docs) {
        lanes.add(LaneModel.fromMap(lane.data() as Map<String, dynamic>));
      }
      return lanes;
    });
  }

  FutureVoid joinLane(String laneName, String userId) async {
    try {
      return right(
        _lanes.doc(laneName).update(
          {
            'members': FieldValue.arrayUnion([userId])
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveLane(String laneName, String userId) async {
    try {
      return right(
        _lanes.doc(laneName).update(
          {
            'members': FieldValue.arrayRemove([userId])
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
