import 'package:gucy/models/comment_data.dart';
import 'package:gucy/models/user_data.dart';

class PostData {
  final UserData user;
  final DateTime createdAt;
  final String title;
  final String body;
  final List<String> tags;
  final List<String> likes;
  final List<String> dislikes;
  final int score;
  final String type;
  final String picture;
  final List<CommentData> comments;

  const PostData({
    required this.user,
    required this.createdAt,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.score,
    required this.type,
    required this.picture,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      user: UserData.fromJson(json['user'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      title: json['title'],
      body: json['body'],
      tags: List<String>.from(json['tags']),
      likes: List<String>.from(json['likes']),
      dislikes: List<String>.from(json['dislikesList']),
      score: json['score'],
      type: json['type'],
      picture: json['picture'],
      comments: List<CommentData>.from(
        (json['comments'] as List).map(
          (commentJson) => CommentData.fromJson(commentJson),
        ),
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'createdAt': createdAt.toUtc(),
      'title': title,
      'body': body,
      'tags': tags,
      'likes': likes,
      'dislikes': dislikes,
      'score': score,
      'type': type,
      'picture': picture,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
