class Invitation {
  final int? id;
  final int? idOrganizerUser;
  final int? idGuestUser;
  int invitationStatus;
   int? appointmentId;

  Invitation({
    this.id,
    required this.idOrganizerUser,
    required this.idGuestUser,
    this.invitationStatus = 0,
    required this.appointmentId,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['id'] as int?,
      idOrganizerUser: json['organizer_user_id'] as int?,
      idGuestUser: json['guest_user_id'] as int?,
      invitationStatus: json['invitation_status'] ?? 0,
      appointmentId: json['appointment_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizer_user_id': idOrganizerUser,
      'guest_user_id': idGuestUser,
      'invitation_status': invitationStatus,
      'appointment_id': appointmentId,
    };
  }
}


