import 'package:flutter/material.dart';
import 'package:gucy/main_widgets/main_drawer.dart';
import 'package:gucy/pages/contacts_page.dart';
import 'package:gucy/pages/create_post_page.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../pages/outlets_page.dart';
import '../pages/staff_page.dart';
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
  var tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: tabBars[0].length);
  }

  @override
  void dispose() {
    tabController.dispose();
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

  String actionBeforeDrawer = "";
  String pageBeforeDrawer = "";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: true);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollStartNotification) {
          analyticsProvider.setScrolling(true,
              tabBars[0][_currentInnerPageIndex].text!, userProvider.user!.uid);
        } else if (scrollInfo is ScrollEndNotification) {
          analyticsProvider.setScrolling(false,
              tabBars[0][_currentInnerPageIndex].text!, userProvider.user!.uid);
        }
        return false;
      },
      child: Scaffold(
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            setState(() {
              if ((_currentPageIndex == 0 && _currentInnerPageIndex == 0)) {
                actionBeforeDrawer = "Viewing Home";
                pageBeforeDrawer = 'Home';
              } else if ((_currentPageIndex == 0 &&
                  _currentInnerPageIndex == 1)) {
                actionBeforeDrawer = "Viewing Confessions";
                pageBeforeDrawer = 'Confessions';
              } else if (_currentPageIndex == 0 &&
                  _currentInnerPageIndex == 2) {
                actionBeforeDrawer = "Viewing Events";
                pageBeforeDrawer = 'Events';
              } else if (_currentPageIndex == 0 &&
                  _currentInnerPageIndex == 3) {
                actionBeforeDrawer = "Viewing Lost and Found";
                pageBeforeDrawer = 'Lost and Found';
              } else if (_currentPageIndex == 0 &&
                  _currentInnerPageIndex == 4) {
                actionBeforeDrawer = "Viewing Questions";
                pageBeforeDrawer = 'Questions';
              } else {
                actionBeforeDrawer = "Viewing Other";
                pageBeforeDrawer = 'Other';
              }
            });

            analyticsProvider.changeAction(
                "Viewing Profile", userProvider.user!.uid);
            analyticsProvider.changePage('Profile', userProvider.user!.uid);
          } else {
            analyticsProvider.changeAction(
                actionBeforeDrawer, userProvider.user!.uid);
            analyticsProvider.changePage(
                pageBeforeDrawer, userProvider.user!.uid);
          }
        },
        drawer: const Drawer(
          child: MainDrawer(),
        ),
        appBar: AppBar(
            title: const Text('Gucy'),
            bottom: _currentPageIndex == 0
                ? TabBar(
                    isScrollable: true,
                    controller: tabController,
                    tabs: tabBars[_currentPageIndex],
                    onTap: (value) => setState(() {
                      _currentInnerPageIndex = value;
                      if ((_currentPageIndex == 0 &&
                          _currentInnerPageIndex == 0)) {
                        analyticsProvider.changeAction(
                            "Viewing Home", userProvider.user!.uid);
                        analyticsProvider.changePage(
                            'Home', userProvider.user!.uid);
                      } else if ((_currentPageIndex == 0 &&
                          _currentInnerPageIndex == 1)) {
                        analyticsProvider.changeAction(
                            "Viewing Confessions", userProvider.user!.uid);
                        analyticsProvider.changePage(
                            'Confessions', userProvider.user!.uid);
                      } else if (_currentPageIndex == 0 &&
                          _currentInnerPageIndex == 2) {
                        analyticsProvider.changeAction(
                            "Viewing Events", userProvider.user!.uid);
                        analyticsProvider.changePage(
                            'Events', userProvider.user!.uid);
                      } else if (_currentPageIndex == 0 &&
                          _currentInnerPageIndex == 3) {
                        analyticsProvider.changeAction(
                            "Viewing Lost and Found", userProvider.user!.uid);
                        analyticsProvider.changePage(
                            'Lost and Found', userProvider.user!.uid);
                      } else if (_currentPageIndex == 0 &&
                          _currentInnerPageIndex == 4) {
                        analyticsProvider.changeAction(
                            "Viewing Questions", userProvider.user!.uid);
                        analyticsProvider.changePage(
                            'Questions', userProvider.user!.uid);
                      } else {
                        analyticsProvider.changeAction(
                            "Viewing Other", userProvider.user!.uid);
                        analyticsProvider.changePage(
                            'Other', userProvider.user!.uid);
                      }
                    }),
                  )
                : null),
        body: [
          TabBarView(
            controller: tabController,
            children: tabBarViews[0],
          ),
          StaffPage(),
          OutletPage(),
        ][_currentPageIndex],
        floatingActionButton: (_currentPageIndex == 0 &&
                _currentInnerPageIndex != 0)
            ? FloatingActionButton(
                onPressed: () async {
                  if ((_currentPageIndex == 0 && _currentInnerPageIndex == 1)) {
                    analyticsProvider.changeAction(
                        "Adding Confession", userProvider.user!.uid);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreatePostPage("confession")));
                  } else if (_currentPageIndex == 0 &&
                      _currentInnerPageIndex == 2) {
                    if (userProvider.user?.eventPermission != "Home" &&
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
                      analyticsProvider.changeAction(
                          "Adding Event", userProvider.user!.uid);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreatePostPage("event")));
                    }
                  } else if (_currentPageIndex == 0 &&
                      _currentInnerPageIndex == 3) {
                    analyticsProvider.changeAction(
                        "Adding Lost and Found", userProvider.user!.uid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CreatePostPage("lost and found")));
                  } else if (_currentPageIndex == 0 &&
                      _currentInnerPageIndex == 4) {
                    analyticsProvider.changeAction(
                        "Adding Question", userProvider.user!.uid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreatePostPage("question")));
                  }else if (_currentPageIndex == 2) {
                    analyticsProvider.changeAction(
                        "Adding Question", userProvider.user!.uid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ContactsPage()));
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
              _currentInnerPageIndex = tabController.index;
            });

            if ((_currentPageIndex == 0 && _currentInnerPageIndex == 0)) {
              analyticsProvider.changeAction(
                  "Viewing Home", userProvider.user!.uid);
              analyticsProvider.changePage('Home', userProvider.user!.uid);
            } else if ((_currentPageIndex == 0 &&
                _currentInnerPageIndex == 1)) {
              analyticsProvider.changeAction(
                  "Viewing Confessions", userProvider.user!.uid);
              analyticsProvider.changePage(
                  'Confessions', userProvider.user!.uid);
            } else if (_currentPageIndex == 0 && _currentInnerPageIndex == 2) {
              analyticsProvider.changeAction(
                  "Viewing Events", userProvider.user!.uid);
              analyticsProvider.changePage('Events', userProvider.user!.uid);
            } else if (_currentPageIndex == 0 && _currentInnerPageIndex == 3) {
              analyticsProvider.changeAction(
                  "Viewing Lost and Found", userProvider.user!.uid);
              analyticsProvider.changePage(
                  'Lost and Found', userProvider.user!.uid);
            } else if (_currentPageIndex == 0 && _currentInnerPageIndex == 4) {
              analyticsProvider.changeAction(
                  "Viewing Questions", userProvider.user!.uid);
              analyticsProvider.changePage('Questions', userProvider.user!.uid);
            } else {
              analyticsProvider.changeAction(
                  "Viewing Other", userProvider.user!.uid);
              analyticsProvider.changePage('Other', userProvider.user!.uid);
            }
          },
        ),
      ),
    );
  }
}
