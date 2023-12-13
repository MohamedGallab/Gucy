import 'package:flutter/material.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final TextEditingController controller =
        TextEditingController(text: (userProvider.email));
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
        Image.asset(
            userProvider.user["picutre"] == ""
                ? 'assets/default_profile.png'
                : "",
            width: 220,
            height: 220),
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
