import 'package:flutter_agenda_app/models/user.dart';

class Location {
  int? id;
  final String zipCode;
  final String address;
  final bool noNumber;
  final String number;
  final String city;
  final String state;
  final String neighborhood;
  int? userId;
  User? user;

  Location({
    this.id,
    required this.zipCode,
    required this.address,
    required this.noNumber,
    required this.number,
    required this.city,
    required this.state,
    required this.neighborhood,
    this.userId,
    this.user,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int?,
      zipCode: json['zip_code'] as String,
      address: json['address'] as String,
      noNumber: json['no_number'] != null ? (json['no_number'] == 1) : false,
      number: json['number'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      neighborhood: json['neighborhood'] as String,
      userId: json['user_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zip_code': zipCode,
      'address': address,
      'no_number': noNumber ? 1 : 0,
      'number': number,
      'city': city,
      'state': state,
      'neighborhood': neighborhood,
      'user_id': userId,
    };
  }
}
