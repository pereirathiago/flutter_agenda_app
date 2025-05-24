import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/database/db.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:sqflite/sqflite.dart';

class UserRepositorySqlite extends ChangeNotifier implements UserRepository {
  final DB _dbInstance = DB.instance;
  User? _loggedUser;

  Future<Database> get _database async => await _dbInstance.database;

  @override
  User? get loggedUser => _loggedUser;

  @override
  Future<List<User>> get users async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query('users');

      return List.generate(maps.length, (i) {
        return User.fromJson(maps[i]);
      });
    } catch (e) {
      throw Exception('Erro ao buscar usuários: ${e.toString()}');
    }
  }

  @override
  Future<void> register(User user) async {
    final db = await _database;

    Map<String, dynamic> userMap = user.toJson();

    try {
      final id = await db.insert(
        'users',
        userMap,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      if (id == 0) {
        throw Exception('Erro ao cadastrar usuário.');
      }

      notifyListeners();
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        throw Exception(
          'Usuário já cadastrado com esse e-mail ou nome de usuário.',
        );
      }
      throw Exception('Erro ao cadastrar usuário: ${e.toString()}');
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final db = await _database;

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (maps.isNotEmpty) {
        _loggedUser = User.fromJson(maps.first);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      _loggedUser = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao fazer logout: ${e.toString()}');
    }
  }

  @override
  Future<void> editProfile(User updatedUser) async {
    final db = await _database;

    Map<String, dynamic> userMap = updatedUser.toJson();

    try {
      int count = await db.update(
        'users',
        userMap,
        where: 'id = ?',
        whereArgs: [updatedUser.id],
      );

      if (count == 0) {
        throw Exception('Usuário não encontrado.');
      }

      if (_loggedUser?.id == updatedUser.id) {
        _loggedUser = updatedUser;
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  @override
  Future<User?> getProfile(int userId) async {
    try {
      final db = await _database;

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (maps.isNotEmpty) {
        return User.fromJson(maps.first);
      }

      throw Exception('Usuário não encontrado.');
    } catch (e) {
      throw Exception('Erro ao buscar perfil: ${e.toString()}');
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await _database;

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isNotEmpty) {
        return User.fromJson(maps.first);
      } else {
        throw Exception('Usuário não encontrado.');
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuário por email: ${e.toString()}');
    }
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    try {
      final db = await _database;

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (maps.isNotEmpty) {
        return User.fromJson(maps.first);
      } else {
        throw Exception('Usuário não encontrado.');
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuário: ${e.toString()}');
    }
  }
}
