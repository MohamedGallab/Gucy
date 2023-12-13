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
    return FilledButton(
        onPressed: () {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.logoutUser();
        },
        child: Text('Logout'));
  }
}
