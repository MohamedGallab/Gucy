import 'package:flutter/material.dart';
import 'package:gucy/models/post_data.dart';
import 'package:gucy/widgets/post.dart';

class PreviewPost extends StatelessWidget {
  final PostData post;
  final Function postFinalize;
  const PreviewPost(this.post, this.postFinalize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Post"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          IgnorePointer(ignoring: true, child: Post(postData: post, isClickable: false)),
          FilledButton(
              onPressed: () {
                postFinalize();
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
