import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/post_data.dart';

class PostsProvider with ChangeNotifier {
  // incomplete
  Future<DocumentReference> addPost(PostData post) {
    // if (!_loggedIn) {
    //   throw Exception('Must be logged in');
    // }
    var postJson = post.toJson();
    postJson.removeWhere((key, value) => key == "comments");
    return FirebaseFirestore.instance.collection('posts').add(postJson);
  }
}
