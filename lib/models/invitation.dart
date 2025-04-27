class Invitation {
  final int id;
  final String organizerUser;
  final String idGuestUser;
  int invitationStatus; // 0 = pendente, 1 = aceito, 2 = recusado

  Invitation({
    required this.id,
    required this.organizerUser,
    required this.idGuestUser,
    this.invitationStatus = 0,
  });
}

