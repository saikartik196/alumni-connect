import 'dart:developer';

import 'package:alumni_connect/screens/bottom_navigator_bar.dart';
import 'package:alumni_connect/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../api/apis.dart';
import 'auth/login_screen.dart';
import 'message_screen.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        //navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const BottomNav()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //body
      body: Stack(children: [
        //app logo
        Positioned(
          top: mq.height * .15,
          right: mq.width * .25,
          width: mq.width * .5,
          child: Image.asset(
            'images/logo.png',
            fit: BoxFit
                .contain, // Use BoxFit.contain to fit within the specified width and height while maintaining aspect ratio
          ),
        ),

        //google login button
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text('Let\s connect!!!! ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, color: Colors.black87, letterSpacing: .5))),
      ]),
    );
  }
}
