import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myblog/app_screens/authentic_screen.dart';
import 'package:myblog/app_screens/landing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Blog',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const LandingScreen(),
    );
  }
}


