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
  List<User> get users => UnmodifiableListView(_users);

  @override
  void register(User user) {
    if (_users.any(
      (u) => u.email == user.email || u.username == user.username,
    )) {
      throw Exception(
        'Usuário já cadastrado com esse e-mail ou nome de usuário.',
      );
    }

    final newUser = User(
      id: Random().nextInt(10000).toString(),
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
  bool login(String email, String password) {
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
  void logout() {
    _loggedUser = null;
    notifyListeners();
  }

  @override
  void editProfile(User updatedUser) {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index == -1) return;

    _users[index] = updatedUser;

    if (_loggedUser?.id == updatedUser.id) {
      _loggedUser = updatedUser;
    }

    notifyListeners();
  }

  @override
  User? getProfile(String userId) {
    return _users.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('Usuário não encontrado.'),
    );
  }

  @override
  User? getUserByEmail(String email) {
    return _users.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Usuário não encontrado.'),
    );
  }

  @override
  User? getUserByUsername(String username) {
    try {
      return _users.firstWhere((u) => u.username == username);
    } catch (e) {
      return null;
    }
  }
}
