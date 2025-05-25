import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user != null) ? user : null;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  registrarEmailSenha(String email, String senha) async {
    isLoading = true;
    notifyListeners();

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      await _auth.signOut();

      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw AuthException('Erro desconhecido ao cadastrar usuário');
    }
  }

  loginEmailSenha(String email, String senha) async {
    isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      isLoading = false;
      _getUser();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'user-not-found') {
        throw AuthException('Usuário não encontrado');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }
}
