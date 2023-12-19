import 'package:flutter/material.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/posts_provider.dart';
import '../../widgets/post.dart';

class ConfessionsPage extends StatefulWidget {
  final String sortingCriteria;

  const ConfessionsPage({super.key, required this.sortingCriteria});

  @override
  State<ConfessionsPage> createState() => _ConfessionsPageState();
}

class _ConfessionsPageState extends State<ConfessionsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostsProvider>(context, listen: false)
        .loadConfessions(sortingMetric: widget.sortingCriteria);
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
              true, "Confessions", userProvider.user!.uid);
        } else if (scrollInfo is ScrollEndNotification) {
          analyticsProvider.setScrolling(
              false, "Confessions", userProvider.user!.uid);
        }
        return false;
      },
      child: Consumer<PostsProvider>(
        builder: (context, postsProvider, _) {
          return ListView.builder(
            itemCount: postsProvider.confessions.length,
            itemBuilder: (context, index) {
              return Post(postData: postsProvider.confessions[index]);
            },
          );
        },
      ),
    );
  }
}
