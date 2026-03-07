


import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:mystery_pixels/screens/admin_dashboard_screen.dart';
import 'firebase_options.dart';
import 'package:mystery_pixels/providers/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'screens/registration_screen.dart';
import 'screens/game_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PlayerProvider(),
        ),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "4 Day Mystery Challenge",
        initialRoute: "/",
        routes: {
          "/": (context) => RegistrationScreen(),
          "/game": (context) => GameScreen(),
          "/admin" : (context) => AdminDashboardScreen()
        },
        theme: ThemeData(
          primaryColor: Colors.orangeAccent,
          scaffoldBackgroundColor: const Color(0xFFF4F6FA),
        ),
      ),
    );
  }
}