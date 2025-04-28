import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';
import 'package:flutter_agenda_app/ui/appointments/new_appointment.dart';

class AppointmentsRepositoryMemory extends ChangeNotifier
    implements AppointmentsRepository {
  final List<Appointment> _appointments = [];
  final List<Invitation> _invitations = [];

  @override
  List<Appointment> get appointments => UnmodifiableListView(_appointments);
  List<Invitation> get invitations => UnmodifiableListView(_invitations);

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
      invitations: [],
    );

    if (_appointments.any((a) => a.id == newAppointment.id)) {
      throw Exception('Appointment already exists with this ID.');
    }

    _appointments.add(newAppointment);
    notifyListeners();
  }

  @override
  void removeAppointment(int id) {
    _appointments.removeWhere((appointment) => appointment.id == id);
    _invitations.removeWhere((invitation) => invitation.appointmentId == id);
    notifyListeners();
  }

  @override
  void updateAppointment(Appointment updatedAppointment) {
    final index = _appointments.indexWhere(
      (a) => a.id == updatedAppointment.id,
    );

    if (index == -1) {
      throw Exception('Appointment not found 😢📅');
    }

    _appointments[index] = updatedAppointment;

    notifyListeners(); // Atualiza todo mundo feliz 🥳🎈
  }

  void addInvitation(Invitation invitation) {
    _invitations.add(invitation);
    notifyListeners();
  }

  List<Invitation> getInvitationsByOrganizer(String organizerUser) {
    return _invitations
        .where((invitation) => invitation.organizerUser == organizerUser)
        .toList();
  }

  List<Invitation> getInvitationsByAppointmentCreator(
    String appointmentCreator,
  ) {
    return _invitations
        .where((invitation) => invitation.organizerUser == appointmentCreator)
        .toList();
  }

@override
  Appointment? getAppointmentsById(int id) {
    try{
    return _appointments.firstWhere(
      (appointment) => appointment.id == id
    ); } catch (e){
      return null;
    }
  }
}
