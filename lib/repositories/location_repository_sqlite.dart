import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/database/db.dart';
import 'package:flutter_agenda_app/models/location.dart';
import 'package:flutter_agenda_app/repositories/location_repository.dart';
import 'package:sqflite/sqflite.dart';

class LocationRepositorySqlite extends ChangeNotifier
    implements LocationRepository {
  final DB _dbInstance = DB.instance;
  Future<Database> get _database async => await _dbInstance.database;

  @override
  Future<void> add(Location location) async {
    final db = await _database;

    Map<String, dynamic> locationMap = location.toJson();

    try {
      final id = await db.insert(
        'locations',
        locationMap,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      if (id <= 0) {
        throw Exception('Erro ao adicionar local ao banco de dados.');
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao salvar local: ${e.toString()}');
    }
  }

  @override
  Future<List<Location>> getAll({required int userId, String? filter}) async {
    try {
      final db = await _database;
      List<Map<String, dynamic>> maps;
      String whereClause = 'user_id = ?';
      List<dynamic> whereArgs = [userId];

      if (filter != null && filter.isNotEmpty) {
        whereClause += ' AND address LIKE ?';
        whereArgs.add('%$filter%');
      }

      maps = await db.query(
        'locations',
        where: whereClause,
        whereArgs: whereArgs,
      );

      return List.generate(maps.length, (i) {
        return Location.fromJson(maps[i]);
      });
    } catch (e) {
      throw Exception(
        'Erro ao buscar locais: ${e.toString().replaceFirst("Exception: ", "")}',
      );
    }
  }

  @override
  Future<Location> getById(int id) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'locations',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Location.fromJson(maps.first);
      }

      throw Exception('Local não encontrado.');
    } catch (e) {
      throw Exception('Erro ao buscar local por ID: ${e.toString()}');
    }
  }

  @override
  Future<void> remove(int id) async {
    try {
      final db = await _database;
      int count = await db.delete(
        'locations',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw Exception('Erro ao remover, local não encontrado.');
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao remover local: ${e.toString()}');
    }
  }

  @override
  Future<void> update(Location location) async {
    final db = await _database;
    if (location.id == null) {
      throw Exception('Local não pode ser nulo para atualização.');
    }
    Map<String, dynamic> locationMap = location.toJson();

    try {
      int count = await db.update(
        'locations',
        locationMap,
        where: 'id = ?',
        whereArgs: [location.id],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      if (count == 0) {
        throw Exception('Nenhuma alteração aplicada ao local.');
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao atualizar local: ${e.toString()}');
    }
  }
}
