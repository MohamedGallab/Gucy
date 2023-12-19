import 'package:flutter/material.dart';
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
    return Consumer<PostsProvider>(
      builder: (context, postsProvider, _) {
        return ListView.builder(
          itemCount: postsProvider.confessions.length,
          itemBuilder: (context, index) {
            return Post(postData: postsProvider.confessions[index]);
          },
        );
      },
    );
  }
}
