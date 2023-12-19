import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/posts_provider.dart';
import '../../widgets/post.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostsProvider>(context, listen: false).loadQuestions("");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsProvider>(
      builder: (context, postsProvider, _) {
        return ListView.builder(
          itemCount: postsProvider.questions.length,
          itemBuilder: (context, index) {
            return Post(postData: postsProvider.questions[index]);
          },
        );
      },
    );
  }
}
