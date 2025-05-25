import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_sqlite.dart';
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
    return regex.hasMatch(input) ? '0$input' : input;
  }

  return '${dateTime.day}/${formatTwoDigits(dateTime.month.toString())}/${dateTime.year} '
      '${formatTwoDigits(dateTime.hour.toString())}:${formatTwoDigits(dateTime.minute.toString())}';
}

class _ListScheduleViewState extends State<ListScheduleView> {
  late Future<List<Appointment>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _fetchAppointments();
  }

  Future<List<Appointment>> _fetchAppointments() async {
    final repo = Provider.of<AppointmentsRepositorySqlite>(context, listen: false);
    return await repo.getAll(); // 💾📋✅
  }

  Future<void> _refresh() async {
    setState(() {
      _appointmentsFuture = _fetchAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Appointment>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Erro ao carregar compromissos 😢📛'));
          }

          final appointments = snapshot.data ?? [];

          if (appointments.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum compromisso 🫥📭',
                style: TextStyle(fontSize: 18, color: AppColors.primary),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              itemBuilder: (context, index) {
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
                        builder: (context) => AlertDialog(
                          title: const Text('Excluir'),
                          content: const Text('Deseja realmente excluir este compromisso?'),
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

                        final oldAppointment = appointment;
                        final oldInvitations = List.from(
                          Provider.of<InvitationRepositoryMemory>(
                            context,
                            listen: false,
                          ).invitations.where((inv) => inv.appointmentId == appointment.id),
                        );

                        await Provider.of<AppointmentsRepositorySqlite>(
                          context,
                          listen: false,
                        ).removeAppointment(appointment.id!);

                        Provider.of<InvitationRepositoryMemory>(
                          context,
                          listen: false,
                        ).removeInvitationsByAppointmentId(appointment.id!);

                        await _refresh();

                        messenger.showSnackBar(
                          SnackBar(
                            content: const Text('Compromisso excluído com sucesso ✅🗑️'),
                            action: SnackBarAction(
                              label: 'Desfazer 🪄',
                              onPressed: () async {
                                await Provider.of<AppointmentsRepositorySqlite>(
                                  context,
                                  listen: false,
                                ).addAppointment(oldAppointment);

                                for (var inv in oldInvitations) {
                                  Provider.of<InvitationRepository>(
                                    context,
                                    listen: false,
                                  ).addInvitation(inv);
                                }

                                await _refresh();
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
                        Text('Local: ${appointment.locationId}'),
                        Text('Início: ${formatDateTime(appointment.startHourDate)}'),
                        Text('Fim: ${formatDateTime(appointment.endHourDate)}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/new-appointment',
                        arguments: {
                          'appointment': appointment,
                          'readonly': true,
                        },
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
        },
      ),
    );
  }
}
