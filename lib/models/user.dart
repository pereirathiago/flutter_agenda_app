class User {
  final String? id;
  final String fullName;
  final String username;
  final String email;
  final String password;
  final DateTime? birthDate;
  final String? gender;
  final String? profilePicture;

  User({
    this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    this.birthDate,
    this.gender,
    this.profilePicture,
  });
}
