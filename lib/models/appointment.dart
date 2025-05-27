class Appointment {
  final int? id;
  final String title;
  final String description;
  final bool status;
  final DateTime startHourDate;
  final DateTime endHourDate;
  final int? appointmentCreatorId;
  final int? locationId;

  Appointment({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startHourDate,
    required this.endHourDate,
    required this.appointmentCreatorId,
    required this.locationId,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'] == 1,
      startHourDate: DateTime.parse(json['start_hour_date']),
      endHourDate: DateTime.parse(json['end_hour_date']),
      locationId: json['location_id'],
      appointmentCreatorId: json['appointment_creator_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status ? 1 : 0,
      'start_hour_date': startHourDate.toIso8601String(),
      'end_hour_date': endHourDate.toIso8601String(),
      'location_id': locationId,
      'appointment_creator_id': appointmentCreatorId,
    };
  }
}
