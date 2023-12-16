import 'package:flutter/material.dart';
import 'package:gucy/widgets/comment.dart';
import 'package:gucy/widgets/post.dart';

import '../models/post_data.dart';

class ExpandedPostPage extends StatelessWidget {
  final PostData postData;

  const ExpandedPostPage({
    Key? key,
    required this.postData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
