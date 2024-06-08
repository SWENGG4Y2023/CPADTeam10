import 'dart:convert';

import 'package:transport_bilty_generator/models/address.dart';

class Customer {
  final int? id;
  final List<dynamic> address;
  final String email;
  final String? gstIn;
  final String name;
  final String pan;
  final List<dynamic> phone;
  final String? country;

  const Customer({
    this.id,
    required this.address,
    required this.email,
    required this.gstIn,
    required this.name,
    required this.pan,
    required this.phone,
    required this.country,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: json['id'],
        address: json['address']
            .map(
              (address) => Address.fromJson(address),
            )
            .toList(),
        email: json['email'],
        gstIn: json['gstIn'],
        name: json['name'],
        pan: json["pan"],
        phone: json['phone'],
        country: json['country']);
  }

  Map<String, dynamic> toJson() {
    List<dynamic> json_address =
        address.map((e) => jsonDecode(jsonEncode(e))).toList();
    return {
      "address": json_address,
      "email": email,
      "gstIn": gstIn,
      "name": name,
      "pan": pan,
      "phone": phone,
      "country": country,
    };
  }
}
