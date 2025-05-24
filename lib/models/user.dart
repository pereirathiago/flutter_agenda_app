class User {
  final int? id;
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      fullName: json['fullname'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      birthDate:
          json['birthdate'] != null
              ? DateTime.tryParse(json['birthdate'] as String)
              : null,
      gender: json['gender'] as String?,
      profilePicture: json['profile_picture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password,
      'birthdate': birthDate?.toIso8601String(),
      'gender': gender,
      'profile_picture': profilePicture,
    };
  }
}
