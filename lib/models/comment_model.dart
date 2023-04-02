import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommentModel {
  final String id;
  final String text;
  final String createdAt;
  final String postId;
  final String username;
  final String profilePic;
  CommentModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    required this.profilePic,
  });

  CommentModel copyWith({
    String? id,
    String? text,
    String? createdAt,
    String? postId,
    String? username,
    String? profilePic,
  }) {
    return CommentModel(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: map['createdAt'] as String,
      postId: map['postId'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.username == username &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        profilePic.hashCode;
  }
}
