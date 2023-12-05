import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/post_data.dart';

class PostsProvider with ChangeNotifier {
  Future<DocumentReference> addPost(PostData post) {
    // if (!_loggedIn) {
    //   throw Exception('Must be logged in');
    // }

    return FirebaseFirestore.instance
        .collection('posts')
        .add(<String, dynamic>{
      'title': post.title,
      'body': post.body,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      // 'name': FirebaseAuth.instance.currentUser!.displayName,
      // 'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
