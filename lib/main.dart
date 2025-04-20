import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/app.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_memory.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppointmentsRepositoryMemory>(
      create: (context) => AppointmentsRepositoryMemory(),
      child: App(),
    ),
  );
}
