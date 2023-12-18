import 'package:flutter/material.dart';
import 'package:gucy/pages/contacts_page.dart';
import 'package:gucy/pages/post_pages/home_page.dart';
import 'package:gucy/pages/outlets_page.dart';
import 'package:gucy/pages/post_pages/confessions_page.dart';
import 'package:gucy/pages/post_pages/events_page.dart';
import 'package:gucy/pages/post_pages/lost_and_found_page.dart';
import 'package:gucy/pages/post_pages/my_posts_page.dart';
import 'package:gucy/pages/post_pages/questions_page.dart';
import 'package:gucy/pages/staff_page.dart';

List<List<Widget>> tabBarViews = [
  [
    HomePage(),
    ConfessionsPage(),
    EventsPage(),
    LostAndFoundPage(),
    MyPostsPage(),
    QuestionsPage(),
  ],
  [
    StaffPage(),
  ],
  [
    OutletPage(),
    ContactsPage(),
  ]
];
