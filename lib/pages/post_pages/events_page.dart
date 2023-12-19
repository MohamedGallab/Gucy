import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/posts_provider.dart';
import '../../widgets/post.dart';

class EventsPage extends StatefulWidget {
  final String sortingCriteria;

  const EventsPage({super.key, required this.sortingCriteria});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostsProvider>(context, listen: false).loadEvents(sortingMetric: widget.sortingCriteria);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsProvider>(
      builder: (context, postsProvider, _) {
        return ListView.builder(
          itemCount: postsProvider.events.length,
          itemBuilder: (context, index) {
            return Post(postData: postsProvider.events[index]);
          },
        );
      },
    );
  }
}
