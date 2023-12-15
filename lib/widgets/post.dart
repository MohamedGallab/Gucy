import 'package:flutter/material.dart';
import 'package:gucy/widgets/flare.dart';
import 'dart:math' as math;

import '../models/post_data.dart'; // For formatting time

import 'package:badges/badges.dart' as badges;

class Post extends StatefulWidget {
  final PostData postData;

  const Post({
    Key? key,
    required this.postData,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool liked = false;
  bool disliked = false;

  String get timeSincePosted {
    final Duration difference =
        DateTime.now().difference(widget.postData.timeStamp);
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.postData.profilePicture),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.postData.username,
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
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.start, // Align from the beginning
            children: widget.postData.tags.map((tag) {
              return Flare(tag: tag);
            }).toList(),
          ),
          SizedBox(height: 10),
          if (widget.postData.type == "confession")
            Align(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: math.pi / 10.0,
                child: badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -85, end: -20),
                  showBadge: true,
                  badgeContent: Text("GUICYYY!!!"),
                  badgeAnimation: badges.BadgeAnimation.scale(
                    animationDuration: Duration(seconds: 3),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: true,
                    curve: Curves.easeOutCirc,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  badgeStyle: badges.BadgeStyle(
                    shape: badges.BadgeShape.square,
                    badgeColor: Colors.blue,
                    padding: EdgeInsets.all(5),
                    borderRadius: BorderRadius.circular(4),
                    badgeGradient: badges.BadgeGradient.linear(
                      colors: [
                        const Color.fromARGB(255, 159, 33, 243),
                        const Color.fromARGB(255, 255, 59, 121)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    elevation: 0,
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Transform.rotate(
                      angle: -math.pi / 10.0,
                      child: LinearProgressIndicator(
                        value: widget.postData.score / 100,
                        minHeight: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                    icon: Icon(liked ? Icons.thumb_up : Icons.thumb_up_off_alt),
                    onPressed: () {
                      setState(() {
                        liked = !liked;
                      });
                    },
                  ),
                  Text(widget.postData.likes.toString()),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                        disliked ? Icons.thumb_down : Icons.thumb_down_off_alt),
                    onPressed: () {
                      setState(() {
                        disliked = !disliked;
                      });
                    },
                  ),
                  Text(widget.postData.dislikes.toString()),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {},
                  ),
                  Text(widget.postData.comments.toString()),
                ],
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
    );
  }
}
