import 'package:flutter/material.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/posts_provider.dart';
import '../../widgets/post.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: true);
    return PopScope(
      onPopInvoked: (e) async {
        analyticsProvider.changeAction(
            'Viewing Profile', userProvider.user!.uid);
        analyticsProvider.changePage('Profile', userProvider.user!.uid);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Posts"),
        ),
        body: Consumer<PostsProvider>(
          builder: (context, postsProvider, _) {
            return ListView.builder(
              itemCount: postsProvider.posts.length,
              itemBuilder: (context, index) {
                return Post(postData: postsProvider.posts[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
