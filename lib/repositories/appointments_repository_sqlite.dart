import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/app.dart';
import 'package:flutter_agenda_app/database/db.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:sqflite/sqflite.dart';

class AppointmentsRepositorySqlite extends ChangeNotifier {
  final DB _dbInstance = DB.instance;
  Appointment? _loggedAppointment;

  Future<Database> get _database async => await _dbInstance.database;


  Future<List<Appointment>> getAppointmentsById(int appointmentId) async {
    try{
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'appointments',
      where: 'id = ? ',
      whereArgs: [appointmentId],
    );
    return List.generate(maps.length, (i) {
      return Appointment.fromJson(maps[i]);
    });
  } catch (e) {
      throw Exception('Erro ao buscar compromissos: ${e.toString()}');
    }
  }

  Future<List<Appointment>> get appointments async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query('appointments');

      return maps.map((map) => Appointment.fromJson(map)).toList();
    } catch (e) {
      throw Exception('veio nulo sapoha: ${e.toString()}');
    }
  }
}