import 'package:flutter_agenda_app/models/user.dart';

class Location {
  int? id;
  String? zipCode;
  String? address;
  bool? noNumber;
  String? number;
  String? city;
  String? state;
  String? neighborhood;
  User? user;

  Location({
    this.id,
    this.zipCode,
    this.address,
    this.noNumber,
    this.number,
    this.city,
    this.state,
    this.neighborhood,
    this.user,
  });
}
