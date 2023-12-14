import 'package:flutter/material.dart';
import 'package:gucy/models/post_data.dart';
import 'package:gucy/pages/preview_post_page.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  final String type;
  const CreatePostPage(this.type, {Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isAnonymous = false;
  TextEditingController titleController = TextEditingController();
  String title = '';
  TextEditingController bodyController = TextEditingController();
  String body = '';
  List<String> flairs = [];
  bool isAddingFlair = false;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Create ${widget.type}"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: isAnonymous
                          ? const Image(
                                  image:
                                      AssetImage("assets/default_profile.png"))
                              .image
                          : NetworkImage(userProvider.user["picture"]),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAnonymous ? "Anonymous" : userProvider.user["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isAnonymous ? "Post anonymously" : "Post as yourself",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Switch(
                      value: isAnonymous,
                      onChanged: (value) {
                        setState(() {
                          isAnonymous = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  onChanged: (value) => title = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing:
                        8.0, // Adjust the spacing between items according to your preference
                    runSpacing:
                        8.0, // Adjust the spacing between lines according to your preference
                    children: [
                      ...flairs.map((e) => OutlinedButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0), // Adjust the padding here
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(e),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        flairs.remove(e);
                                      });
                                    },
                                    child: Ink(
                                      padding: const EdgeInsets.all(
                                          0.0), // Adjust the padding here
                                      child: const Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      if (!isAddingFlair)
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isAddingFlair = !isAddingFlair;
                            });
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.add), Text("Flair")],
                          ),
                        ),
                      if (isAddingFlair)
                        Expanded(
                          child: IntrinsicWidth(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 100.0,
                              ),
                              child: TextField(
                                maxLength: 20,
                                maxLines: 1,
                                autofocus: true,
                                onTapOutside: (event) {
                                  setState(() {
                                    isAddingFlair = !isAddingFlair;
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                    if (value.isNotEmpty) {
                                      if (flairs.contains(value)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Flair already added")));
                                      } else {
                                        flairs.add(value);
                                      }
                                      isAddingFlair = !isAddingFlair;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  labelText: 'Flair',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        isAddingFlair = !isAddingFlair;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.type != "confession")
                        OutlinedButton(
                          onPressed: () {},
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.add), Text("Image")],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 10,
                  minLines: 10,
                  controller: bodyController,
                  onChanged: (value) => body = value,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    labelText: 'Body',
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton(
                    onPressed: () {
                      PostData post = PostData(
                          profilePicture: isAnonymous
                              ? "https://firebasestorage.googleapis.com/v0/b/gucy-45427.appspot.com/o/default_profile.png?alt=media&token=7f72bda5-bf9e-44bf-9461-b1f650d3d840"
                              : userProvider.user["picture"],
                          username: isAnonymous
                              ? "Anonymous"
                              : userProvider.user["name"],
                          timeStamp: DateTime.now(),
                          title: title,
                          body: body,
                          tags: flairs,
                          likes: 0,
                          dislikes: 0,
                          comments: 0,
                          score: 0);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PreviewPost(post)));
                    },
                    child: const Text("Preview Post"))
              ],
            ),
          ),
        ));
  }
}
