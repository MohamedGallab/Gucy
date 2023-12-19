import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/posts_provider.dart';
import '../../widgets/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String sortingCriteria});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _loadNotificationSettings();
    super.initState();
    Provider.of<PostsProvider>(context, listen: false).loadPosts();
  }

  Future<void> _loadNotificationSettings() async {
    final fbm = FirebaseMessaging.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notificationTypes = [
      'Confession',
      'LostAndFound',
      'Event',
      'Question',
      'Mentions',
    ];

    fbm.requestPermission();
    for (var type in notificationTypes) {
      if (prefs.getBool(type) ?? true) {
        if (type == "Mentions") {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setToken(fbm);
        } else {
          fbm.subscribeToTopic("new$type");
        }
      }
    }
  }

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
