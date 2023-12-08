import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gucy/main_widgets/main_scaffold.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gucy/pages/login_signup_page.dart';
import 'package:gucy/providers/posts_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => PostsProvider()),
  ], child: MainApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginPage(),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: _router,
    );
  }
}
