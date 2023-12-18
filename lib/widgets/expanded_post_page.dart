import 'package:flutter/material.dart';
import 'package:gucy/models/comment_data.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:gucy/widgets/comment.dart';
import 'package:gucy/widgets/post.dart';
import 'package:provider/provider.dart';

import '../models/post_data.dart';
import '../providers/posts_provider.dart';

class ExpandedPostPage extends StatefulWidget {
  final String postId;

  const ExpandedPostPage({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  State<ExpandedPostPage> createState() => _ExpandedPostPageState();
}

class _ExpandedPostPageState extends State<ExpandedPostPage> {
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<List<CommentData>> _comments;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsProvider>(builder: (context, postsProvider, _) {
      PostData postData = postsProvider.getPostById(widget.postId);
      _comments = postsProvider.loadCommentsForPost(widget.postId);

      return Scaffold(
        appBar: AppBar(
          title: Text('Post Details'),
        ),
        body: FutureBuilder<List<CommentData>>(
            future: _comments,
            builder: (BuildContext context,
                AsyncSnapshot<List<CommentData>> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Post(postData: postData, isClickable: false),
                    Text(
                      '${snapshot.data!.length} Comments',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final comment = snapshot.data![index];
                          return Comment(
                              commentData: comment, postId: widget.postId);
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0).copyWith(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                controller: commentController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'Type your comment...',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your comment';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                child: const Text('Submit Comment'),
                                onPressed: () {
                                  commentController.text =
                                      commentController.text.trim();
                                  // Validate the form
                                  if (_formKey.currentState!.validate()) {
                                    // Form is valid, process the comment or perform any other action
                                    String comment = commentController.text;
                                    CommentData commentData = CommentData(
                                      body: comment,
                                      user: Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user!,
                                      createdAt: DateTime.now(),
                                      dislikes: [],
                                      likes: [],
                                    );

                                    postsProvider.addCommentToPost(
                                      widget.postId,
                                      commentData,
                                    );

                                    commentController.clear();
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                },
            icon: Icon(Icons.add),
            label: Text('Add Comment')),
      );
    });
  }
}
