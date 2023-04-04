// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/constants.dart';
import 'package:flutter_swim_lane/core/common/constants/utils.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/models/lane_model.dart';
import '../controller/lane_controller.dart';

class EditLaneScreen extends ConsumerStatefulWidget {
  final String name;
  const EditLaneScreen({
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditLaneScreenState();
}

class _EditLaneScreenState extends ConsumerState<EditLaneScreen> {
  File? bannerFile;
  File? avatarFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectAvatarImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        avatarFile = File(res.files.first.path!);
      });
    }
  }

  void save(LaneModel laneModel) {
    ref.read(laneControllerProvider.notifier).editLane(
          avatarFile: avatarFile,
          bannerFile: bannerFile,
          context: context,
          laneModel: laneModel,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(laneControllerProvider);
    final size = MediaQuery.of(context).size;
    return ref.watch(getLaneByNameProvider(widget.name)).when(
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                title: Text('레인 수정'),
                actions: [
                  TextButton(onPressed: () => save(data), child: Text('저장')),
                ],
              ),
              body: isLoading
                  ? Loader()
                  : Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: selectBannerImage,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(20),
                                padding: EdgeInsets.all(6),
                                // strokeWidth: 5,
                                child: Container(
                                  width: size.width * 0.9,
                                  child: bannerFile != null
                                      ? Image.file(bannerFile!)
                                      : data.banner.isEmpty ||
                                              data.banner ==
                                                  Constants.bannerDefault
                                          ? Icon(
                                              Icons.camera_alt_outlined,
                                              size: 200,
                                            )
                                          : Image.network(data.banner),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: selectAvatarImage,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(20),
                                padding: EdgeInsets.all(6),
                                // strokeWidth: 5,
                                child: Container(
                                  width: size.width * 0.5,
                                  child: avatarFile != null
                                      ? Image.file(avatarFile!)
                                      : data.avatar.isEmpty ||
                                              data.avatar ==
                                                  Constants.avatarDefault
                                          ? Icon(
                                              Icons.camera_alt_outlined,
                                              size: 200,
                                            )
                                          : Image.network(data.avatar),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            DottedBorder(
                              child: Text('레인 이름: ${data.name}'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            DottedBorder(
                              child: Text('레인 설명 : '),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              error: error.toString(),
            );
          },
          loading: () => Loader(),
        );
  }
}

// class EditLaneScreen extends ConsumerWidget {
//   final String name;
//   const EditLaneScreen({
//     required this.name,
//   });

//   void selectBannerImage() async {
//     final res = await pickImage();
//     if (res!=null) {

//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('레인 수정'),
//         actions: [
//           TextButton(onPressed: () {}, child: Text('저장')),
//         ],
//       ),
//       body: ref.watch(getLaneByNameProvider(name)).when(
//             data: (data) {
//               return Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       DottedBorder(
//                         borderType: BorderType.RRect,
//                         radius: Radius.circular(20),
//                         padding: EdgeInsets.all(6),
//                         // strokeWidth: 5,
//                         child: Container(
//                           width: size.width * 0.9,
//                           child: data.banner.isEmpty ||
//                                   data.banner == Constants.bannerDefault
//                               ? Icon(
//                                   Icons.camera_alt_outlined,
//                                   size: 200,
//                                 )
//                               : Image.network(data.banner),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       DottedBorder(
//                         borderType: BorderType.RRect,
//                         radius: Radius.circular(20),
//                         padding: EdgeInsets.all(6),
//                         // strokeWidth: 5,
//                         child: Container(
//                           width: size.width * 0.5,
//                           child: data.avatar.isEmpty ||
//                                   data.avatar == Constants.avatarDefault
//                               ? Icon(
//                                   Icons.camera_alt_outlined,
//                                   size: 200,
//                                 )
//                               : Image.network(data.avatar),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       DottedBorder(
//                         child: Text('레인 이름: ${data.name}'),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       DottedBorder(
//                         child: Text('레인 설명 : '),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//             error: (error, stackTrace) {
//               return ErrorText(
//                 error: error.toString(),
//               );
//             },
//             loading: () => Loader(),
//           ),
//     );
//   }
// }
