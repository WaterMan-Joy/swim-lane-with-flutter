import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_swim_lane/models/post_model.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  const PostCard({
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(children: [
        Row(
          children: [
            Text("훈련 이름 - ${post.title}"),
            Spacer(),
            Text("레인 이름 - ${post.selectedLane}"),
          ],
        ),
        Row(
          children: [
            Text("meter - ${post.meter}"),
            Text("count - ${post.count}"),
            Text("cycle - ${post.cycle}"),
          ],
        ),
        Text("des - ${post.description}"),
      ]),
    );
  }
}
