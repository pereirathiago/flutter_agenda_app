import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';

abstract class AppointmentsRepository extends ChangeNotifier {
  List<Appointment> get appointments;

  void addAppointment(Appointment appointment);
  void removeAppointment(int id);
  void updateAppointment(Appointment appointment);
  List<Appointment> getAll();
  Appointment? getAppointmentsById(int id);
}
