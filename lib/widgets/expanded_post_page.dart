import 'package:flutter/material.dart';
import 'package:gucy/widgets/comment.dart';
import 'package:gucy/widgets/post.dart';
import 'package:provider/provider.dart';

import '../models/post_data.dart';
import '../providers/posts_provider.dart';

class ExpandedPostPage extends StatefulWidget {
  final String postId;

  const ExpandedPostPage({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<ExpandedPostPage> createState() => _ExpandedPostPageState();
}

class _ExpandedPostPageState extends State<ExpandedPostPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostsProvider>(builder: (context, postsProvider, _) {
      PostData postData = postsProvider.getPostById(widget.postId);
      postsProvider.loadCommentsForPost(widget.postId);
      return Scaffold(
        appBar: AppBar(
          title: Text('Post Details'),
        ),
        body: Column(
          children: [
            Post(postData: postData, isClickable: false),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: postData.comments.length,
                itemBuilder: (context, index) {
                  final comment = postData.comments[index];
                  return Comment(commentData: comment);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
