import 'package:flutter/material.dart';
import 'package:gucy/main_widgets/main_drawer.dart';
import 'package:gucy/pages/contacts_page.dart';
import 'package:gucy/pages/create_post_page.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../pages/outlets_page.dart';
import '../pages/post_pages/confessions_page.dart';
import '../pages/post_pages/events_page.dart';
import '../pages/post_pages/home_page.dart';
import '../pages/post_pages/lost_and_found_page.dart';
import '../pages/post_pages/questions_page.dart';
import '../pages/staff_page.dart';
import 'nav_bar.dart';
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
  late TabController tabController;

  // Add the listener
  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: tabBars[0].length);

    // Add the listener
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        // The tab index change is complete
        setState(() {
          _currentInnerPageIndex = tabController.index;
          // Update analytics or any other necessary state here
        });
      }
    });
  }

  @override
  void dispose() {
    tabController.removeListener(() {}); // Remove the listener
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
  String _sortingCriteria = "createdAt";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: true);
    return Scaffold(
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
            } else if (_currentPageIndex == 0 && _currentInnerPageIndex == 2) {
              actionBeforeDrawer = "Viewing Events";
              pageBeforeDrawer = 'Events';
            } else if (_currentPageIndex == 0 && _currentInnerPageIndex == 3) {
              actionBeforeDrawer = "Viewing Lost and Found";
              pageBeforeDrawer = 'Lost and Found';
            } else if (_currentPageIndex == 0 && _currentInnerPageIndex == 4) {
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
          // actions: [
          //   if (_currentPageIndex == 0)
          //     PopupMenuButton<String>(
          //       onSelected: (value) {
          //         setState(() {
          //           _sortingCriteria = value;
          //         });
          //         print('Selected sorting option: $value');
          //       },
          //       itemBuilder: (BuildContext context) => [
          //         PopupMenuItem<String>(
          //           value: 'createdAt',
          //           child: const Text('Sort by Date'),
          //         ),
          //         PopupMenuItem<String>(
          //           value: 'likes',
          //           child: const Text('Sort by Likes'),
          //         ),
          //         PopupMenuItem<String>(
          //           value: 'score',
          //           child: const Text('Sort by Guciness'),
          //         ),
          //       ],
          //     ),
          // ],
          bottom: _currentPageIndex == 0
              ? TabBar(
                  tabAlignment: TabAlignment.center,
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
          children: [
            HomePage(
              sortingCriteria: _sortingCriteria,
            ),
            ConfessionsPage(
              sortingCriteria: _sortingCriteria,
            ),
            EventsPage(
              sortingCriteria: _sortingCriteria,
            ),
            LostAndFoundPage(
              sortingCriteria: _sortingCriteria,
            ),
            QuestionsPage(
              sortingCriteria: _sortingCriteria,
            ),
          ],
        ),
        StaffPage(),
        OutletPage(),
      ][_currentPageIndex],
      floatingActionButton: ((_currentPageIndex == 0 &&
                  _currentInnerPageIndex != 0) ||
              (_currentPageIndex == 2))
          ? FloatingActionButton(
              onPressed: () async {
                if ((_currentPageIndex == 0 && _currentInnerPageIndex == 1)) {
                  analyticsProvider.changeAction(
                      "Adding Confession", userProvider.user!.uid);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreatePostPage("Confession")));
                } else if (_currentPageIndex == 0 &&
                    _currentInnerPageIndex == 2) {
                  if (userProvider.user?.eventPermission != "Home" &&
                      userProvider.user?.eventPermission != "accepted") {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Permission Required'),
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
                        builder: (context) => CreatePostPage("Event")));
                  }
                } else if (_currentPageIndex == 0 &&
                    _currentInnerPageIndex == 3) {
                  analyticsProvider.changeAction(
                      "Adding Lost and Found", userProvider.user!.uid);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreatePostPage("LostAndFound")));
                } else if (_currentPageIndex == 0 &&
                    _currentInnerPageIndex == 4) {
                  analyticsProvider.changeAction(
                      "Adding Question", userProvider.user!.uid);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreatePostPage("Question")));
                } else if (_currentPageIndex == 2) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ContactsPage()));
                }
              },
              child: _currentPageIndex == 2
                  ? const Icon(Icons.call)
                  : const Icon(Icons.edit),
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
          } else if ((_currentPageIndex == 0 && _currentInnerPageIndex == 1)) {
            analyticsProvider.changeAction(
                "Viewing Confessions", userProvider.user!.uid);
            analyticsProvider.changePage('Confessions', userProvider.user!.uid);
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
    );
  }
}
