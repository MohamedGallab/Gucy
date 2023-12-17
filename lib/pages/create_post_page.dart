// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gucy/models/flairs.dart';
import 'package:gucy/models/post_data.dart';
import 'package:gucy/models/user_data.dart';
import 'package:gucy/pages/preview_post_page.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
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
  String _selectedItem = "Crush";
  String picture = "";
  bool willPost = false;
  void postFinalize() {
    setState(() {
      willPost = true;
    });
  }

  final ImagePicker picker = ImagePicker();
  final storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    Future<void> uploadImage(XFile imageFile) async {
      try {
        try {
          Reference storageReference =
              FirebaseStorage.instance.refFromURL(picture);
          await storageReference.getDownloadURL();
          await storageReference.delete();
        } catch (e) {}
        String fileName = basename(imageFile.path);

        Reference storageReference =
            storage.ref().child('post_images/$fileName');

        await storageReference.putFile(File(imageFile.path));
        final String imageUrl = await storageReference.getDownloadURL();

        setState(() {
          picture = imageUrl;
        });
      } catch (error) {}
    }

    Future<void> deleteImage() async {
      try {
        Reference storageReference =
            FirebaseStorage.instance.refFromURL(picture);
        await storageReference.getDownloadURL();
        await storageReference.delete();
        setState(() {
          picture = "";
        });
      } catch (e) {}
    }

    void showImageOptions() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a photo'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    await uploadImage(pickedFile);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    await uploadImage(pickedFile);
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle),
                title: const Text('Remove photo'),
                onTap: () async {
                  await deleteImage();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return PopScope(
      onPopInvoked: (e) async {
        if (!willPost) await deleteImage();
      },
      child: Scaffold(
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
                        backgroundImage: (isAnonymous ||
                                userProvider.user?.picture == "")
                            ? const Image(
                                    image: AssetImage(
                                        "assets/default_profile.png"))
                                .image
                            : NetworkImage(userProvider.user?.picture ?? ""),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAnonymous
                                ? "Anonymous"
                                : userProvider.user?.name ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isAnonymous
                                ? "Post anonymously"
                                : "Post as yourself",
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
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        ...flairs.map((e) => OutlinedButton(
                              onPressed: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
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
                                        padding: const EdgeInsets.all(0.0),
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
                          DropdownButton(
                            value: _selectedItem,
                            autofocus: true,
                            onChanged: (newValue) {
                              setState(() {
                                isAddingFlair = false;
                                _selectedItem = newValue as String;
                              });
                            },
                            items: getBaseFlairs()
                                .map((e) => DropdownMenuItem(
                                      onTap: () => setState(() {
                                        flairs.add(e);
                                      }),
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                          ),
                        if (isAddingFlair)
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isAddingFlair = false;
                                });
                              },
                              icon: const Icon(Icons.close)),
                        const SizedBox(height: 10),
                        if (widget.type != "confession")
                          OutlinedButton(
                            onPressed: () {
                              showImageOptions();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(picture == "" ? Icons.add : Icons.check),
                                const Text("Image")
                              ],
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
                          user: UserData(
                              name: isAnonymous
                                  ? "Anonymous"
                                  : userProvider.user?.name ?? "",
                              picture: (isAnonymous ||
                                      userProvider.user?.picture == "")
                                  ? "https://firebasestorage.googleapis.com/v0/b/gucy-45427.appspot.com/o/default_profile.png?alt=media&token=7f72bda5-bf9e-44bf-9461-b1f650d3d840"
                                  : userProvider.user?.picture ?? "",
                              uid: userProvider.user?.uid ?? "",
                              score: userProvider.user?.score ?? 0,
                              eventPermission:
                                  userProvider.user?.eventPermission ?? "None"),
                          createdAt: DateTime.now(),
                          title: title,
                          body: body,
                          tags: flairs,
                          likes: [],
                          dislikes: [],
                          comments: [],
                          score: 0,
                          type: widget.type,
                          picture: picture,
                        );

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PreviewPost(post, postFinalize)));
                      },
                      child: const Text("Preview Post"))
                ],
              ),
            ),
          )),
    );
  }
}
