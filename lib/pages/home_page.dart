import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../stubs/dummy_posts.dart';
import '../widgets/post.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    super.initState();
  }

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
