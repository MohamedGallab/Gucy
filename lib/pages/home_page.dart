import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gucy'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tab A'),
              Tab(text: 'Tab B'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Academics Page Contents for Tab A
            Center(
              child: Text('Academics Tab A Content'),
            ),
            // Academics Page Contents for Tab B
            Center(
              child: Text('Academics Tab B Content'),
            ),
          ],
        ),
      ),
    );
  }
}
