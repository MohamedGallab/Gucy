import 'package:flutter/material.dart';
import 'package:gucy/pages/contacts_page.dart';
import 'package:gucy/pages/outlets_page.dart';
import 'package:gucy/pages/staff_page.dart';

List<TabBarView> tabBarViews = [
  TabBarView(
    children: [
      // Home Page Contents for Tab 1
      Center(
        child: Text('Home Tab 1 Content'),
      ),
      // Home Page Contents for Tab 2
      Center(
        child: Text('Home Tab 2 Content'),
      ),
      // Home Page Contents for Tab 3
      Center(
        child: Text('Home Tab 3 Content'),
      ),
    ],
  ),
  TabBarView(
    children: [
      // Academics Page Contents for Tab A
      StaffPage(),
      // Academics Page Contents for Tab B
      Center(
        child: Text('Academics Tab B Content'),
      ),
    ],
  ),
  TabBarView(
    children: [
      // Facilities Page Contents for Tab X
      OutletsPage(),
      // Facilities Page Contents for Tab Y
      ContactsPage()
    ],
  )
];
