import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';

class AppointmentsRepositoryMemory extends ChangeNotifier
    implements AppointmentsRepository {
  final List<Appointment> _appointments = [];

  @override
  List<Appointment> get appointments => UnmodifiableListView(_appointments);

  @override
  void addAppointment(String title) {
    // TODO: implement addAppointment
  }

  @override
  void removeAppointment(Appointment appointment) {
    // TODO: implement removeAppointment
  }

  @override
  void updateAppointment(Appointment appointment, String title) {
    // TODO: implement updateAppointment
  }
}
