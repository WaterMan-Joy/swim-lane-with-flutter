import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostModel {
  final String id;
  final String title;
  final String description;
  final String laneName;
  final String laneProfilePic;
  final List<String> upvotes;
  final List<String> downvotes;
  final String commentCount;
  final String uid;
  final String type;
  final String createAt;
  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.laneName,
    required this.laneProfilePic,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.uid,
    required this.type,
    required this.createAt,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? description,
    String? laneName,
    String? laneProfilePic,
    List<String>? upvotes,
    List<String>? downvotes,
    String? commentCount,
    String? uid,
    String? type,
    String? createAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      laneName: laneName ?? this.laneName,
      laneProfilePic: laneProfilePic ?? this.laneProfilePic,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'laneName': laneName,
      'laneProfilePic': laneProfilePic,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'uid': uid,
      'type': type,
      'createAt': createAt,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      laneName: map['laneName'] as String,
      laneProfilePic: map['laneProfilePic'] as String,
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      commentCount: map['commentCount'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      createAt: map['createAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, title: $title, description: $description, laneName: $laneName, laneProfilePic: $laneProfilePic, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, uid: $uid, type: $type, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.laneName == laneName &&
        other.laneProfilePic == laneProfilePic &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        other.commentCount == commentCount &&
        other.uid == uid &&
        other.type == type &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        laneName.hashCode ^
        laneProfilePic.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        commentCount.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        createAt.hashCode;
  }
}
