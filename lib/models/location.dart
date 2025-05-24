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
}
