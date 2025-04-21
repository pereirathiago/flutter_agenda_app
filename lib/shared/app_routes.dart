import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/ui/login_register/login.dart';
import 'package:flutter_agenda_app/ui/login_register/login_register.dart';
import 'package:flutter_agenda_app/ui/login_register/register.dart';

var appRoutes = <String, WidgetBuilder>{
  '/': (context) => const LoginRegisterView(),
  '/login': (context) => LoginView(),
  '/register': (context) => RegisterView(),
};
