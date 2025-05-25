import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/appointment.dart';
import 'package:flutter_agenda_app/models/user.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_sqlite.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/repositories/user_repository_sqlite.dart';
import 'package:flutter_agenda_app/shared/app_colors.dart';
import 'package:provider/provider.dart';

class InvitationsScreenView extends StatelessWidget {
  const InvitationsScreenView({super.key});

  Color _getBackgroundColor(int status) {
    final statusColors = {
      1: Colors.green.shade100, // Aceito
      2: Colors.red.shade100, // Recusado
      0: Colors.white, // Pendente
    };

    return statusColors[status] ?? Colors.white;
  }

  String _getStatusText(int status) {
    final statusText = {1: 'Aceito', 2: 'Recusado', 0: 'Pendente'};

    return statusText[status] ?? 'Pendente';
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = context.watch<UserRepository>();
    final invitationRepo = context.watch<InvitationRepositorySqlite>();
    final appointmentRepo = context.watch<AppointmentsRepositorySqlite>();

    final loggedUser = userRepo.loggedUser;

    if (loggedUser == null) {
      return const Center(child: Text('Nenhum usuário logado.'));
    }

    return FutureBuilder(
      future: invitationRepo.getInvitationsByGuestId(loggedUser.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        final invitations = snapshot.data ?? [];

        if (invitations.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum convite encontrado.',
              style: TextStyle(fontSize: 18, color: AppColors.primary),
            ),
          );
        }

        return ListView.builder(
          itemCount: invitations.length,
          itemBuilder: (context, index) {
            final invitation = invitations[index];
            return FutureBuilder<Appointment?>(
              future: appointmentRepo.getAppointmentById(
                invitation.appointmentId!,
              ),
              builder: (context, appointmentSnapshot) {
                final appointment = appointmentSnapshot.data;

                return Card(
                  color: _getBackgroundColor(invitation.invitationStatus),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Organizador: ${invitation.idOrganizerUser}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Status: ${_getStatusText(invitation.invitationStatus)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Título: ${appointment != null ? appointment.title : 'N/A'}',
                        ),
                        Text(
                          'Local: ${appointment != null ? appointment.locationId : 'N/A'}',
                        ),
                        Text(
                          'Início: ${appointment != null ? appointment.startHourDate : 'N/A'}',
                        ),
                        Text(
                          'Fim: ${appointment != null ? appointment.endHourDate : 'N/A'}',
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () async {
                            if (invitation.id != null) {
                              await invitationRepo.acceptInvitation(
                                invitation.id!,
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () async {
                            if (invitation.id != null) {
                              await invitationRepo.declineInvitation(
                                invitation.id!,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
