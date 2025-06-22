import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/database/db.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';
import 'package:sqflite/sqflite.dart';

class AppointmentsRepositorySqlite extends ChangeNotifier
    implements AppointmentsRepository {
  final DB _dbInstance = DB.instance;

  Future<Database> get _database async => await _dbInstance.database;

  @override
  Future<int> addAppointment(Appointment appointment) async {
    try {
      final db = await _database;
      final id = await db.insert(
        'appointments',
        appointment.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      notifyListeners(); // 🛎️🔔✨
      return id; // 🎉 Retornando o id do compromisso inserido
    } catch (e) {
      throw Exception('Erro ao adicionar compromisso 😵👉 $e');
    }
  }

  @override
  Future<void> removeAppointment(int id) async {
    try {
      final db = await _database;
      await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
      notifyListeners(); // 💣💥🧨
    } catch (e) {
      throw Exception('Erro ao remover compromisso ❌📆👉 $e');
    }
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    try {
      final db = await _database;
      await db.update(
        'appointments',
        appointment.toJson(),
        where: 'id = ?',
        whereArgs: [appointment.id],
      );
      notifyListeners(); // 🔁📣🛠️
    } catch (e) {
      throw Exception('Erro ao atualizar compromisso 🔄💥👉 $e');
    }
  }

  Future<Appointment?> getAppointmentById(int id) async {
    try {
      final db = await _database;
      final maps = await db.query(
        'appointments',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Appointment.fromJson(maps.first); // 🕵️‍♂️📋✅
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao buscar compromisso por ID 🔍📆👉 $e');
    }
  }

  @override
  Future<List<Appointment>> getAll() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query('appointments');

      return maps.map((map) => Appointment.fromJson(map)).toList(); // 📚✨✅
    } catch (e) {
      throw Exception('Erro ao listar compromissos 📃🔥👉 $e');
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsById(int id) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'appointments',
        where: 'appointment_creator_id = ?',
        whereArgs: [id],
      );

      return List.generate(maps.length, (i) {
        return Appointment.fromJson(maps[i]);
      });
    } catch (e) {
      throw Exception('Erro ao listar compromissos 📃🔥👉 $e');
    }
  }

  @override
  // TODO: implement appointments
  List<Appointment> get appointments => throw UnimplementedError();
}
