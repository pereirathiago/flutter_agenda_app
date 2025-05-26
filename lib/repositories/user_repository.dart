import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/user.dart';

abstract class UserRepository extends ChangeNotifier {
  User? get loggedUser;
  Future<List<User>> get users;

  Future<void> register(User user);
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<void> editProfile(User updatedUser);
  Future<void> updateProfilePicture(int userId, String imagePath);
  Future<User?> getProfile(int userId);
  Future<User?> getUserByEmail(String email);
  Future<User?> getUserByUsername(String username);
  Future<void> loadUserFromFirebase(String uid);
}
