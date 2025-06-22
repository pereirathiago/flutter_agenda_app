class Comment {
  final String id;
  final String appointmentId;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.appointmentId,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      appointmentId: json['appointmentId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatarUrl: json['userAvatarUrl'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}