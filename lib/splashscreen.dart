import 'package:staygo/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset('assets/logo.png'),
          Padding(padding: EdgeInsets.only(bottom: 20.0),),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      nextScreen: LoginPage(),
      splashIconSize: 150,
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
