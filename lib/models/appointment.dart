import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/models/user.dart';

class Appointment {
  final int? id;
  final String title;
  final String description;
  final bool status;
  final DateTime startHourDate;
  final DateTime endHourDate;
  final User? appointmentCreator;
  final String local;
  final List<Invitation> invitations;

  Appointment({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startHourDate,
    required this.endHourDate,
     this.appointmentCreator,
    required this.local,
    List<Invitation>? invitations,
  }) : invitations = invitations ?? [];


factory Appointment.fromJson(Map<String, dynamic> json) {
  return Appointment(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    status: json['status'] == 1,
    startHourDate: DateTime.parse(json['start_hour_date']),
    endHourDate: DateTime.parse(json['end_hour_date']),
    local: json['local']
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status ? 1 : 0,
      'start_hour_date': startHourDate.toIso8601String(),
      'end_hour_date': endHourDate.toIso8601String(),
      'local': local,
      'invitations': invitations.map((invitation) => invitation.toJson()).toList(),
    };
  }
}