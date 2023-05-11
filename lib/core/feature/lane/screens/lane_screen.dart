// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';
import 'package:flutter_swim_lane/models/lane_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class LaneScreen extends ConsumerWidget {
  final String name;
  const LaneScreen({
    required this.name,
  });

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/${name}');
  }

  void joinLane(WidgetRef ref, BuildContext context, LaneModel laneModel) {
    ref.read(laneControllerProvider.notifier).joinLane(context, laneModel);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
        body: ref.watch(getLaneByNameProvider(name)).when(data: (data) {
      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(child: Image.network(data.banner)),
                ],
              ),
            ),
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                data.avatar,
                height: 100,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(user.name),
                      Text('${data.name} - 멤버 ${data.members.length}명'),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.star_border),
                  data.masters.contains(user.uid)
                      ? ElevatedButton(
                          onPressed: () {
                            return navigateToModTools(context);
                          },
                          child: Text('모임 수정'))
                      : ElevatedButton(
                          onPressed: () => joinLane(ref, context, data),
                          child: Text(data.members.contains(user.uid)
                              ? '가입완료'
                              : '가입하기')),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ],
          ),
        ),
      );
    }, error: (error, stackTrace) {
      return ErrorText(error: error.toString());
    }, loading: () {
      return Loader();
    }));
  }
}
