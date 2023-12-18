import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationsSettingsPageState createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  // Sample list of notification types
  List<String> notificationTypes = [
    'Confessions',
    'Lost and Found',
    'Event',
    'Questions',
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Settings'),
      ),
      body: FutureBuilder<void>(
        future: _prefsLoaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
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
