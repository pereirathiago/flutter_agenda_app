import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_memory.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:provider/provider.dart';

class ListScheduleView extends StatelessWidget {
  const ListScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentsRepository = Provider.of<AppointmentsRepositoryMemory>(
      context,
    );
    final appointments = appointmentsRepository.appointments;

    return Scaffold(
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final appointment = appointments[index];
          return Dismissible(
            key: Key(appointment.id.toString()),
            direction: DismissDirection.horizontal,
            background: Container(
              color: AppColors.alert,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: AppColors.delete,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                Navigator.pushNamed(
                  context,
                  '/new-appointment',
                  arguments: {'appointment': appointment},
                );
              } else if (direction == DismissDirection.endToStart) {}
            },
            child: ListTile(
              title: Text(
                appointment.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local: ${appointment.local}'),
                  Text('Início: ${appointment.startHourDate}'),
                  Text('Fim: ${appointment.endHourDate}'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/new-appointment',
                  arguments: {'appointment': appointment, 'readonly': true},
                );
              },
            ),
          );
        },
        padding: const EdgeInsets.all(10),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: appointments.length,
      ),
    );
  }
}
