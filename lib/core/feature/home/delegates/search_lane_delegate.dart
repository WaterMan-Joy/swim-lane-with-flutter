// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../models/lane_model.dart';

class SearchLaneDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchLaneDelegate(
    this.ref,
  );
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchLaneProvider(query)).when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final lane = data[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(lane.avatar),
                ),
                title: Text(lane.name),
                onTap: () {
                  return navigateToLane(context, lane.name);
                },
              );
            },
          );
        },
        error: (error, stackTrace) {
          return ErrorText(error: error.toString());
        },
        loading: () => Loader());
  }

  void navigateToLane(BuildContext context, String laneName) {
    Routemaster.of(context).push('/${laneName}');
  }
}
