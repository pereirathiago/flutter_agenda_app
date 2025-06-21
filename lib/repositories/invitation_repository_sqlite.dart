import 'package:flutter_agenda_app/database/db.dart';
import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';
import 'package:sqflite/sqflite.dart';

class InvitationRepositorySqlite extends InvitationRepository {
  final DB _dbInstance = DB.instance;

  Future<Database> get _database async => await _dbInstance.database;

  @override
  Future<List<Invitation>> getInvitationsByAppointmentAndOrganizer(
    int appointmentId,
    int organizerUserId,
  ) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'invitations',
      where: 'appointment_id = ? AND organizer_user_id = ?',
      whereArgs: [appointmentId, organizerUserId],
    );

    return maps.map((map) => Invitation.fromJson(map)).toList();
  }

  @override
  Future<void> updateInvitation(Invitation invitation) async {
    final db = await _database;
    await db.update(
      'invitations',
      invitation.toJson(),
      where: 'id = ?',
      whereArgs: [invitation.id],
    );
  }

  @override
  Future<List<Invitation>> getInvitationsByGuestId(int guestId) async {
    try{
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'invitations',
      where: 'guest_user_id = ? ',
      whereArgs: [guestId],
    );

    return List.generate(maps.length, (i) {
      return Invitation.fromJson(maps[i]);
    });
    }catch (e) {
      throw Exception('Erro ao buscar convites: ${e.toString()}');
    }
  }

  @override
  Future<void> addInvitation(Invitation invitation) async {
    final db = await _database;
    await db.insert(
      'invitations',
      invitation.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  @override
  Future<void> acceptInvitation(int invitationId) async {
    final db = await _database;
    await db.update(
      'invitations',
      {'invitation_status': 1},
      where: 'id = ?',
      whereArgs: [invitationId],
    );
    notifyListeners();
  }

  @override
  Future<void> declineInvitation(int invitationId) async {
    final db = await _database;
    await db.update(
      'invitations',
      {'invitation_status': 2},
      where: 'id = ?',
      whereArgs: [invitationId],
    );
    notifyListeners();
  }

  @override
  Future<void> removeInvitationsByAppointmentId(int id) async {
    final db = await _database;
    await db.delete('invitations', where: 'appointment_id = ?', whereArgs: [id]);
    notifyListeners();
  }

  @override
  Future<void> removeInvitation(int id) async {
    final db = await _database;
    await db.delete('invitations', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
  }
}
