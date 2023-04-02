// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';

import '../controller/lane_controller.dart';

class EditLaneScreen extends ConsumerWidget {
  final String name;
  const EditLaneScreen({
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('레인 수정'),
        actions: [
          TextButton(onPressed: () {}, child: Text('저장')),
        ],
      ),
      body: ref.watch(getLaneByNameProvider(name)).when(
            data: (data) {
              return Center(
                child: Column(
                  children: [
                    Text('${data.avatar}'),
                  ],
                ),
              );
            },
            error: (error, stackTrace) {
              return ErrorText(
                error: error.toString(),
              );
            },
            loading: () => Loader(),
          ),
    );
  }
}
