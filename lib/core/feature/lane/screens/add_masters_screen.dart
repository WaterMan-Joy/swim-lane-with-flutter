// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';

class AddMastersScreen extends ConsumerStatefulWidget {
  final String name;
  const AddMastersScreen({
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddMastersScreenState();
}

class _AddMastersScreenState extends ConsumerState<AddMastersScreen> {
  Set<String> uids = {};
  int ctr = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMasters() {
    ref.read(laneControllerProvider.notifier).addMasters(
          widget.name,
          uids.toList(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('관리자 추가'),
        actions: [
          IconButton(onPressed: saveMasters, icon: Icon(Icons.done)),
        ],
      ),
      body: ref.watch(getLaneByNameProvider(widget.name)).when(data: (lane) {
        return ListView.builder(
            itemCount: lane.members.length,
            itemBuilder: (BuildContext, index) {
              final member = lane.members[index];

              return ref.watch(getUserDataProvider(member)).when(data: (user) {
                if (lane.masters.contains(member) && ctr == 0) {
                  uids.add(member);
                }
                ctr++;
                return CheckboxListTile(
                  value: uids.contains(user.uid),
                  onChanged: (val) {
                    if (val!) {
                      addUid(user.uid);
                    } else {
                      removeUid(user.uid);
                    }
                  },
                  title: Text('${user.name}'),
                );
              }, error: (error, stackTrace) {
                return ErrorText(error: error.toString());
              }, loading: () {
                return Loader();
              });
            });
      }, error: (error, stackTrace) {
        return ErrorText(error: error.toString());
      }, loading: () {
        return Loader();
      }),
    );
  }
}
