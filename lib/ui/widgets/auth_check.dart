import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    UserRepository userRepository = Provider.of<UserRepository>(
      context,
      listen: false,
    );

    if (auth.isLoading) {
      return loading();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentRouteName = ModalRoute.of(context)?.settings.name;

        if (auth.usuario == null) {
          if (currentRouteName != '/login-register') {
            Navigator.of(context).pushReplacementNamed('/login-register');
          }
        } else {
          userRepository.loadUserFromFirebase(auth.usuario?.uid ?? '').then((
            _,
          ) {
            if (userRepository.loggedUser != null &&
                currentRouteName != '/schedule' &&
                context.mounted) {
              Navigator.of(context).pushReplacementNamed('/schedule');
            }
          });
        }
      });

      return loading();
    }
  }

  loading() {
    return Scaffold(body: const Center(child: CircularProgressIndicator()));
  }
}
