import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';

class UserRepositoryMemory extends ChangeNotifier implements UserRepository {
  final List<User> _users = [];
  User? _loggedUser;

  @override
  User? get loggedUser => _loggedUser;

  @override
  Future<List<User>> get users async => UnmodifiableListView(_users);

  @override
  Future<void> register(User user) async {
    if (_users.any(
      (u) => u.email == user.email || u.username == user.username,
    )) {
      throw Exception(
        'Usuário já cadastrado com esse e-mail ou nome de usuário.',
      );
    }

    final newUser = User(
      id: Random().nextInt(10000),
      fullName: user.fullName,
      username: user.username,
      email: user.email,
      password: user.password,
      birthDate: user.birthDate,
      gender: user.gender,
      profilePicture: user.profilePicture,
    );

    _users.add(newUser);
    notifyListeners();
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );

      _loggedUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    _loggedUser = null;
    notifyListeners();
  }

  @override
  Future<void> editProfile(User updatedUser) async {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index == -1) return;

    _users[index] = updatedUser;

    if (_loggedUser?.id == updatedUser.id) {
      _loggedUser = updatedUser;
    }

    notifyListeners();
  }

  @override
  Future<User?> getProfile(int userId) async {
    return _users.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('Usuário não encontrado.'),
    );
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return _users.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Usuário não encontrado.'),
    );
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    try {
      return _users.firstWhere((u) => u.username == username);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfilePicture(int userId, String imagePath) {
    // TODO: implement updateProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<User?> loadUserFromFirebase(String userId) async {
    return null;
  }
}
