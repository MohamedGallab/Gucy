import 'package:flutter/material.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/posts_provider.dart';
import '../../widgets/post.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({super.key, required String sortingCriteria});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostsProvider>(context, listen: false).loadLostAndFound("");
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: false);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollStartNotification) {
          analyticsProvider.setScrolling(
              true, "Lost and Found", userProvider.user!.uid);
        } else if (scrollInfo is ScrollEndNotification) {
          analyticsProvider.setScrolling(
              false, "Lost and Found", userProvider.user!.uid);
        }
        return false;
      },
      child: Consumer<PostsProvider>(
        builder: (context, postsProvider, _) {
          return ListView.builder(
            itemCount: postsProvider.lostAndFound.length,
            itemBuilder: (context, index) {
              return Post(postData: postsProvider.lostAndFound[index]);
            },
          );
        },
      ),
    );
  }
}
