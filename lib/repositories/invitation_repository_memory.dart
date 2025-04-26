import 'dart:collection';
import 'dart:math';

import 'package:flutter_agenda_app/models/invitation.dart';
import 'package:flutter_agenda_app/repositories/invitation_repository.dart';

class InvitationRepositoryMemory extends InvitationRepository {
  final List<Invitation> _invitations = [];

  @override
  List<Invitation> get invitations => UnmodifiableListView(_invitations);

  @override
  void addInvitation({
    required String organizerUser,
    required String idGuestUser,
  }) {
    final newInvitation = Invitation(
      id: Random().nextInt(10000),
      organizerUser: organizerUser,
      idGuestUser: idGuestUser,
    );

    _invitations.add(newInvitation);
    notifyListeners();
  }

  @override
  List<Invitation> getInvitationsForUser(String userId) {
    return _invitations
        .where((inv) =>
            inv.idGuestUser == userId && inv.invitationStatus == 0)
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
