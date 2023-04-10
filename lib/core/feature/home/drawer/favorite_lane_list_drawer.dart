import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';
import 'package:flutter_swim_lane/models/lane_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class FavoriteLaneListDrawer extends ConsumerWidget {
  const FavoriteLaneListDrawer({super.key});

  void navigateToCreateLane(BuildContext context) {
    Routemaster.of(context).push('/create-lane');
  }

  void navigateToLane(BuildContext context, LaneModel laneModel) {
    Routemaster.of(context).push('/${laneModel.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Text('계정 주인 - ${user.name}'),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('레인 만들기'),
              onTap: () => navigateToCreateLane(context),
            ),
            ListTile(
              title: Text('내 레인'),
            ),
            ref.watch(userLanesProvider).when(
                  data: (lanes) => Expanded(
                    child: ListView.builder(
                        itemCount: lanes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final lane = lanes[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(lane.avatar),
                            ),
                            title: Text('${lane.name}'),
                            onTap: () {
                              navigateToLane(context, lane);
                            },
                          );
                        }),
                  ),
                  error: (error, stackTrace) {
                    return ErrorText(error: error.toString());
                  },
                  loading: () => Loader(),
                ),
            ListTile(
              title: Text('즐겨찾기 레인'),
            ),
          ],
        ),
      ),
    );
  }
}
