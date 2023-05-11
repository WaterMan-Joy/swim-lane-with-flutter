import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';

import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';
import 'package:flutter_swim_lane/core/feature/psot/controller/post_controller.dart';
import 'package:flutter_swim_lane/models/lane_model.dart';
import 'package:flutter_swim_lane/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  final LaneModel lane;
  const PostCard({
    required this.post,
    required this.lane,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/user-profile/${post.uid}');
  }

  void navigateToLane(BuildContext context) {
    Routemaster.of(context).push('/${post.selectedLane}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => navigateToLane(context),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(lane.avatar),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("${post.selectedLane}"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ref.watch(getLaneByNameProvider(post.selectedLane)).when(
                        data: (data) {
                          if (data.masters.contains(user.uid)) {
                            return Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "마스터",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return SizedBox();
                        },
                        error: (error, stackTrace) {
                          return ErrorText(error: error.toString());
                        },
                        loading: () => Loader(),
                      ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: post.uid.contains(user.uid)
                        ? Text(
                            "내글",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "남의글",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                          "생성일 : ${post.createAt.month}월 ${post.createAt.hour}시 ${post.createAt.minute}분"),
                      ElevatedButton(
                        onPressed: () => navigateToUser(context),
                        child: Text("작성자 : ${user.name}"),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text("${post.title}"),
              Row(
                children: [
                  Text("${post.meter}미터"),
                  Text("${post.count}개 "),
                  Text("${post.cycle}싸이클 "),
                ],
              ),
              Text("설명 - ${post.description}"),
              ElevatedButton(onPressed: () {}, child: Text("GO")),
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.network(
                  post.link,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => navigateToLane(context),
                    child: Text("${post.selectedLane}"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                          onPressed: () => upvotePost(ref),
                          icon: Icon(
                            Icons.arrow_circle_up,
                            color: post.upvotes.contains(user.uid)
                                ? Colors.orange
                                : Colors.grey,
                          ),
                          label: Text(post.upvotes.length.toString())),
                      ElevatedButton.icon(
                        onPressed: () => downvotePost(ref),
                        icon: Icon(
                          Icons.arrow_circle_down,
                          color: post.downvotes.contains(user.uid)
                              ? Colors.orange
                              : Colors.grey,
                        ),
                        label: Text(post.downvotes.length.toString()),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("댓글:${post.commentCount}"),
                  Spacer(),
                  if (user.uid == post.uid)
                    IconButton(
                        onPressed: () => deletePost(ref, context),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
