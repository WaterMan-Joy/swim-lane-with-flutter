import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../models/lane_model.dart';
import '../../../common/widgets/error_text.dart';
import '../../../common/widgets/loader.dart';
import '../../auth/controller/auth_controller.dart';
import '../../lane/controller/lane_controller.dart';

class MyLaneListScreen extends ConsumerWidget {
  const MyLaneListScreen({super.key});

  void navigateToCreateLane(BuildContext context) {
    Routemaster.of(context).push('/create-lane');
  }

  void navigateToLane(BuildContext context, LaneModel laneModel) {
    Routemaster.of(context).push('/${laneModel.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(title: Text('${user.name} 레인')),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text('레인 만들기'),
              onTap: () => navigateToCreateLane(context),
            ),
            ListTile(
              title: Text('내 레인'),
            ),
            ref.watch(userLanesProvider).when(
                  data: (lanes) {
                    return Expanded(
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
                    );
                  },
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
