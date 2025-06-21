import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/app.dart';
import 'package:flutter_agenda_app/firebase_options.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/location_repository.dart';
import 'package:flutter_agenda_app/repositories/location_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/repositories/user_repository_sqlite.dart';
import 'package:flutter_agenda_app/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider<UserRepository>(
          create: (context) => UserRepositorySqlite(),
        ),
        ChangeNotifierProvider<AppointmentsRepository>(
          create: (context) => AppointmentsRepositorySqlite(),
        ),
        ChangeNotifierProvider<InvitationRepository>(
          create: (context) => InvitationRepositorySqlite(),
        ),
        ChangeNotifierProvider<LocationRepository>(
          create: (context) => LocationRepositorySqlite(),
        ),
      ],
      child: App(),
    ),
  );
}
