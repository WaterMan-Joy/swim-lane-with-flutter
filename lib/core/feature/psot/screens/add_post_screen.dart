import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    final double cardHeightWidth = 120;
    final double iconSize = 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            print("object");
          },
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Center(
            child: Column(
              children: [
                Text("훈련량 작성"),
                TextField(
                  decoration: InputDecoration(hintText: "종목"),
                ),
                TextField(
                  decoration: InputDecoration(hintText: "거리"),
                ),
                TextField(
                  decoration: InputDecoration(hintText: "개수"),
                ),
                TextField(
                  decoration: InputDecoration(hintText: "싸이클"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
