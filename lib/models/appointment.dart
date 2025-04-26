import 'package:flutter_agenda_app/models/user.dart';

class Appointment {
  final int? id;
  final String title;
  final String description;
  final bool status;
  final DateTime startHourDate;
  final DateTime endHourDate;
  final User appointmentCreator;
  final String local;

  Appointment({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startHourDate,
    required this.endHourDate,
    required this.appointmentCreator,
    required this.local,
  });
}
