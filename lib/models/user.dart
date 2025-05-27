class User {
  final int? id;
  String? firebaseUid;
  final String fullName;
  final String username;
  final String email;
  final String? password;
  final DateTime? birthDate;
  final String? gender;
  final String? profilePicture;

  User({
    this.id,
    this.firebaseUid,
    required this.fullName,
    required this.username,
    required this.email,
    this.password,
    this.birthDate,
    this.gender,
    this.profilePicture,
  });

  User copyWith({
    int? id,
    String? firebaseUid,
    String? fullName,
    String? username,
    String? email,
    String? password,
    DateTime? birthDate,
    String? gender,
    String? profilePicture,
  }) {
    return User(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firebaseUid: json['firebase_uid'] as String?,
      fullName: json['fullname'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
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
      'firebase_uid': firebaseUid,
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
