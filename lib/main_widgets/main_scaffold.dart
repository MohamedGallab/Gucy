import 'package:flutter/material.dart';

import 'nav_bar.dart';
import 'tab_bar_views.dart';
import 'tab_bars.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBars[_currentPageIndex].tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gucy'),
          bottom: tabBars[_currentPageIndex],
        ),
        body: tabBarViews[_currentPageIndex],
        bottomNavigationBar: NavBar(
          currentPageIndex: _currentPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
