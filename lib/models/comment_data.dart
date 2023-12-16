import 'user_data.dart';

class CommentData {
  final String comment;
  final UserData user;
  final DateTime createdAt;
  final List<String> likesList;
  final List<String> dislikesList;

  CommentData({
    required this.comment,
    required this.user,
    required this.createdAt,
    required this.likesList,
    required this.dislikesList,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      user: UserData.fromJson(json['user'] ?? {}), // Parse user data
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      likesList: List<String>.from(json['likesList']),
      dislikesList: List<String>.from(json['dislikesList']),
    );
  }
}
