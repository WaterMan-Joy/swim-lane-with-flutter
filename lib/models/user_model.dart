import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String uid;
  final String name;
  final String profirePic;
  UserModel({
    required this.uid,
    required this.name,
    required this.profirePic,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profirePic,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profirePic: profirePic ?? this.profirePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profirePic': profirePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profirePic: map['profirePic'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(uid: $uid, name: $name, profirePic: $profirePic)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.profirePic == profirePic;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ profirePic.hashCode;
}
