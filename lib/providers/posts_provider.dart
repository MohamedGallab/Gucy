import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/comment_data.dart';
import '../models/post_data.dart';
import '../models/user_data.dart';

class PostsProvider with ChangeNotifier {
  List<PostData> _posts = [];
  List<PostData> _confessions = [];

  PostsProvider() {
    _loadPosts();
  }

  List<PostData> get posts => _posts;

  void _loadPosts() {
    FirebaseFirestore.instance.collection('posts').snapshots().listen(
      (QuerySnapshot snapshot) {
        _posts = snapshot.docs.map((doc) {
          Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;
          PostData post = PostData.fromJson(postData);
          post.id = doc.id;
          return post;
        }).toList();
        notifyListeners();
      },
      onError: (error) {
        // Handle errors if needed
        print('Error fetching posts: $error');
      },
    );
  }

  void _loadConfessions() {
    FirebaseFirestore.instance
        .collection('posts')
        .where('type', isEqualTo: 'confession')
        .snapshots()
        .listen(
      (QuerySnapshot snapshot) {
        _confessions = snapshot.docs.map((doc) {
          Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;
          PostData post = PostData.fromJson(postData);
          post.id = doc.id;
          return post;
        }).toList();
        notifyListeners();
      },
      onError: (error) {
        // Handle errors if needed
        print('Error fetching posts: $error');
      },
    );
  }

  PostData getPostById(String postId) {
    return _posts.firstWhere(
      (post) => post.id == postId,
    );
  }

  Future<void> addLikeToPost(String postId, UserData currentUser) async {
    try {
      // Update the likes list for the post in Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([currentUser.uid]),
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error adding like to post: $e');
    }
  }

  Future<void> removeLikeFromPost(String postId, UserData currentUser) async {
    try {
      // Update the likes list for the post in Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([currentUser.uid]),
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error removing like from post: $e');
    }
  }

  Future<void> addDislikeToPost(String postId, UserData currentUser) async {
    try {
      // Update the dislikes list for the post in Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'dislikes': FieldValue.arrayUnion([currentUser.uid]),
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error adding dislike to post: $e');
    }
  }

  Future<void> removeDislikeFromPost(
      String postId, UserData currentUser) async {
    try {
      // Update the dislikes list for the post in Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'dislikes': FieldValue.arrayRemove([currentUser.uid]),
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error removing dislike from post: $e');
    }
  }

  Future<void> loadCommentsForPost(String postId) async {
    try {
      // Fetch comments for the post from Firestore
      int postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        QuerySnapshot<Map<String, dynamic>> commentsSnapshot =
            await FirebaseFirestore.instance
                .collection('posts')
                .doc(postId)
                .collection('comments')
                .get();

        // Map comments data to CommentData objects
        List<CommentData> comments = commentsSnapshot.docs.map((commentDoc) {
          CommentData comment = CommentData.fromJson(commentDoc.data());
          comment.id = commentDoc.id;
          return comment;
        }).toList();

        // Populate the comments for the post
        _posts[postIndex].comments = comments;

        // Notify listeners that the posts list has changed
        notifyListeners();
      }
    } catch (e) {
      // Handle errors if needed
      print('Error loading comments for post: $e');
    }
  }

  Future<void> addCommentToPost(String postId, CommentData comment) async {
    try {
      // Add the comment to Firestore
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
        'body': comment.body,
        'user': comment.user.toJson(),
        'createdAt': comment.createdAt,
        'likes': comment.likes,
        'dislikes': comment.dislikes,
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error adding comment to post: $e');
    }
  }

  Future<void> addLikeToComment(
      String postId, String commentId, UserData currentUser) async {
    try {
      // Update the likes list for the comment in Firestore
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([currentUser.uid]),
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error adding like to comment: $e');
    }
  }

  Future<void> removeLikeFromComment(
      String postId, String commentId, UserData currentUser) async {
    try {
      // Update the likes list for the comment in Firestore
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([currentUser.uid]),
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error removing like from comment: $e');
    }
  }

  Future<void> addDislikeToComment(
      String postId, String commentId, UserData currentUser) async {
    try {
      // Update the dislikes list for the comment in Firestore
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'dislikes': FieldValue.arrayUnion([currentUser.uid]),
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error adding dislike to comment: $e');
    }
  }

  Future<void> removeDislikeFromComment(
      String postId, String commentId, UserData currentUser) async {
    try {
      // Update the dislikes list for the comment in Firestore
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'dislikes': FieldValue.arrayRemove([currentUser.uid]),
      });

      // Notify listeners that the posts list has changed
      notifyListeners();
    } catch (e) {
      // Handle errors if needed
      print('Error removing dislike from comment: $e');
    }
  }

  Future<DocumentReference> addPost(PostData post) async {
    Map<String, dynamic> postJson = post.toJson();
    postJson.removeWhere((key, value) => key == "comments");
    RegExp regex = RegExp(r'@(\w+)\s+(\w+)');
    String postBody = postJson['body'];
    Iterable<RegExpMatch> matches = regex.allMatches(postBody);
    if (matches.isNotEmpty) {
      String fullName =
          "${matches.first.group(1) ?? ""} ${matches.first.group(2) ?? ""}";

      // Perform Firestore query to get user data
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: fullName)
          .get();

      // Check if user exists
      if (userQuery.docs.isNotEmpty) {
        // Assuming that the user's token is stored in the 'token' field
        String taggedToken = userQuery.docs.first['token'];

        // Update postJson with the 'tagged' field
        postJson['tagged'] = taggedToken;
      }
    }

    // Add post to Firestore
    return FirebaseFirestore.instance.collection('posts').add(postJson);
  }
}
