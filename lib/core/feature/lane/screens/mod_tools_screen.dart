// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  final String name;
  const ModToolsScreen({
    required this.name,
  });

  void navigateToEditLane(BuildContext context) {
    Routemaster.of(context).push('/edit-lane/${name}');
  }

  void navigateToAddMasters(BuildContext context) {
    Routemaster.of(context).push('/add-masters/${name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
        appBar: AppBar(
          title: Text('${user.name} 님의 모임 수정'),
        ),
        body: ref.watch(getLaneByNameProvider(name)).when(
            data: (data) {
              return Center(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('${data.name} 의 설정'),
                      subtitle: Text('프로필 설정, 배너 설정'),
                      onTap: () => navigateToEditLane(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.add_home_outlined),
                      title: Text('마스터 관리자 추가'),
                      subtitle: Text('운영진 관리'),
                      onTap: () => navigateToAddMasters(context),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorText(error: error.toString());
            },
            loading: () => Loader())
        // Column(
        //   children: [
        //     ListTile(
        //       title: Text('레인 프로필 수정'),
        //       onTap: () {},
        //     ),
        //     ListTile(
        //       title: Text('레인 배너 수정'),
        //       onTap: () {},
        //     ),
        //   ],
        // ),
        );
  }
}
