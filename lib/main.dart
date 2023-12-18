import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gucy/main_widgets/main_scaffold.dart';
import 'package:gucy/pages/login_signup_page.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/posts_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.delayed(const Duration(seconds: 2));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PostsProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => AnalyticsProvider()),
    ],
    child: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  bool isScrolling = false; // Variable to track scrolling state

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final isBackground = state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached;

    final userProvider = Provider.of<UserProvider>(context);
    final analyticsProvider = Provider.of<AnalyticsProvider>(context);
    if (isBackground) {
      analyticsProvider.changePage('None', userProvider.user!.uid);
    } else {
      analyticsProvider.changePage('Confessions', userProvider.user!.uid);
    }
  }

  void handleScrollStart() {
    // Function to execute when scrolling starts
    setState(() {
      isScrolling = true;
    });
    print("Scrolling started");
    // Add your code here
  }

  void handleScrollEnd() {
    // Function to execute when scrolling stops
    setState(() {
      isScrolling = false;
    });
    print("Scrolling stopped");
    // Add your code here
  }

  Widget build(BuildContext context) {
    final analyticsProvider = Provider.of<AnalyticsProvider>(context);
    final userP = Provider.of<UserProvider>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final _router = GoRouter(
      redirect: (context, state) {
        final userProvider = Provider.of<UserProvider>(context);
        if (!userProvider.isAuthenticated) {
          return '/';
        }

        return '/mainScaffold';
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/mainScaffold',
          builder: (context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollStartNotification) {
                  analyticsProvider.setScrolling(true, userP.user!.uid);
                } else if (scrollInfo is ScrollEndNotification) {
                  analyticsProvider.setScrolling(false, userP.user!.uid);
                }
                return false;
              },
              child: const MainScaffold(),
            );
          },
        )
      ],
    );
    return MaterialApp.router(
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: _router,
    );
  }
}
