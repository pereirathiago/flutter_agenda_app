class Invitation {
  final int id;
  final String organizerUser;
  final String idGuestUser;
  int invitationStatus; 
  int appointmentId;

  Invitation({
    required this.id,
    required this.organizerUser,
    required this.idGuestUser,
    this.invitationStatus = 0,
    required this.appointmentId
  });
}

