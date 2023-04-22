// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/feature/user_profile/controller/user_profile_controller.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/utils.dart';
import '../../../common/widgets/error_text.dart';
import '../../../common/widgets/loader.dart';
import '../../auth/controller/auth_controller.dart';

class EditUserProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditUserProfileScreen({
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends ConsumerState<EditUserProfileScreen> {
  // File? bannerFile;
  // File? avatarFile;
  File? profilePicFile;

  late TextEditingController nameController;

  void selectProfilePicImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profilePicFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUser(
          profilePicFile: profilePicFile,
          context: context,
          name: nameController.text.trim(),
        );
  }

  // void selectBannerImage() async {
  //   final res = await pickImage();
  //   if (res != null) {
  //     setState(() {
  //       bannerFile = File(res.files.first.path!);
  //     });
  //   }
  // }

  // void selectAvatarImage() async {
  //   final res = await pickImage();
  //   if (res != null) {
  //     setState(() {
  //       avatarFile = File(res.files.first.path!);
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final size = MediaQuery.of(context).size;
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                title: Text('프로필 수정'),
                actions: [
                  TextButton(
                    onPressed: save,
                    child: Text('완료'),
                  ),
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
                              onTap: selectProfilePicImage,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(20),
                                padding: EdgeInsets.all(6),
                                // strokeWidth: 5,
                                child: Container(
                                  width: size.width * 0.3,
                                  child: profilePicFile != null
                                      ? Image.file(profilePicFile!)
                                      : data.profilePic.isEmpty ||
                                              data.profilePic ==
                                                  Constants.bannerDefault
                                          ? Icon(
                                              Icons.camera_alt_outlined,
                                              size: 200,
                                            )
                                          : Image.network(data.profilePic),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: '이름',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(20),
                              ),
                            )
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
