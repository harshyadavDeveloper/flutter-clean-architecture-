import 'dart:convert';

import 'package:create_user_app/core/utils/typedef.dart';
import 'package:create_user_app/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.avatar,
    required super.name,
    required super.createdAt,
  });

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
    : this(
        avatar: map['avatar'] as String,
        id: map['id'] as String,
        name: map['name'] as String,
        createdAt: map['createdAt'],
      );

  UserModel copyWith({
    String? avatar,
    String? id,
    String? name,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  DataMap toMap() => {
    'id': id,
    'avatar': avatar,
    'createdAt': createdAt,
    'name': name,
  };

  String toJson() => jsonEncode(toMap());
}
