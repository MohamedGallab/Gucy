import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/post_data.dart';
import '../providers/posts_provider.dart';
import '../widgets/post.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsProvider>(
      builder: (context, postsProvider, _) {
        return ListView.builder(
          itemCount: postsProvider.posts.length,
          itemBuilder: (context, index) {
            return Post(postData: postsProvider.posts[index]);
          },
        );
      },
    );
  }
}
