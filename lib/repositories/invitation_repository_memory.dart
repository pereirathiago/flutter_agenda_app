import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';

class InvitationRepositoryMemory extends InvitationRepository {
  final List<Invitation> _invitations = [
    Invitation(
      id: 1,
      idOrganizerUser: 1,
      idGuestUser: 1,
      invitationStatus: 0,
      appointmentId: 1, 
    ),
  ];

  List<Invitation> get invitations => _invitations;

  @override
  Future<void> addInvitation(Invitation invitation) async {
    _invitations.add(invitation);
    notifyListeners();
  }

  @override
  Future<List<Invitation>> getInvitationsByGuestId(int userId) async {
    return _invitations
        .where((inv) => inv.idGuestUser == userId && inv.invitationStatus == 0)
        .toList();
  }

  Future<List<Invitation>> getInvitationsByGuestUsername(int userId) async {
    return _invitations
        .where((inv) => inv.idGuestUser == userId)
        .toList();
  }

  @override
  Future<void> acceptInvitation(int invitationId) async {
    final index = _invitations.indexWhere((i) => i.id == invitationId);
    if (index != -1) {
      _invitations[index].invitationStatus = 1;
      notifyListeners();
    }
  }

  @override
  Future<void> declineInvitation(int invitationId) async {
    final index = _invitations.indexWhere((i) => i.id == invitationId);
    if (index != -1) {
      _invitations[index].invitationStatus = 2;
      notifyListeners();
    }
  }

  @override
  Future<void> removeInvitationsByAppointmentId(int id) async {
    _invitations.removeWhere((invitation) => invitation.appointmentId == id);
    notifyListeners();
  }
  
  @override
  Future<void> removeInvitation(int id) {
    // TODO: implement removeInvitation
    throw UnimplementedError();
  }
}
