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

      throw Exception('Erro ao cadastrar usuário');
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
      throw Exception('Erro ao fazer login');
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
    if (updatedUser.id == null) {
      throw Exception('ID do usuário é inválido.');
    }

    Map<String, dynamic> userMap = updatedUser.toJson();

    try {
      int count = await db.update(
        'users',
        userMap,
        where: 'id = ?',
        whereArgs: [updatedUser.id],
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      if (count == 0) {
        throw Exception('Usuário não encontrado.');
      }

      if (_loggedUser?.id == updatedUser.id) {
        _loggedUser = updatedUser;
      }

      notifyListeners();
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception(
          'E-mail ou nome de usuário já está em uso por outra conta.',
        );
      } else {
        throw Exception(
          'Ocorreu um problema com o banco de dados ao atualizar o perfil.',
        );
      }
    } catch (e) {
      throw Exception('Ocorreu um erro inesperado.');
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

  @override
  Future<void> loadUserFromFirebase(String uid) async {
    try {
      final db = await _database;

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'firebase_uid = ?',
        whereArgs: [uid],
      );

      if (maps.isNotEmpty) {
        _loggedUser = User.fromJson(maps.first);
        notifyListeners();
      } else {
        throw Exception('Usuário não encontrado no Firebase.');
      }
    } catch (e) {
      throw Exception('Erro ao carregar usuário do Firebase: ${e.toString()}');
    }
  }
}
