import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/shared/app_routes.dart';
import 'package:flutter_agenda_app/shared/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      title: 'Agenda',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
