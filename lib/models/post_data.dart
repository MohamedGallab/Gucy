class PostData {
  final String profilePicture;
  final String username;
  final DateTime timeStamp;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int comments;
  final int score;
  final String type;
  final String picture;
  final List<String> commentsList;
  final List<String> likesList;
  final List<String> dislikesList;

  const PostData({
    required this.profilePicture,
    required this.username,
    required this.timeStamp,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.score,
    required this.type,
    required this.picture,
    required this.commentsList,
    required this.likesList,
    required this.dislikesList,
  });
}
