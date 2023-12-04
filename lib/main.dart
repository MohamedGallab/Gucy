import 'package:flutter/material.dart';
import 'package:gucy/main_widgets/main_scaffold.dart';

import 'main_widgets/nav_bar.dart';
import 'pages/staff_page.dart';
import 'pages/home_page.dart';
import 'pages/outlets_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData(useMaterial3: true),
      theme: ThemeData.dark(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: MainScaffold(),
    );
  }
}
