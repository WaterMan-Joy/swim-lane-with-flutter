// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/layouts/post_card.dart';
import 'package:flutter_swim_lane/core/feature/psot/controller/post_controller.dart';
import 'package:flutter_swim_lane/core/feature/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/widgets/error_text.dart';
import '../../../common/widgets/loader.dart';
import '../../auth/controller/auth_controller.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    required this.uid,
  });

  void navigateToEditUserProfile(BuildContext context) {
    Routemaster.of(context).push('/edit-user-profile/${uid}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
        appBar: AppBar(title: Text('프로필 화면')),
        body: ref.watch(getUserDataProvider(uid)).when(data: (data) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  data.profilePic,
                  height: 100,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(user.name),
                        Text('${data.name}'),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => navigateToEditUserProfile(context),
                      child: Text('프로필 수정'),
                    ),
                  ],
                ),
                ref.watch(getUserPostsProvider(uid)).when(data: (data) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = data[index];
                        return Card(
                          child: Text("${post.title}"),
                        );
                      });
                }, error: (error, stackTrace) {
                  print(error.toString());
                  return ErrorText(error: error.toString());
                }, loading: () {
                  return Loader();
                })
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
