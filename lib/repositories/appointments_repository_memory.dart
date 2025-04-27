import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';
import 'package:flutter_agenda_app/ui/appointments/new_appointment.dart';

class AppointmentsRepositoryMemory extends ChangeNotifier
    implements AppointmentsRepository {
  final List<Appointment> _appointments = [];

  @override
  List<Appointment> get appointments => UnmodifiableListView(_appointments);

  @override
  void addAppointment(Appointment appointment) {
    final newAppointment = Appointment(
      id: Random().nextInt(10000), // Gera o ID novo aqui ✨
      title: appointment.title,
      description: appointment.description,
      status: appointment.status,
      startHourDate: appointment.startHourDate,
      endHourDate: appointment.endHourDate,
      appointmentCreator: appointment.appointmentCreator,
      local: appointment.local,
    );

    if (_appointments.any((a) => a.id == newAppointment.id)) {
      throw Exception('Appointment already exists with this ID.');
    }

    _appointments.add(newAppointment);
    notifyListeners();
  }

  @override
  void removeAppointment(Appointment appointment) {
    // TODO: implement removeAppointment
  }

@override
void updateAppointment(Appointment updatedAppointment) {
  final index = _appointments.indexWhere((a) => a.id == updatedAppointment.id);

  if (index == -1) {
    throw Exception('Appointment not found 😢📅');
  }

  _appointments[index] = updatedAppointment;

  notifyListeners(); // Atualiza todo mundo feliz 🥳🎈
}

}
