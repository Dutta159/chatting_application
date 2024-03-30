// ignore_for_file: camel_case_types

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_messenger/screens/home_screen.dart';
import '../../main.dart';
import 'auth/login_screen.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (FirebaseAuth.instance.currentUser != null) {
        log('\nUser:${FirebaseAuth.instance.currentUser}');

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const login_screen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query to get screen size
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //This is the app_bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Welcome to Buddy Chat",
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            //This requires two attributes that are duration and child
            top: mq.height *
                .15, //this implies that size from top should be 15% of the screen
            width: mq.width * 0.5,
            //After adding the width this will give the left margin from the remaining 50% of the screen
            right: mq.width * .25,
            child: Image.asset("images/icon.png"),
          ),
          Positioned(
              bottom: mq.height *
                  .15, //this implies that size from top should be 15% of the screen
              width: mq.width,
              child: const Text(
                "Made in India with ❤️",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              )),
        ],
      ),
    );
  }
}
