import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/invitation.dart';


abstract class InvitationRepository extends ChangeNotifier {
  Future<List<Invitation>> getInvitationsByGuestId(int guestId);
  
  Future<void> acceptInvitation(int invitationId);
  Future<void> declineInvitation(int invitationId);
  Future<void> addInvitation(Invitation invitation); 
  Future<void> removeInvitationsByAppointmentId(int id);
}
