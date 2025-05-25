import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';

class AppointmentsRepositoryMemory extends ChangeNotifier
    implements AppointmentsRepository {
  final List<Appointment> _appointments = [
    Appointment(
      id: 1,
      title: 'Reunião de equipe',
      description: 'Discutir os objetivos do projeto',
      status: true,
      startHourDate: DateTime.now().add(Duration(days: 1, hours: 2)),
      endHourDate: DateTime.now().add(Duration(days: 1, hours: 3)),
      appointmentCreator: User(
        id: 1,
        fullName: 'João Silva',
        username: 'joao.silva',
        email: 'a@a.com',
        password: '123456'),
      local: 'Sala de reuniões 1',
      invitations: [],
    ),
  ];
  final List<Invitation> _invitations = [];
  

  @override
  List<Appointment> get appointments => UnmodifiableListView(_appointments);
  List<Invitation> get invitations => UnmodifiableListView(_invitations);

  @override
  void addAppointment(Appointment appointment) {
    final newAppointment = Appointment(
      id: Random().nextInt(10000),
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

    notifyListeners();
  }

  @override
  List<Appointment> getAll() {
    return _appointments;
  }

  void addInvitation(Invitation invitation) {
    _invitations.add(invitation);
    notifyListeners();
  }

  List<Invitation> getInvitationsByOrganizer(String organizerUser) {
    return _invitations
        .where((invitation) => invitation.idOrganizerUser == organizerUser)
        .toList();
  }

  List<Invitation> getInvitationsByAppointmentCreator(
    String appointmentCreator,
  ) {
    return _invitations
        .where((invitation) => invitation.idOrganizerUser == appointmentCreator)
        .toList();
  }

  @override
  Appointment? getAppointmentsById(int id) {
    try {
      return _appointments.firstWhere((appointment) => appointment.id == id);
    } catch (e) {
      return null;
    }
  }
}
