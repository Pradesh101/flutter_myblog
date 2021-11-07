import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myblog/app_screens/authentic_screen.dart';
import 'package:myblog/app_screens/home_screen.dart';
import 'package:myblog/widgets/loading_widget.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          Object? user = snapshot.data;
          if(user==null)
            return AuthenticScreen();
          return HomeScreen();
        }
        else{
          return Scaffold(
            body: Center(
              child: circularProgressBar(),
            ),
          );
        }
      },
    );
  }
}
