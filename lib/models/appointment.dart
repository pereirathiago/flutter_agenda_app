import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/models/user.dart';

class Appointment {
  final int? id;
  final String title;
  final String description;
  final bool status;
  final DateTime startHourDate;
  final DateTime endHourDate;
  final User appointmentCreator;
  final String local; //aqui talvez tenha que ser um objeto Location
  final List<Invitation> invitations;

  Appointment({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startHourDate,
    required this.endHourDate,
    required this.appointmentCreator,
    required this.local,
    List<Invitation>? invitations,
  }) : invitations = invitations ?? [];
}
