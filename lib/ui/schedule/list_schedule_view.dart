import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/models/location.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/location_repository.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
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
  @override
  Widget build(BuildContext context) {
    final locationRepository = context.watch<LocationRepository>();
    final userRepository = context.watch<UserRepository>();
    final appointmentsRepository =
        context.watch<AppointmentsRepositorySqlite>();

    final int? loggedUserId = userRepository.loggedUser?.id;

    if (loggedUserId == null) {
      return const Center(
        child: Text(
          'Usuário não encontrado.',
          style: TextStyle(fontSize: 18, color: AppColors.primary),
        ),
      );
    }

    Future<List<Location>> fetchLocations() async {
      return await locationRepository.getAll(userId: loggedUserId);
    }

    Future<List<Appointment>> fetchAppointments() async {
      return await appointmentsRepository.getAppointmentsById(loggedUserId);
    }

    Future<void> _refresh() async {
      setState(() {});
    }

    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([fetchAppointments(), fetchLocations()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Erro ao carregar dados: ${snapshot.error.toString().replaceFirst("Exception: ", "")}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final appointments = snapshot.data?[0] as List<Appointment>;
          final locations = snapshot.data?[1] as List<Location>;

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
                final location = locations.firstWhere(
                  (loc) => loc.id == appointment.locationId,
                );

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
                      final result = await Navigator.pushNamed(
                        context,
                        '/new-appointment',
                        arguments: {'appointment': appointment},
                      );

                      // Se retornou algo, recarrega a lista!
                      if (result == true) {
                        await _refresh(); // 🍻 Recarrega!
                      }

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
                                  onPressed:
                                      () => Navigator.pop(context, false),
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

                        // 👇 SALVA ANTES do context ser potencialmente destruído
                        final appointmentsRepo =
                            Provider.of<AppointmentsRepositorySqlite>(
                              context,
                              listen: false,
                            );
                        final invitationsRepo =
                            Provider.of<InvitationRepositorySqlite>(
                              context,
                              listen: false,
                            );

                        final oldAppointment = appointment;
                        final oldInvitations =
                            await Provider.of<InvitationRepositorySqlite>(
                              context,
                              listen: false,
                            ).getInvitationsByAppointmentAndOrganizer(
                              appointment.id!,
                              appointment.appointmentCreatorId!,
                            );

                        await Provider.of<AppointmentsRepositorySqlite>(
                          context,
                          listen: false,
                        ).removeAppointment(appointment.id!);

                        await Provider.of<InvitationRepositorySqlite>(
                          context,
                          listen: false,
                        ).removeInvitationsByAppointmentId(appointment.id!);

                        await _refresh();

                        messenger.showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Compromisso excluído com sucesso ✅🗑️',
                            ),
                            action: SnackBarAction(
                              label: 'Desfazer 🪄',
                              onPressed: () async {
                                await appointmentsRepo.addAppointment(
                                  oldAppointment,
                                );

                                for (var inv in oldInvitations) {
                                  await invitationsRepo.addInvitation(inv);
                                }

                                await _refresh(); // 🎯 ainda pode usar isso aqui normalmente
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
                        Text('Local: ${location.address}, ${location.number}'),
                        Text(
                          'Início: ${formatDateTime(appointment.startHourDate)}',
                        ),
                        Text('Fim: ${formatDateTime(appointment.endHourDate)}'),
                      ],
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/new-appointment',
                        arguments: {
                          'readonly': true,
                          'appointment': appointment,
                        },
                      );

                      if (result == true) {
                        await _refresh();
                      }
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
