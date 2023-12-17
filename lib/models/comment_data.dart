import 'user_data.dart';

class CommentData {
  final String body;
  final UserData user;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> dislikes;

  CommentData({
    required this.body,
    required this.user,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      user: UserData.fromJson(json['user'] ?? {}), // Parse user data
      body: json['body'],
      createdAt: DateTime.parse(json['createdAt']),
      likes: List<String>.from(json['likes']),
      dislikes: List<String>.from(json['dislikes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'user': user.toJson(), // Convert user data to JSON
      'createdAt': createdAt.toUtc(),
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}
