import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/repositories/user_repository.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';

class InvitationsScreenView extends StatelessWidget {
  const InvitationsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    final invitationRepo = Provider.of<InvitationRepository>(context);

    final loggedUser = userRepo.loggedUser;

    if (loggedUser == null) {
      return const Center(child: Text('Nenhum usuário logado.'));
    }

    final invitations =
        invitationRepo.getInvitationsForUser(loggedUser.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convites Recebidos'),
      ),
      body: invitations.isEmpty
          ? const Center(child: Text('Nenhum convite pendente.'))
          : ListView.builder(
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                final invitation = invitations[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Organizador: ${invitation.organizerUser}'),
                    subtitle: Text('ID do convite: ${invitation.id}'),
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
