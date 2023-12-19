import 'package:flutter/material.dart';
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
    Provider.of<PostsProvider>(context, listen: false).loadLostAndFound();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<PostsProvider>(
      builder: (context, postsProvider, _) {
        return ListView.builder(
          itemCount: postsProvider.lostAndFound.length,
          itemBuilder: (context, index) {
            return Post(postData: postsProvider.lostAndFound[index]);
          },
        );
      },
    );
  }
}