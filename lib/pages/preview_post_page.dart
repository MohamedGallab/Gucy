import 'package:flutter/material.dart';
import 'package:gucy/models/post_data.dart';
import 'package:gucy/widgets/post.dart';

class PreviewPost extends StatelessWidget {
  final PostData post;
  const PreviewPost(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Post"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          IgnorePointer(ignoring: true, child: Post(postData: post)),
          FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                //backend stuff add the post
              },
              child: const Text("Post"))
        ],
      )),
    );
  }
}
