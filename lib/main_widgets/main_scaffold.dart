import 'package:flutter/material.dart';
import 'package:gucy/main_widgets/main_drawer.dart';
import 'package:gucy/pages/create_post_page.dart';
import 'package:gucy/providers/analytics_provider.dart';
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

  Future<void> _requestPermission(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user?.eventPermission == 'None') {
      userProvider.user?.eventPermission = 'requested';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Requesting Permission...'),
              ],
            ),
          );
        },
        barrierDismissible: false,
      );
      await userProvider.updateUser(userProvider.user!);

      // Show a snack bar indicating that the permission was requested
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Permission requested. Currently pending.'),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    Navigator.pop(context); // Close the existing dialog
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: true);
    return Scaffold(
      drawer: const Drawer(
        child: MainDrawer(),
      ),
      appBar: AppBar(
          title: const Text('Gucy'),
          bottom: TabBar(
            isScrollable: true,
            controller: tabControllers[_currentPageIndex],
            tabs: tabBars[_currentPageIndex],
            onTap: (value) => setState(() {
              _currentInnerPageIndex = value;

              if ((_currentPageIndex == 0 && _currentInnerPageIndex == 0)) {
                analyticsProvider.changePage(
                    'Confessions', userProvider.user!.uid);
              } else if (_currentPageIndex == 0 &&
                  _currentInnerPageIndex == 1) {
                analyticsProvider.changePage('Events', userProvider.user!.uid);
              } else if (_currentPageIndex == 0 &&
                  _currentInnerPageIndex == 2) {
                analyticsProvider.changePage(
                    'Lost and Found', userProvider.user!.uid);
              } else if (_currentPageIndex == 1 &&
                  _currentInnerPageIndex == 1) {
                analyticsProvider.changePage(
                    'Questions', userProvider.user!.uid);
              } else {
                analyticsProvider.changePage('Other', userProvider.user!.uid);
              }
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
                  if (userProvider.user?.eventPermission != "All" &&
                      userProvider.user?.eventPermission != "accepted") {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Permession Required'),
                          content: Text(userProvider.user?.eventPermission ==
                                  "None"
                              ? 'You do not have permission to post events!'
                              : userProvider.user?.eventPermission ==
                                      "requested"
                                  ? 'Permission already requested and is currently pending.'
                                  : 'Sorry your recent request has been rejected by the admin. If you have any questions or concerns, please contact our support team'),
                          actions: <Widget>[
                            userProvider.user?.eventPermission == "None"
                                ? TextButton(
                                    onPressed: () async {
                                      try {
                                        await _requestPermission(context);
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              'Failed to post. Please try again later.'),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Request Permission'),
                                  )
                                : Container(),
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
        onDestinationSelected: (int index) async {
          setState(() {
            _currentPageIndex = index;
            _currentInnerPageIndex = tabControllers[_currentPageIndex].index;
          });

          if ((_currentPageIndex == 0 && _currentInnerPageIndex == 0)) {
            analyticsProvider.changePage('Confessions', userProvider.user!.uid);
          } else if (_currentPageIndex == 0 && _currentInnerPageIndex == 1) {
            analyticsProvider.changePage('Events', userProvider.user!.uid);
          } else if (_currentPageIndex == 0 && _currentInnerPageIndex == 2) {
            analyticsProvider.changePage(
                'Lost and Found', userProvider.user!.uid);
          } else if (_currentPageIndex == 1 && _currentInnerPageIndex == 1) {
            analyticsProvider.changePage('Questions', userProvider.user!.uid);
          } else {
            analyticsProvider.changePage('Other', userProvider.user!.uid);
          }
        },
      ),
    );
  }
}
