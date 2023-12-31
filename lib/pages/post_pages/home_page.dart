import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/posts_provider.dart';
import '../../widgets/post.dart';

class HomePage extends StatefulWidget {
  final String sortingCriteria;

  const HomePage({super.key, required this.sortingCriteria});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _loadNotificationSettings();
    super.initState();
    Provider.of<PostsProvider>(context, listen: false)
        .loadPosts(sortingMetric: widget.sortingCriteria);
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: false);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollStartNotification) {
          analyticsProvider.setScrolling(true, "Home", userProvider.user!.uid);
        } else if (scrollInfo is ScrollEndNotification) {
          analyticsProvider.setScrolling(false, "Home", userProvider.user!.uid);
        }
        return false;
      },
      child: Consumer<PostsProvider>(
        builder: (context, postsProvider, _) {
          return ListView.builder(
            itemCount: postsProvider.posts.length,
            itemBuilder: (context, index) {
              return Post(postData: postsProvider.posts[index]);
            },
          );
        },
      ),
    );
  }
}
