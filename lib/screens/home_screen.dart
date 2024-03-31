import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_messenger/widgets/chat_user_card.dart';

import '../api/apis.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //This is the app_bar
        appBar: AppBar(
          leading: const Icon(Icons.home),
          title: const Text(
            "Buddy Chat",
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        //This is the bottom floating action button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 5),
          child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.message)),
        ),
        //list builder shows the list dynamically and optimizes the memory
        body: ListView.builder(
            padding: EdgeInsets.only(top: mq.height * 0.02),
            itemCount: 18, //API call here to get the number of users
            physics:
                const BouncingScrollPhysics(), //This adds the bouncing effect to the scroll
            itemBuilder: (context, index) {
              return const ChatUserCard();
            }));
  }
}
