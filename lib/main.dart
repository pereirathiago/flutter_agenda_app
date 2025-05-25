import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/app.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/location_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/user_repository_sqlite.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepositorySqlite>(
          create: (context) => UserRepositorySqlite(),
        ),
        ChangeNotifierProvider<AppointmentsRepositorySqlite>(
          create: (context) => AppointmentsRepositorySqlite(),
        ),
        ChangeNotifierProvider<InvitationRepositorySqlite>(
          create: (context) => InvitationRepositorySqlite(),
        ),
        ChangeNotifierProvider<LocationRepositoryMemory>(
          create: (context) => LocationRepositoryMemory(),
        ),
      ],
      child: App(),
    ),
  );
}
