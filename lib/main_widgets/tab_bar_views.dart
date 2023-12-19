import 'package:flutter/material.dart';
import 'package:gucy/pages/contacts_page.dart';
import 'package:gucy/pages/outlets_page.dart';
import 'package:gucy/pages/staff_page.dart';

List<List<Widget>> tabBarViews = [
  [
    // HomePage(),
    // ConfessionsPage(),
    // EventsPage(),
    // LostAndFoundPage(),
    // QuestionsPage(),
  ],
  [
    StaffPage(),
  ],
  [
    OutletPage(),
    ContactsPage(),
  ]
];
