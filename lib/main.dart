import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/app.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/location_repository.dart';
import 'package:flutter_agenda_app/repositories/location_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/repositories/user_repository_sqlite.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepository>(
          create: (context) => UserRepositorySqlite(),
        ),
        ChangeNotifierProvider<AppointmentsRepositoryMemory>(
          create: (context) => AppointmentsRepositoryMemory(),
        ),
        ChangeNotifierProvider<InvitationRepositoryMemory>(
          create: (context) => InvitationRepositoryMemory(),
        ),
        ChangeNotifierProvider<LocationRepository>(
          create: (context) => LocationRepositorySqlite(),
        ),
      ],
      child: App(),
    ),
  );
}
