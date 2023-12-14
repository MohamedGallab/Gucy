// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    final userProvider = Provider.of<UserProvider>(
      context,
    );

    Future<void> uploadImage(XFile imageFile) async {
      try {
        try {
          // Get a reference to the file in Firebase Storage from the download URL
          Reference storageReference =
              FirebaseStorage.instance.refFromURL(userProvider.user["picture"]);
          await storageReference.getDownloadURL();
          await storageReference.delete();
          print('File deleted from Firebase Storage. URL: ');
        } catch (e) {}
        String fileName = basename(imageFile.path);

        Reference storageReference =
            storage.ref().child('profile_images/$fileName');

        await storageReference.putFile(File(imageFile.path));
        final String imageUrl = await storageReference.getDownloadURL();
        userProvider.user["picture"] = imageUrl;
        userProvider.updateUser(userProvider.user);

        print('Image uploaded to Firebase Storage. URL: $imageUrl');
      } catch (error) {
        print('Error uploading image to Firebase Storage: $error');
      }
    }

    Future<void> deleteImage() async {
      try {
        // Get a reference to the file in Firebase Storage from the download URL
        Reference storageReference =
            FirebaseStorage.instance.refFromURL(userProvider.user["picture"]);
        await storageReference.getDownloadURL();
        await storageReference.delete();
        userProvider.user["picture"] = "";
        userProvider.updateUser(userProvider.user);
        print('File deleted from Firebase Storage. URL: ');
      } catch (e) {}
    }

    final TextEditingController controller =
        TextEditingController(text: userProvider.email);
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
                    print('Photo taken: ${pickedFile.path}');
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
                    print('Photo selected: ${pickedFile.path}');
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppBar(
          title: const Text(''),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: showImageOptions,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              userProvider.user["picture"] == ""
                  ? Image.asset(
                      'assets/default_profile.png',
                      width: 220,
                      height: 220,
                    )
                  : ClipOval(
                      child: Container(
                        width: 220, // Set width as needed
                        height: 220,
                        child: Image.network(
                          // Set height as needed
                          userProvider.user["picture"],
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/file_upload.svg',
                      width: 24,
                      height: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          (userProvider.user)['name'],
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
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
              Icon(
                Icons.cancel_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
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
      ],
    );
  }
}