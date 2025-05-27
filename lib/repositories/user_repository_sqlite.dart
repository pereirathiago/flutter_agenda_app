import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/database/db.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/services/auth_service.dart';
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
    final authService = AuthService();

    try {
      if (user.password == null || user.password!.isEmpty) {
        throw Exception('Senha não pode ser nula ou vazia.');
      }

      await authService.registrarEmailSenha(user.email, user.password!);

      final firebaseUser = authService.usuario;
      if (firebaseUser == null) {
        throw Exception('Falha ao registrar no Firebase');
      }

      user = user.copyWith(firebaseUid: firebaseUser.uid);

      final id = await db.insert(
        'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      if (id == 0) {
        await firebaseUser.delete();
        throw Exception('Erro ao cadastrar usuário.');
      }

      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Erro ao registrar no Firebase');
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception(
          'Usuário já cadastrado com esse e-mail ou nome de usuário.',
        );
      }

      authService.usuario != null ? await authService.usuario!.delete() : null;
      throw Exception('Erro ao cadastrar usuário no banco');
    } catch (e) {
      throw Exception('Erro ao cadastrar usuário');
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final authService = AuthService();
      await authService.loginEmailSenha(email, password);

      final firebaseUser = authService.usuario;
      if (firebaseUser == null) return false;

      final db = await _database;

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isNotEmpty) {
        _loggedUser = User.fromJson(maps.first);
        notifyListeners();
        return true;
      }

      return false;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Erro ao fazer login');
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final authService = AuthService();
      await authService.logout();

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
      if (_loggedUser?.firebaseUid != null) {
        final authService = AuthService();

        if (updatedUser.email != _loggedUser?.email) {
          await authService.updateEmail(
            updatedUser.email,
            _loggedUser!.password!,
          );
        }

        if (updatedUser.password != _loggedUser?.password) {
          await authService.updatePassword(
            updatedUser.password!,
            _loggedUser!.password!,
          );
        }
      }

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
  Future<void> updateProfilePicture(int userId, String imagePath) async {
    final db = await _database;

    try {
      await db.update(
        'users',
        {'profile_picture': imagePath},
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (_loggedUser?.id == userId) {
        _loggedUser = _loggedUser?.copyWith(profilePicture: imagePath);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Erro ao atualizar imagem de perfil: ${e.toString()}');
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
