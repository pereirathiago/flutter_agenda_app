import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/invitation.dart';

abstract class InvitationRepository extends ChangeNotifier {
  List<Invitation> get invitations;

  void addInvitation({
    required String organizerUser,
    required String idGuestUser,
  });

  List<Invitation> getInvitationsForUser(String userId);
  void acceptInvitation(int invitationId);
  void declineInvitation(int invitationId);
}
