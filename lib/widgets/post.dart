import 'package:flutter/material.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:gucy/widgets/flare.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../models/post_data.dart'; // For formatting time

import '../providers/posts_provider.dart';
import 'expanded_post_page.dart';

class Post extends StatefulWidget {
  final PostData postData;
  final bool isClickable;

  const Post({
    Key? key,
    required this.postData,
    this.isClickable = true,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool liked = false;
  bool disliked = false;

  String get timeSincePosted {
    final Duration difference =
        DateTime.now().difference(widget.postData.createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    late UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: false);
    liked = widget.postData.likes.contains(userProvider.user?.uid);
    disliked = widget.postData.dislikes.contains(userProvider.user?.uid);

    Widget _buildGucyMeter() {
      if (widget.postData.score <= 85) {
        return LinearProgressIndicator(
          value: widget.postData.score / 100,
          minHeight: 5,
        );
      }

      return Align(
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: math.pi / 10.0,
          child: badges.Badge(
            position: badges.BadgePosition.topEnd(top: -85, end: 0),
            showBadge: true,
            badgeContent: Text("GUICY!"),
            badgeAnimation: badges.BadgeAnimation.scale(
              animationDuration: Duration(seconds: 3),
              colorChangeAnimationDuration: Duration(seconds: 1),
              loopAnimation: true,
              curve: Curves.easeOutCirc,
              colorChangeAnimationCurve: Curves.easeInCubic,
            ),
            badgeStyle: badges.BadgeStyle(
              shape: badges.BadgeShape.square,
              padding: EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(4),
              badgeGradient: badges.BadgeGradient.linear(
                colors: [
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.onTertiary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              elevation: 0,
            ),
            child: Transform.rotate(
              angle: -math.pi / 10.0,
              child: LinearProgressIndicator(
                value: widget.postData.score / 100,
                minHeight: 5,
              ),
            ),
          ),
        ),
      );
    }

    return Consumer<PostsProvider>(builder: (context, postsProvider, child) {
      return GestureDetector(
        onTap: () {
          analyticsProvider.clickPost(
              "${widget.postData.type} Clicked", userProvider.user!.uid);
          if (widget.isClickable) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExpandedPostPage(postId: widget.postData.id),
              ),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.postData.user.picture),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postData.user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(timeSincePosted),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(widget.postData.title,
                  style: Theme.of(context).textTheme.titleLarge),
              if (widget.postData.tags.length > 0) SizedBox(height: 10),
              if (widget.postData.tags.length > 0)
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.start,
                  children: widget.postData.tags.map((tag) {
                    return Flare(tag: tag);
                  }).toList(),
                ),
              if (widget.postData.tags.length > 0) SizedBox(height: 10),
              // GUCY METER
              if (widget.postData.type == "confession") _buildGucyMeter(),
              if (widget.postData.type != "confession" &&
                  widget.postData.picture != "")
                Image.network(
                  widget.postData.picture,
                  height: 300,
                  width: double.infinity,
                ),
              Text(widget.postData.body),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                            liked ? Icons.thumb_up : Icons.thumb_up_off_alt),
                        onPressed: () {
                          setState(() {
                            if (!liked) {
                              postsProvider.removeDislikeFromPost(
                                  widget.postData.id, userProvider.user!);
                              postsProvider.addLikeToPost(
                                  widget.postData.id, userProvider.user!);
                            } else {
                              postsProvider.removeLikeFromPost(
                                  widget.postData.id, userProvider.user!);
                            }
                          });
                        },
                      ),
                      Text(widget.postData.likes.length.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(disliked
                            ? Icons.thumb_down
                            : Icons.thumb_down_off_alt),
                        onPressed: () {
                          setState(() {
                            if (!disliked) {
                              postsProvider.removeLikeFromPost(
                                  widget.postData.id, userProvider.user!);
                              postsProvider.addDislikeToPost(
                                  widget.postData.id, userProvider.user!);
                            } else {
                              postsProvider.removeDislikeFromPost(
                                  widget.postData.id, userProvider.user!);
                            }
                          });
                        },
                      ),
                      Text(widget.postData.dislikes.length.toString()),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      );
    });
  }
}
