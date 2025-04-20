import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';

abstract class AppointmentsRepository extends ChangeNotifier {
  List<Appointment> get appointments;

  void addAppointment(String title);
  void removeAppointment(Appointment appointment);
  void updateAppointment(Appointment appointment, String title);
}
