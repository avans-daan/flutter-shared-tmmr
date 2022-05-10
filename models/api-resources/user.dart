import 'package:flutter/material.dart';

@immutable
class User {
  const User({required this.id, required this.name, required this.email, this.settings});

  final String id;
  final String name;
  final String email;
  final dynamic settings;

  static User fromJson(dynamic content) {
    return User(
        id: content['id'],
        name: content['name'],
        email: content['email'],
        settings: content['settings']);
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    dynamic settings,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'settings': settings,
    };
  }
}
