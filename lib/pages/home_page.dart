import 'package:flutter/material.dart';

import '../models/post_data.dart';
import '../widgets/post.dart';

class HomePage extends StatelessWidget {
  final List<PostData> dummyPosts = [
    PostData(
        profilePicture:
            'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg',
        username: 'Hana Tamer',
        timeStamp: DateTime.now().subtract(Duration(days: 2)),
        title: 'I have a crush on the boy with green hoodie and a short beard',
        body:
            'I saw this boy at C5 and he was wearing a green hoodie and was with his friends. I just want to say I LOOOOOOOVE YOU <3',
        tags: ['Crush', 'Rant', 'Help'],
        likes: 1500,
        dislikes: 300,
        comments: 70,
        score: 70,
        type: "confession",
        picture: "",
        likesList: [],
        dislikesList: [],
        commentsList: []),
    PostData(
        profilePicture:
            'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg',
        username: 'Ali Omar',
        timeStamp: DateTime.now().subtract(Duration(hours: 12)),
        title: 'FLUSH AFTER YOU ARE DONE',
        body:
            'You guys are disgusting. I went to the bathroom and there was poop everywhere. Please flush after you are done.',
        tags: ['Help', 'Rant'],
        likes: 80,
        dislikes: 20,
        comments: 5,
        score: 10,
        type: "confession",
        picture: "",
        likesList: [],
        dislikesList: [],
        commentsList: []),
    // Add more dummy data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyPosts.length,
      itemBuilder: (context, index) {
        return Post(postData: dummyPosts[index]);
      },
    );
  }
}
