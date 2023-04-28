import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/utils.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/lane/controller/lane_controller.dart';
import 'package:flutter_swim_lane/core/feature/psot/controller/post_controller.dart';
import 'package:flutter_swim_lane/models/lane_model.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  const AddPostTypeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final meterController = TextEditingController();
  final countController = TextEditingController();
  final cycleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? postFile;
  List<LaneModel> lanes = [];
  LaneModel? selectedLane;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    meterController.dispose();
    countController.dispose();
    cycleController.dispose();
    descriptionController.dispose();
  }

  void selectPostImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        postFile = File(res.files.first.path!);
      });
    }
  }

  void addPost() {
    ref.read(postControllerProvider.notifier).addPost(
          context: context,
          selectedLane: selectedLane ?? lanes[0],
          title: titleController.text.trim(),
          meter: meterController.text.trim(),
          count: countController.text.trim(),
          cycle: cycleController.text.trim(),
          description: descriptionController.text.trim(),
          file: postFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final double cardHeightWidth = 120;

    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
          actions: [TextButton(onPressed: () => addPost(), child: Text("추가"))]),
      body: isLoading
          ? Loader()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("사진 선택"),
                GestureDetector(
                  onTap: () {
                    selectPostImage();
                  },
                  child: SizedBox(
                    height: cardHeightWidth,
                    width: cardHeightWidth,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // elevation: 10,
                        child: postFile != null
                            ? Image.file(postFile!)
                            : Center(
                                child: Icon(
                                  Icons.photo_outlined,
                                  size: 40,
                                ),
                              )),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // elevation: 10,
                  child: Center(
                    child: Column(
                      children: [
                        Text("훈련량 작성"),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                              hintText: "종목",
                              contentPadding: EdgeInsets.all(20)),
                        ),
                        TextField(
                          controller: meterController,
                          decoration: InputDecoration(
                              hintText: "거리",
                              contentPadding: EdgeInsets.all(20)),
                        ),
                        TextField(
                          controller: countController,
                          decoration: InputDecoration(
                              hintText: "개수",
                              contentPadding: EdgeInsets.all(20)),
                        ),
                        TextField(
                          controller: cycleController,
                          decoration: InputDecoration(
                              hintText: "싸이클",
                              contentPadding: EdgeInsets.all(20)),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                              hintText: "설명",
                              contentPadding: EdgeInsets.all(20)),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Text("레인 선택"),
                ref.watch(userLanesProvider).when(
                    data: (data) {
                      lanes = data;
                      if (data.isEmpty) {
                        return SizedBox();
                      }
                      return DropdownButton(
                          value: selectedLane,
                          // value: selectedLane ?? data[0],
                          items: data
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.name)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedLane = val;
                            });
                          });
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => Loader())
              ],
            ),
    );
  }
}
