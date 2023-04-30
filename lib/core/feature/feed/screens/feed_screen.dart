import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/layouts/post_card.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';
import 'package:flutter_swim_lane/core/feature/psot/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userLanesProvider).when(
        data: (lanes) {
          return ref.watch(userPostsProvider(lanes)).when(
              data: (posts) {
                return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = posts[index];
                      return PostCard(post: post);
                    });
              },
              error: (error, stackTrace) {
                print(error);
                return ErrorText(error: error.toString());
              },
              loading: () => Loader());
        },
        error: (error, stackTrace) {
          return ErrorText(error: error.toString());
        },
        loading: () => Loader());
  }
}
