import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/post_data.dart';

class PostsProvider with ChangeNotifier {
  // incomplete
  Future<DocumentReference> addPost(PostData post) {
    // if (!_loggedIn) {
    //   throw Exception('Must be logged in');
    // }

    return FirebaseFirestore.instance.collection('posts').add(<String, dynamic>{
      'title': post.title,
      'body': post.body,
      'createAt': DateTime.now().millisecondsSinceEpoch,
      // 'name': FirebaseAuth.instance.currentUser!.displayName,
      // 'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
