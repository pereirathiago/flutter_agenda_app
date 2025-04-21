import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/ui/login/login_register.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      // debugShowCheckedModeBanner: false,
      home: const LoginRegisterView(),
    );
  }
}
