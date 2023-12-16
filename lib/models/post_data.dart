import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gucy/models/comment_data.dart';
import 'package:gucy/models/user_data.dart';

class PostData {
  final String id;
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
  List<CommentData> comments;

  PostData({
    required this.id,
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
      id: json['id'],
      user: UserData.fromJson(json['user'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      title: json['title'],
      body: json['body'],
      tags: List<String>.from(json['tags']),
      likes: List<String>.from(json['likes']),
      dislikes: List<String>.from(json['dislikes']),
      score: json['score'],
      type: json['type'],
      picture: json['picture'],
      comments: json['comments'] != null
          ? (json['comments'] as List<dynamic>)
              .map((comment) => CommentData.fromJson(comment))
              .toList()
          : [],
    );
  }
}
