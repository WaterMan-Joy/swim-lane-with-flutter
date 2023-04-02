// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/constants.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/lane/repository/lane_repository.dart';
import 'package:flutter_swim_lane/models/lane_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/constants/utils.dart';

final userLanesProvider = StreamProvider<List<LaneModel>>((ref) {
  final laneController = ref.watch(laneControllerProvider.notifier);
  return laneController.getUserLanes();
});

final laneControllerProvider =
    StateNotifierProvider<LaneController, bool>((ref) {
  final laneRepository = ref.watch(laneRepositoryProvider);
  return LaneController(laneRepository: laneRepository, ref: ref);
});

final getLaneByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(laneControllerProvider.notifier).getLaneByName(name);
});

class LaneController extends StateNotifier<bool> {
  final LaneRepository laneRepository;
  final Ref ref;
  LaneController({
    required this.laneRepository,
    required this.ref,
  }) : super(false);

  void createLane(String name, BuildContext context) async {
    state = true;
    final uid = ref.read(userProvider)?.uid ?? '';
    LaneModel laneModel = LaneModel(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      masters: [uid],
    );
    // laneRepository.createLane(laneModel);
    final res = await laneRepository.createLane(laneModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, '레인 생성 완료');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<LaneModel>> getUserLanes() {
    final uid = ref.read(userProvider)!.uid;
    return laneRepository.getUserLanes(uid);
  }

  Stream<LaneModel> getLaneByName(String name) {
    return laneRepository.getLaneByName(name);
  }
}
