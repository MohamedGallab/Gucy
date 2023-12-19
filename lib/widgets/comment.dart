import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comment_data.dart';
import '../providers/posts_provider.dart';
import '../providers/user_provider.dart';

class Comment extends StatefulWidget {
  final CommentData commentData;
  final String postId;

  const Comment({
    Key? key,
    required this.commentData,
    required this.postId,
  }) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool liked = false;
  bool disliked = false;

  String get timeSincePosted {
    final Duration difference =
        DateTime.now().difference(widget.commentData.createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    late UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    liked = widget.commentData.likes.contains(userProvider.user?.uid);
    disliked = widget.commentData.dislikes.contains(userProvider.user?.uid);

    return Consumer<PostsProvider>(builder: (context, postsProvider, child) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: widget.commentData.user.picture == ""
                      ? null
                      : NetworkImage(widget.commentData.user.picture),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.commentData.user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(timeSincePosted),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2),
            Text(widget.commentData.body),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      icon:
                          Icon(liked ? Icons.thumb_up : Icons.thumb_up_off_alt),
                      onPressed: () {
                        if (liked) {
                          postsProvider.removeLikeFromComment(
                              widget.postId,
                              widget.commentData.id,
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!);
                        } else {
                          postsProvider.addLikeToComment(
                              widget.postId,
                              widget.commentData.id,
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!);
                          postsProvider.removeDislikeFromComment(
                              widget.postId,
                              widget.commentData.id,
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!);
                        }
                      },
                    ),
                    Text(widget.commentData.likes.length.toString()),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(disliked
                          ? Icons.thumb_down
                          : Icons.thumb_down_off_alt),
                      onPressed: () {
                        if (disliked) {
                          postsProvider.removeDislikeFromComment(
                              widget.postId,
                              widget.commentData.id,
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!);
                        } else {
                          postsProvider.addDislikeToComment(
                              widget.postId,
                              widget.commentData.id,
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!);
                          postsProvider.removeLikeFromComment(
                              widget.postId,
                              widget.commentData.id,
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!);
                        }
                      },
                    ),
                    Text(widget.commentData.dislikes.length.toString()),
                    // Text(widget.commentData.dislikesList.length.toString()),
                  ],
                ),
                // Row(
                //   children: [
                //     IconButton(
                //       icon: Icon(Icons.comment),
                //       onPressed: () {},
                //     ),
                //     // Text(widget.postData.comments.toString()),
                //   ],
                // ),
                // IconButton(
                //   icon: Icon(Icons.share),
                //   onPressed: () {},
                // ),
              ],
            ),
            Divider(),
          ],
        ),
      );
    });
  }
}
