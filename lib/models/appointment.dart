class Appointment {
  final int id;
  final String title;
  final String description;
  final bool status;
  final DateTime startHourDate;
  final DateTime endHourDate;
  final int appointmentCreatorId;
  final int localId;


  Appointment({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startHourDate,
    required this.endHourDate,
    required this.appointmentCreatorId,
    required this.localId,
  });
}
