import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/layouts/default_layout.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';

class CreateLaneScreen extends ConsumerStatefulWidget {
  const CreateLaneScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateLaneScreenState();
}

class _CreateLaneScreenState extends ConsumerState<CreateLaneScreen> {
  final TextEditingController laneNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    laneNameController.dispose();
  }

  void createLane() {
    ref
        .read(laneControllerProvider.notifier)
        .createLane(laneNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(laneControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('레인 만들기'),
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        // ],
      ),
      body: isLoading
          ? Loader()
          : DefaultLayout(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: laneNameController,
                      decoration: InputDecoration(
                        hintText: '레인 이름',
                        filled: true,
                        border: InputBorder.none,
                        fillColor: Colors.blue[200],
                      ),
                      maxLength: 21,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          // backgroundColor: Colors.blue[400],
                          side: BorderSide(width: 1, color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      onPressed: () => createLane(),
                      child: Text('레인 만들기'),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
    );
  }
}
