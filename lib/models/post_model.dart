import 'dart:convert';

import 'package:flutter/foundation.dart';

class PostModel {
  final String id;
  final String title;
  final String meter;
  final String count;
  final String cycle;
  final String description;
  final String selectedLane;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String username;
  final String uid;
  final DateTime createAt;
  final String link;
  PostModel({
    required this.id,
    required this.title,
    required this.meter,
    required this.count,
    required this.cycle,
    required this.description,
    required this.selectedLane,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.createAt,
    required this.link,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? meter,
    String? count,
    String? cycle,
    String? description,
    String? selectedLane,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? username,
    String? uid,
    DateTime? createAt,
    String? link,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      meter: meter ?? this.meter,
      count: count ?? this.count,
      cycle: cycle ?? this.cycle,
      description: description ?? this.description,
      selectedLane: selectedLane ?? this.selectedLane,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      createAt: createAt ?? this.createAt,
      link: link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'meter': meter,
      'count': count,
      'cycle': cycle,
      'description': description,
      'selectedLane': selectedLane,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'createAt': createAt.millisecondsSinceEpoch,
      'link': link,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      meter: map['meter'] ?? '',
      count: map['count'] ?? '',
      cycle: map['cycle'] ?? '',
      description: map['description'] ?? '',
      selectedLane: map['selectedLane'] ?? '',
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      commentCount: map['commentCount']?.toInt() ?? 0,
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt']),
      link: map['link'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostModel(id: $id, title: $title, meter: $meter, count: $count, cycle: $cycle, description: $description, selectedLane: $selectedLane, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, username: $username, uid: $uid, createAt: $createAt, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostModel &&
        other.id == id &&
        other.title == title &&
        other.meter == meter &&
        other.count == count &&
        other.cycle == cycle &&
        other.description == description &&
        other.selectedLane == selectedLane &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        other.commentCount == commentCount &&
        other.username == username &&
        other.uid == uid &&
        other.createAt == createAt &&
        other.link == link;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        meter.hashCode ^
        count.hashCode ^
        cycle.hashCode ^
        description.hashCode ^
        selectedLane.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        commentCount.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        createAt.hashCode ^
        link.hashCode;
  }
}
