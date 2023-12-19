import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gucy/main_widgets/main_scaffold.dart';
import 'package:gucy/pages/login_signup_page.dart';
import 'package:gucy/providers/analytics_provider.dart';
import 'package:gucy/providers/posts_provider.dart';
import 'package:gucy/widgets/post.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    handleInitialUrl();
  }

  Future<void> handleInitialUrl() async {
    // Uri.base contains the initial URL if the app was launched via a deep link
    final initialUri = Uri.base;
    navigateBasedOnUrl(initialUri);
  }

  void navigateBasedOnUrl(Uri uri) {
    // Parse the URI and get the path and parameters
    String path = uri.path;
    Map<String, String> params = uri.queryParameters;

    // Example: Navigate to a specific widget based on the path
    if (path == '/post') {
      // Assuming you have a method to navigate
      // You can pass parameters if needed
      navigateToYourWidget(params);
    }
  }

  void navigateToYourWidget(Map<String, String> params) {
    // Use GoRouter or your preferred navigation method to navigate
    // Example:
    GoRouter.of(context).go('/post', extra: params);
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

    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final analyticsProvider = Provider.of<AnalyticsProvider>(context);
    if (isBackground) {
      analyticsProvider.changeAction('NotInsideApp', userProvider.user!.uid);
      analyticsProvider.changePage('None', userProvider.user!.uid);
    } else {
      analyticsProvider.changeAction('Viewing All', userProvider.user!.uid);
      analyticsProvider.changePage('All', userProvider.user!.uid);
    }
  }

  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final _router = GoRouter(
      redirect: (context, state) {
        if (!Provider.of<UserProvider>(context, listen: true).isAuthenticated) {
          return '/';
        } else {}

        return '/mainScaffold';
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/mainScaffold',
          builder: (context, state) => const MainScaffold(),
        ),
        GoRoute(
          path: '/post',
          builder: (context, state) {
            // Extract parameters from the state
            final params = state.pathParameters;
            final postId = params['id'];
            final postProvider =
                Provider.of<PostsProvider>(context, listen: true);
            final post = postProvider.getPostById(postId!);
            return Post(postData: post);
          },
        ),
      ],
    );
    return MaterialApp.router(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: userProvider.chosenColor,
              brightness: userProvider.brightness)),
      routerConfig: _router,
    );
  }
}
