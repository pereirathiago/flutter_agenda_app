import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/ui/invitation/list_invitation_view.dart';
import 'package:flutter_agenda_app/ui/location/location_list_view.dart';
import 'package:flutter_agenda_app/ui/location/location_new_view.dart';
import 'package:flutter_agenda_app/ui/login_register/login.dart';
import 'package:flutter_agenda_app/ui/login_register/login_register.dart';
import 'package:flutter_agenda_app/ui/login_register/register.dart';
import 'package:flutter_agenda_app/ui/schedule/schedule_view.dart';
import 'package:flutter_agenda_app/ui/user_profile/edit_profile_view.dart';
import 'package:flutter_agenda_app/ui/user_profile/user_profile_view.dart';
import 'package:flutter_agenda_app/ui/appointments/new_appointment.dart';
import 'package:flutter_agenda_app/ui/widgets/auth_check.dart';

var appRoutes = <String, WidgetBuilder>{
  '/': (context) => const AuthCheck(),
  '/login-register': (context) => const LoginRegisterView(),
  '/login': (context) => LoginView(),
  '/register': (context) => RegisterView(),
  '/schedule': (context) => const ScheduleView(),
  '/profile': (context) => const UserProfileView(),
  '/edit_profile': (context) => EditProfileView(),
  '/new-appointment': (context) => NewAppointmentView(),
  '/list-invitation': (context) => InvitationsScreenView(),
  '/location': (context) => const LocationListView(),
  '/new-location': (context) => const LocationNewView(),
};

var baseUrlApi = 'https://68571fc921f5d3463e54822b.mockapi.io/';
