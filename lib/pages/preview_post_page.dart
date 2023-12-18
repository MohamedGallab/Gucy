import 'package:flutter/material.dart';
import 'package:gucy/models/post_data.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/posts_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:gucy/widgets/post.dart';
import 'package:provider/provider.dart';

class PreviewPost extends StatefulWidget {
  final PostData post;
  final Function postFinalize;
  const PreviewPost(this.post, this.postFinalize, {Key? key}) : super(key: key);

  @override
  State<PreviewPost> createState() => _PreviewPostState();
}

class _PreviewPostState extends State<PreviewPost> {
  bool _isPosting = false;
  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostsProvider>(context, listen: false);
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text("Preview Post"),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            IgnorePointer(
                ignoring: true,
                child: Post(postData: widget.post, isClickable: false)),
            FilledButton(
                onPressed: () async {
                  try {
                    // Set _isPosting to true to show the loading screen
                    setState(() {
                      _isPosting = true;
                    });

                    // Validate post content
                    if (widget.post.body.isNotEmpty) {
                      // Add the post to Firestore
                      await postProvider.addPost(widget.post);

                      // Set _isPosting to false to hide the loading screen
                      setState(() {
                        _isPosting = false;
                      });

                      // Show a success Snackbar
                      _showSnackbar('Post successfully added !',
                          Theme.of(context).colorScheme.primary);
                      switch (widget.post.type) {
                        case "confession":
                          analyticsProvider.changeAction(
                              "Viewing Confessions", userProvider.user!.uid);
                          break;
                        case "event":
                          analyticsProvider.changeAction(
                              "Viewing Events", userProvider.user!.uid);
                          break;
                        case "question":
                          analyticsProvider.changeAction(
                              "Viewing Questions", userProvider.user!.uid);
                          break;
                        case "lost and found":
                          analyticsProvider.changeAction(
                              "Viewing Lost and Found", userProvider.user!.uid);
                          break;
                        default:
                          analyticsProvider.changeAction(
                              "Viewing Other", userProvider.user!.uid);
                      }
                    } else {
                      // Set _isPosting to false to hide the loading screen
                      setState(() {
                        _isPosting = false;
                      });

                      // Show an error Snackbar if post content is empty
                      _showSnackbar('Post content cannot be empty.',
                          Theme.of(context).colorScheme.secondary);
                    }
                  } catch (error) {
                    // Set _isPosting to false to hide the loading screen
                    setState(() {
                      _isPosting = false;
                    });

                    // Show an error Snackbar
                    _showSnackbar('Failed to post. Please try again later.',
                        Theme.of(context).colorScheme.secondary);
                  }
                  widget.postFinalize();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Post"))
          ],
        )),
      ),
      _isPosting
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
              ),
            )
          : Container(),
    ]);
  }
}
