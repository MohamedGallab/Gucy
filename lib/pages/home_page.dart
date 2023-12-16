import 'package:flutter/material.dart';

import '../stubs/dummy_posts.dart';
import '../widgets/post.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyPosts.length,
      itemBuilder: (context, index) {
        return Post(postData: dummyPosts[index]);
      },
    );
  }
}
