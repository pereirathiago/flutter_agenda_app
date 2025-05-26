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

  updateEmail(String newEmail, String currentPassword) async {
    try {
      _getUser();
      if (usuario == null) throw AuthException('Usuário não autenticado');

      final credential = EmailAuthProvider.credential(
        email: usuario!.email!,
        password: currentPassword,
      );
      await usuario!.reauthenticateWithCredential(credential);

      await usuario!.verifyBeforeUpdateEmail(newEmail);
      await usuario!.reload();
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw AuthException(
          'Por segurança, faça login novamente antes de alterar o email',
        );
      }
      throw AuthException('Erro ao atualizar email: ${e.message}');
    }
  }

  updatePassword(String newPassword, String currentPassword) async {
    try {
      _getUser();
      if (usuario == null) throw AuthException('Usuário não autenticado');
      final credential = EmailAuthProvider.credential(
        email: usuario!.email!,
        password: currentPassword,
      );
      await usuario!.reauthenticateWithCredential(credential);

      await usuario!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw AuthException(
          'Por segurança, faça login novamente antes de alterar a senha',
        );
      }
      throw AuthException('Erro ao atualizar senha: ${e.message}');
    }
  }

  reauthenticate(String email, String password) async {
    try {
      if (usuario == null) throw AuthException('Usuário não autenticado');

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await usuario!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException('Autenticação falhou: ${e.message}');
    }
  }
}
