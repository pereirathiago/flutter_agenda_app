import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';
import 'package:flutter_agenda_app/ui/appointments/new_appointment.dart';

class AppointmentsRepositoryMemory extends ChangeNotifier implements AppointmentsRepository {
  final List<Appointment> _appointments = [];


  @override
  List<Appointment> get appointments => UnmodifiableListView(_appointments);

  @override
  void addAppointment(Appointment appointment) {
    if (_appointments.any((a) => a.id == appointment.id)) {
      throw Exception('Appointment already exists with this ID.');
    }

    _appointments.add(appointment);
    notifyListeners();

    final newAppointment = Appointment(
      id: Random().nextInt(10000),
      title: appointment.title,
      description: appointment.description,
      status: appointment.status,
      startHourDate: appointment.startHourDate,
      endHourDate: appointment.endHourDate,
      appointmentCreator: appointment.appointmentCreator,
      local: appointment.local,
    );

    _appointments.add(newAppointment);
    notifyListeners();
    
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
