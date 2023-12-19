// ignore_for_file: use_build_context_synchronously, deprecated_member_use, empty_catches

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gucy/pages/post_pages/my_posts_page.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../pages/color_picker.dart';
import '../pages/notifications_settings_page.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final ImagePicker picker = ImagePicker(); // ImagePicker instance
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    Future<void> uploadImage(XFile imageFile) async {
      try {
        try {
          // Get a reference to the file in Firebase Storage from the download URL
          Reference storageReference = FirebaseStorage.instance
              .refFromURL(userProvider.user?.picture ?? "");
          await storageReference.getDownloadURL();
          await storageReference.delete();
        } catch (e) {}
        String fileName = basename(imageFile.path);

        Reference storageReference =
            storage.ref().child('profile_images/$fileName');

        await storageReference.putFile(File(imageFile.path));
        final String imageUrl = await storageReference.getDownloadURL();
        userProvider.user?.picture = imageUrl;
        userProvider.updateUser(userProvider.user!);
      } catch (error) {}
    }

    Future<void> deleteImage() async {
      try {
        // Get a reference to the file in Firebase Storage from the download URL
        Reference storageReference = FirebaseStorage.instance
            .refFromURL(userProvider.user?.picture ?? "");
        await storageReference.getDownloadURL();
        await storageReference.delete();
        userProvider.user?.picture = "";
        userProvider.updateUser(userProvider.user!);
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
                  // Logic for taking a photo
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

    final analyticsProvider = Provider.of<AnalyticsProvider>(context);
    return Container(
      margin: const EdgeInsets.only(top: 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: showImageOptions,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                userProvider.user?.picture == ""
                    ? Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/gucy-45427.appspot.com/o/default_profile.png?alt=media&token=7f72bda5-bf9e-44bf-9461-b1f650d3d840",
                        width: 220,
                        height: 220,
                      )
                    : ClipOval(
                        child: SizedBox(
                          width: 220,
                          height: 220,
                          child: Image.network(
                            userProvider.user?.picture ?? "",
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        'assets/file_upload.svg',
                        width: 24,
                        height: 24,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            (userProvider.user?.name ?? ""),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              analyticsProvider.changeAction(
                  'Viewing My Posts', userProvider.user!.uid);
              analyticsProvider.changePage('My Posts', userProvider.user!.uid);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyPostsPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    'My Posts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              userProvider.logoutUser();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Log Out',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ColorPickerPage(themeMode: (ThemeMode x) {})),
                );
              },
              child: Text("Change Color")),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsSettingsPage()),
                );
              },
              child: Text("Notification Settings")),
        ],
      ),
    );
  }
}
