import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  // Sample list of notification types
  List<String> notificationTypes = [
    'Confession',
    'Lost and Found',
    'Event',
    'Question',
    'Mentions',
  ];

  // Map to store the toggle state for each notification type
  Map<String, bool> notificationToggleState = {};
  late Future<void> _prefsLoaded;

  @override
  void initState() {
    super.initState();
    _prefsLoaded = _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      for (String type in notificationTypes) {
        notificationToggleState[type] = prefs.getBool(type) ?? true;
      }
    });
  }

  Future<void> _saveNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (String type in notificationTypes) {
      prefs.setBool(type, notificationToggleState[type] ?? true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fbm = FirebaseMessaging.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Settings'),
      ),
      body: FutureBuilder<void>(
        future: _prefsLoaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading preferences'),
            );
          } else {
            return ListView.builder(
              itemCount: notificationTypes.length,
              itemBuilder: (context, index) {
                final notificationType = notificationTypes[index];

                return ListTile(
                  title: Text(notificationType),
                  trailing: Switch(
                    value: notificationToggleState[notificationType] ?? true,
                    onChanged: (bool value) {
                      setState(() {
                        notificationToggleState[notificationType] = value;
                      });

                      // Save toggle state to shared preferences
                      _saveNotificationSettings();

                      if (notificationType == "Mentions") {
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        if (value) {
                          userProvider.setToken(fbm);
                        } else {
                          userProvider.removeToken();
                        }
                      } else {
                        if (value) {
                          fbm.subscribeToTopic("new$notificationType");
                        } else {
                          fbm.unsubscribeFromTopic("new$notificationType");
                        }
                      }

                      // Perform other actions based on toggle state change
                      // For example, update user preferences or send API requests
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
