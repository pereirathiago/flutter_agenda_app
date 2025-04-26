import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/invitation.dart';

abstract class InvitationRepository extends ChangeNotifier {
  List<Invitation> getInvitationsByGuestId(String guestId);
  
  void acceptInvitation(int invitationId);
  void declineInvitation(int invitationId);
  void addInvitation(Invitation invitation); 
}
