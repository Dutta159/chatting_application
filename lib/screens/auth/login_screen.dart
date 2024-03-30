// ignore_for_file: camel_case_types

import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../main.dart';
import '../home_screen.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  bool _isAnimate = false; //_means this is a private variable
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      //This delays the animation after the screen is loaded
      setState(() {
        _isAnimate = true;
      });
    });
  }

  // ignore: unused_element
  _handleGoogleBtnClick() {
    _signInWithGoogle().then((user) {
      if (user != null) {
        log('\nUser:${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    const HomeScreen())); //This is used because user should not return  to this screen after login
      }
    });
  }

  // ignore: unused_element, body_might_complete_normally_nullable
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log("_signInWithGoogle: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // mq = MediaQuery.of(context).size;
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
          AnimatedPositioned(
            //This requires two attributes that are duration and child
            duration: const Duration(milliseconds: 1000),
            top: mq.height *
                .15, //this implies that size from top should be 15% of the screen
            width: mq.width * 0.5,
            //After adding the width this will give the left margin from the remaining 50% of the screen
            right: _isAnimate ? mq.width * .25 : -mq.width * 0.5,
            child: Image.asset("images/icon.png"),
          ),
          Positioned(
            bottom: mq.height *
                .15, //this implies that size from top should be 15% of the screen
            width: mq.width * 0.9,
            //After adding the width this will give the left margin from the remaining 50% of the screen
            left: mq.width * 0.05,
            height: mq.height * 0.07,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(elevation: 1),
                onPressed: () {
                  _handleGoogleBtnClick();
                },
                icon: Image.asset(
                  "images/google.png",
                  height: mq.height * 0.04,
                ),
                label: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        children: [
                      TextSpan(text: "  Sign in with"),
                      TextSpan(
                          text: " Google",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]))),
          )
        ],
      ),
    );
  }
}
