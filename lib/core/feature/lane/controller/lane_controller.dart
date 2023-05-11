// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

import 'package:flutter_swim_lane/core/common/constants/constants.dart';
import 'package:flutter_swim_lane/core/common/constants/type_defs.dart';
import 'package:flutter_swim_lane/core/common/providers/storage_repository_provider.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/lane/repository/lane_repository.dart';
import 'package:flutter_swim_lane/models/lane_model.dart';

import '../../../common/constants/utils.dart';

final userLanesProvider = StreamProvider<List<LaneModel>>((ref) {
  final laneController = ref.watch(laneControllerProvider.notifier);
  return laneController.getUserLanes();
});

final laneControllerProvider =
    StateNotifierProvider<LaneController, bool>((ref) {
  final laneRepository = ref.watch(laneRepositoryProvider);
  final storageRepository = ref.watch(fbStorageProvider);
  return LaneController(
    laneRepository: laneRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getLaneByNameProvider =
    StreamProvider.family<LaneModel, String>((ref, String name) {
  return ref.watch(laneControllerProvider.notifier).getLaneByName(name);
});

final searchLaneProvider =
    StreamProvider.family<List<LaneModel>, String>((ref, String query) {
  return ref.watch(laneControllerProvider.notifier).searchLane(query);
});

class LaneController extends StateNotifier<bool> {
  final LaneRepository laneRepository;
  final Ref ref;
  final StorageRepository storageRepository;
  LaneController({
    required this.laneRepository,
    required this.ref,
    required this.storageRepository,
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
      managers: [uid],
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

  void editLane({
    required File? avatarFile,
    required File? bannerFile,
    required BuildContext context,
    required LaneModel laneModel,
  }) async {
    state = true;
    if (avatarFile != null) {
      final res = await storageRepository.storeFile(
        path: 'lanes/avatar',
        id: laneModel.name,
        file: avatarFile,
      );
      res.fold((l) {
        return showSnackBar(context, l.message);
      }, (r) {
        return laneModel = laneModel.copyWith(avatar: r);
      });
    }
    if (bannerFile != null) {
      final res = await storageRepository.storeFile(
        path: 'lanes/banner',
        id: laneModel.name,
        file: bannerFile,
      );
      res.fold((l) {
        return showSnackBar(context, l.message);
      }, (r) {
        return laneModel = laneModel.copyWith(banner: r);
      });
    }
    final res = await laneRepository.editLane(laneModel);
    state = false;
    res.fold((l) {
      return showSnackBar(context, l.message);
    }, (r) {
      return Routemaster.of(context).pop();
    });
  }

  Stream<List<LaneModel>> searchLane(String query) {
    return laneRepository.searchLane(query);
  }

  void joinLane(BuildContext context, LaneModel laneModel) async {
    final user = ref.read(userProvider)!;

    Either<Failure, void> res;
    if (laneModel.members.contains(user.uid)) {
      res = await laneRepository.leaveLane(laneModel.name, user.uid);
    } else {
      res = await laneRepository.joinLane(laneModel.name, user.uid);
    }
    res.fold((l) {
      return showSnackBar(context, l.message);
    }, (r) {
      if (laneModel.members.contains(user.uid)) {
        showSnackBar(context, '레인을 떠났습니다');
      } else {
        showSnackBar(context, '레인에 합류 했습니다');
      }
    });
  }

  void addMasters(
      String laneName, List<String> uids, BuildContext context) async {
    final res = await laneRepository.addMasters(laneName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void addManagers(
      String laneName, List<String> uids, BuildContext context) async {
    final res = await laneRepository.addManagers(laneName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
