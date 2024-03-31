import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_messenger/models/chat_user.dart';
import '../api/apis.dart';
import '../main.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
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
        body: StreamBuilder(
            stream: APIs.firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //tells whether data is loading of already loaded
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                //if some or all data is loaded then
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                        padding: EdgeInsets.only(top: mq.height * 0.02),
                        itemCount: list
                            .length, //API call here to get the number of users
                        physics:
                            const BouncingScrollPhysics(), //This adds the bouncing effect to the scroll
                        itemBuilder: (context, index) {
                          return ChatUserCard(user: list[index]);
                          // return Text("Name: ${list[index]}");
                        });
                  } else {
                    return const Center(
                      child: Text(
                        "No connections Found!",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
              }
            }));
  }
}
