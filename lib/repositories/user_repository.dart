import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/user.dart';

abstract class UserRepository extends ChangeNotifier {
  User? get loggedUser;
  List<User> get users;

  void register(User user);
  bool login(String email, String password);
  void logout();
  void editProfile(User updatedUser);
  User? getProfile(String userId);
  User? getUserByEmail(String email);
  User? getUserByUsername(String username);
}
