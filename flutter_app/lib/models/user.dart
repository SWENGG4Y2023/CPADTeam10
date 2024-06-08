import 'package:transport_bilty_generator/models/company.dart';

class User {
  final int id;
  final String name;
  final String email;
  final List<dynamic> roles;
  final Company company;
  final String time;
  final bool isActive;

  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.roles,
      required this.company,
      required this.time,
      required this.isActive});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        roles: json['roles'],
        company: Company.fromJson(json['company']),
        time: json['createdTime'],
        isActive: json['isActive']);
  }
}
