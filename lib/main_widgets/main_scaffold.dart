import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gucy/main_widgets/main_drawer.dart';
import 'package:gucy/pages/create_post_page.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'nav_bar.dart';
import 'tab_bar_views.dart';
import 'tab_bars.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold>
    with TickerProviderStateMixin {
  int _currentPageIndex = 0;
  int _currentInnerPageIndex = 0;
  var tabControllers = <TabController>[];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < tabBars.length; i++) {
      tabControllers.add(TabController(vsync: this, length: tabBars[i].length));
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < tabControllers.length; i++) {
      tabControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      drawer: const Drawer(
        child: MainDrawer(),
      ),
      appBar: AppBar(
          title: const Text('Gucy'),
          bottom: TabBar(
            controller: tabControllers[_currentPageIndex],
            tabs: tabBars[_currentPageIndex],
            onTap: (value) => setState(() {
              _currentInnerPageIndex = value;
            }),
          )),
      body: TabBarView(
        controller: tabControllers[_currentPageIndex],
        children: tabBarViews[_currentPageIndex],
      ),
      floatingActionButton: (_currentPageIndex == 0 ||
              (_currentPageIndex == 1 && _currentInnerPageIndex == 1))
          ? FloatingActionButton(
              onPressed: () async {
                if ((_currentPageIndex == 0 && _currentInnerPageIndex == 0)) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreatePostPage("confession")));
                } else if (_currentPageIndex == 0 &&
                    _currentInnerPageIndex == 1) {
                  if (userProvider.user["eventPermission"] == "None") {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'You do not have permission to post events!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreatePostPage("event")));
                  }
                } else if (_currentPageIndex == 0 &&
                    _currentInnerPageIndex == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreatePostPage("lost and found")));
                } else if (_currentPageIndex == 1 &&
                    _currentInnerPageIndex == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreatePostPage("question")));
                }
              },
              child: const Icon(Icons.edit),
            )
          : null,
      bottomNavigationBar: NavBar(
        currentPageIndex: _currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
            _currentInnerPageIndex = tabControllers[_currentPageIndex].index;
          });
        },
      ),
    );
  }
}
