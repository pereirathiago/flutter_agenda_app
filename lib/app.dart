import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/ui/schedule/schedule_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ScheduleView(),
    );
  }
}
