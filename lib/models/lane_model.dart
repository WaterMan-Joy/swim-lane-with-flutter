import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LaneModel {
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<String> members;
  final List<String> masters;
  LaneModel({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.masters,
  });

  LaneModel copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? members,
    List<String>? masters,
  }) {
    return LaneModel(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      masters: masters ?? this.masters,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'banner': banner,
      'avatar': avatar,
      'members': members,
      'masters': masters,
    };
  }

  factory LaneModel.fromMap(Map<String, dynamic> map) {
    return LaneModel(
      id: map['id'] as String,
      name: map['name'] as String,
      banner: map['banner'] as String,
      avatar: map['avatar'] as String,
      members: List<String>.from(map['members']),
      masters: List<String>.from(map['masters']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LaneModel.fromJson(String source) =>
      LaneModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Lane(id: $id, name: $name, banner: $banner, avatar: $avatar, members: $members, masters: $masters)';
  }

  @override
  bool operator ==(covariant LaneModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.banner == banner &&
        other.avatar == avatar &&
        listEquals(other.members, members) &&
        listEquals(other.masters, masters);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        banner.hashCode ^
        avatar.hashCode ^
        members.hashCode ^
        masters.hashCode;
  }
}
