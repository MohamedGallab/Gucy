import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comment_data.dart';
import '../providers/posts_provider.dart';

class Comment extends StatefulWidget {
  final CommentData commentData;

  const Comment({
    Key? key,
    required this.commentData,
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
    return Consumer<PostsProvider>(builder: (context, postsProvider, child) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.commentData.user.picture),
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
                        setState(() {
                          liked = !liked;
                        });
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
                        setState(() {
                          disliked = !disliked;
                        });
                      },
                    ),
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
