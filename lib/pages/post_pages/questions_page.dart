import 'package:flutter/material.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/posts_provider.dart';
import '../../widgets/post.dart';

class QuestionsPage extends StatefulWidget {
  final String sortingCriteria;

  const QuestionsPage({super.key, required this.sortingCriteria});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostsProvider>(context, listen: false)
        .loadQuestions(sortingMetric: widget.sortingCriteria);
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
              true, "Questions", userProvider.user!.uid);
        } else if (scrollInfo is ScrollEndNotification) {
          analyticsProvider.setScrolling(
              false, "Questions", userProvider.user!.uid);
        }
        return false;
      },
      child: Consumer<PostsProvider>(
        builder: (context, postsProvider, _) {
          return ListView.builder(
            itemCount: postsProvider.questions.length,
            itemBuilder: (context, index) {
              return Post(postData: postsProvider.questions[index]);
            },
          );
        },
      ),
    );
  }
}
