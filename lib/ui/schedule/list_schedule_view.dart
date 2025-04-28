import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_memory.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:provider/provider.dart';

class ListScheduleView extends StatefulWidget {
  const ListScheduleView({super.key});

  @override
  State<ListScheduleView> createState() => _ListScheduleViewState();
}

String formatDateTime(DateTime dateTime) {
  String formatTwoDigits(String input) {
    final regex = RegExp(r'^\d$');

    if (regex.hasMatch(input)) {
      return '0$input';
    }
    return input;
  }

  return '${dateTime.day}/${formatTwoDigits(dateTime.month.toString())}/${dateTime.year} ${formatTwoDigits(dateTime.hour.toString())}:${formatTwoDigits(dateTime.minute.toString())}';
}

class _ListScheduleViewState extends State<ListScheduleView> {
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
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                Navigator.pushNamed(
                  context,
                  '/new-appointment',
                  arguments: {'appointment': appointment},
                );
                return false;
              } else if (direction == DismissDirection.endToStart) {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Excluir'),
                        content: const Text(
                          'Deseja realmente excluir este compromisso?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                );

                if (confirm == true) {
                  final messenger = ScaffoldMessenger.of(context);

                  // Salva os dados para possível desfazer
                  final oldAppointment = appointment;
                  final oldInvitations = List.from(
                    Provider.of<InvitationRepositoryMemory>(
                      context,
                      listen: false,
                    ).invitations.where(
                      (inv) => inv.appointmentId == appointment.id,
                    ),
                  );

                  // Remove compromisso e convites associados
                  Provider.of<AppointmentsRepositoryMemory>(
                    context,
                    listen: false,
                  ).removeAppointment(appointment.id!);
                  Provider.of<InvitationRepositoryMemory>(
                    context,
                    listen: false,
                  ).removeInvitationsByAppointmentId(appointment.id!);

                  // Atualiza a tela
                  setState(() {});

                  // Mostra a snackbar com ação de desfazer
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('Compromisso excluído com sucesso!'),
                      action: SnackBarAction(
                        label: 'Desfazer',
                        onPressed: () {
                          // Restaura compromisso e convites
                          Provider.of<AppointmentsRepositoryMemory>(
                            context,
                            listen: false,
                          ).addAppointment(oldAppointment);

                          for (var inv in oldInvitations) {
                            Provider.of<InvitationRepository>(
                              context,
                              listen: false,
                            ).addInvitation(inv);
                          }

                          setState(() {});
                        },
                      ),
                    ),
                  );

                  return true;
                }

                return false;
              }
              return false;
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
                  Text('Início: ${formatDateTime(appointment.startHourDate)}'),
                  Text('Fim: ${formatDateTime(appointment.endHourDate)}'),
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
