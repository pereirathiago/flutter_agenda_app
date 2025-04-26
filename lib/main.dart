import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/app.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/repositories/user_repository_memory.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepositoryMemory>(
          create: (context) => UserRepositoryMemory(),
        ),
        ChangeNotifierProvider<InvitationRepositoryMemory>(
          create: (_) => InvitationRepositoryMemory())             
      ],
      child: App(),
    ),
  );
}
