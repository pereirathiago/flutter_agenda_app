import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';

class InvitationRepositoryMemory extends InvitationRepository {
  final List<Invitation> _invitations = [
    Invitation(
      id: 1,
      organizerUser: 'Organizador Teste',
      idGuestUser: '1',
      invitationStatus: 0,
    ),
  ];

  List<Invitation> get invitations => _invitations; // 🆕 Adicionado Getter

  @override
  void addInvitation(Invitation invitation) {
    _invitations.add(invitation);
    notifyListeners();
  }

  @override
  List<Invitation> getInvitationsByGuestId(String userId) {
    return _invitations
        .where((inv) => inv.idGuestUser == userId && inv.invitationStatus == 0)
        .toList();
  }

  @override
  void acceptInvitation(int invitationId) {
    final index = _invitations.indexWhere((i) => i.id == invitationId);
    if (index != -1) {
      _invitations[index].invitationStatus = 1;
      notifyListeners();
    }
  }

  @override
  void declineInvitation(int invitationId) {
    final index = _invitations.indexWhere((i) => i.id == invitationId);
    if (index != -1) {
      _invitations[index].invitationStatus = 2;
      notifyListeners();
    }
  }
}
