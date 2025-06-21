import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';

abstract class AppointmentsRepository extends ChangeNotifier {
  List<Appointment> get appointments;

  Future<int> addAppointment(Appointment appointment);
  Future<void> removeAppointment(int id);
  Future<void> updateAppointment(Appointment appointment);
  Future<List<Appointment>> getAll();
  Future<List<Appointment>> getAppointmentsById(int id);
  Future<Appointment?> getAppointmentById(int id);
}
