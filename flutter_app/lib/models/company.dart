import 'dart:convert';
import 'dart:math';

import 'package:transport_bilty_generator/models/address.dart';

class Company {
  final int id;
  final String name;
  final String logoURL;
  final List<dynamic> address;
  final String nameInitials;
  final String email;
  final List<dynamic>? phone;
  final String? gstIN;
  final String? pan;

  const Company({
    required this.id,
    required this.name,
    required this.logoURL,
    required this.address,
    required this.nameInitials,
    required this.email,
    required this.phone,
    required this.gstIN,
    required this.pan,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      nameInitials: json['nameInitials'],
      logoURL: json['logoUrl'],
      address: json['address']
          .map(
            (address) => Address.fromJson(address),
          )
          .toList(),
      email: json['email'],
      phone: json['phone'],
      gstIN: json['gstIn'],
      pan: json['pan'],
    );
  }

  Map<String, dynamic> toJson() {
    List<dynamic> jsonAddress =
        address.map((e) => jsonDecode(jsonEncode(e))).toList();
    return {
      "id": id,
      "name": name,
      "nameInitials": nameInitials,
      "logoURL": logoURL,
      "address": jsonAddress,
      "email": email,
      "phone": phone,
      "gstIn": gstIN,
      "pan": pan
    };
  }
}
