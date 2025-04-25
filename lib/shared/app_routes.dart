import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/ui/login_register/login.dart';
import 'package:flutter_agenda_app/ui/login_register/login_register.dart';
import 'package:flutter_agenda_app/ui/login_register/register.dart';
import 'package:flutter_agenda_app/ui/schedule/schedule_view.dart';
import 'package:flutter_agenda_app/ui/user_profile/edit_profile_view.dart';
import 'package:flutter_agenda_app/ui/user_profile/user_profile_view.dart';
import 'package:flutter_agenda_app/ui/appointments/new_appointment.dart';

var appRoutes = <String, WidgetBuilder>{
  '/': (context) => const LoginRegisterView(),
  '/login': (context) => LoginView(),
  '/register': (context) => RegisterView(),
  '/schedule': (context) => const ScheduleView(),
  '/profile': (context) => const UserProfileView(),
  '/edit_profile': (context) => EditProfileView(),
};
