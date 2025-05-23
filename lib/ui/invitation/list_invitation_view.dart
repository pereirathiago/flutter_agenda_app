import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/repositories/appointments_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository_memory.dart';
import 'package:flutter_agenda_app/repositories/user_repository_memory.dart';
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
    final userRepo = context.watch<UserRepositoryMemory>();
    final invitationRepo = context.watch<InvitationRepositoryMemory>();

    final loggedUser = userRepo.loggedUser;

    if (loggedUser == null) {
      return const Center(child: Text('Nenhum usuário logado.'));
    }

    final invitations = invitationRepo.getInvitationsByGuestUsername(
      loggedUser.username,
    );

    return Scaffold(
      body:
          invitations.isEmpty
              ? const Center(
                child: Text(
                  'Nenhum convite encontrado.',
                  style: TextStyle(fontSize: 18, color: AppColors.primary),
                ),
              )
              : ListView.builder(
                itemCount: invitations.length,
                itemBuilder: (context, index) {
                  final invitation = invitations[index];

                  final appointmentRepo =
                      context.watch<AppointmentsRepositoryMemory>();
                  final appointment = appointmentRepo.getAppointmentsById(
                    invitation.appointmentId,
                  );

                  return Card(
                    color: _getBackgroundColor(invitation.invitationStatus),
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Organizador: ${invitation.organizerUser}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Status: ${_getStatusText(invitation.invitationStatus)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Título: ${appointment?.title}'),
                          Text('Local: ${appointment?.local}'),
                          Text('Início: ${appointment?.startHourDate}'),
                          Text('Fim: ${appointment?.endHourDate}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              invitationRepo.acceptInvitation(invitation.id);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              invitationRepo.declineInvitation(invitation.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
