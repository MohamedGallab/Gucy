import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentPageIndex;
  final Function(int)? onDestinationSelected;
  const NavBar(
      {super.key,
      required this.currentPageIndex,
      required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: onDestinationSelected,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.school),
          icon: Icon(Icons.school_outlined),
          label: 'Academics',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.store),
          icon: Icon(Icons.store_outlined),
          label: 'Facilities',
        ),
      ],
    );
  }
}
