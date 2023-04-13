// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/widgets/error_text.dart';
import '../../../common/widgets/loader.dart';
import '../../auth/controller/auth_controller.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
        body: ref.watch(getUserDataProvider(uid)).when(data: (data) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              data.profirePic,
              height: 100,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(user.name),
                    Text('${data.name} - 멤버 ${'data.members.length'}명'),
                  ],
                ),
                Spacer(),
                Icon(Icons.star_border),
                // data.masters.contains(user.uid)
                //     ? ElevatedButton(
                //         onPressed: () {
                //           return navigateToModTools(context);
                //         },
                //         child: Text('모임 수정'))
                //     : ElevatedButton(
                //         onPressed: () => joinLane(ref, context, data),
                //         child: Text(data.members.contains(user.uid)
                //             ? '가입완료'
                //             : '가입하기'),
                //       ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Column(
                    children: [
                      Text('날짜 - 2023-03-23'),
                      Text('훈련량 2000M - 운동 8개'),
                      Text('1. Warm Up - 200M 1C'),
                      Text('2. Warm Up - 200M 1C'),
                      Text('3. Warm Up - 200M 1C'),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Text('날짜 - 2023-03-23'),
                      Text('훈련량 2000M - 운동 8개'),
                      Text('1. Warm Up - 200M 1C'),
                      Text('2. Warm Up - 200M 1C'),
                      Text('3. Warm Up - 200M 1C'),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Text('날짜 - 2023-03-23'),
                      Text('훈련량 2000M - 운동 8개'),
                      Text('1. Warm Up - 200M 1C'),
                      Text('2. Warm Up - 200M 1C'),
                      Text('3. Warm Up - 200M 1C'),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Text('날짜 - 2023-03-23'),
                      Text('훈련량 2000M - 운동 8개'),
                      Text('1. Warm Up - 200M 1C'),
                      Text('2. Warm Up - 200M 1C'),
                      Text('3. Warm Up - 200M 1C'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }, error: (error, stackTrace) {
      return ErrorText(error: error.toString());
    }, loading: () {
      return Loader();
    }));
  }
}
