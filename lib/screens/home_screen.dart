import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_messenger/models/chat_user.dart';
import '../api/apis.dart';
import '../main.dart';
import '../widgets/chat_user_card.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
//for storing searched items
  final List<ChatUser> _searchList = [];
//for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //This is the app_bar
        appBar: AppBar(
          leading: const Icon(Icons.home),
          title: _isSearching
              ? TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Name, Email,..."),
                  autofocus:
                      true, //this will automatically move the cursor on the textfield after the seearch button is clicked
                  style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                  //when search field changes the updated search list
                  onChanged: (val) {
                    //search logic
                    _searchList.clear();
                    for (var i in _list) {
                      if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                          i.email.toLowerCase().contains(val.toLowerCase())) {
                        _searchList.add(i);
                      }
                      setState(() {
                        _searchList;
                      });
                    }
                  },
                )
              : const Text(
                  "Buddy Chat",
                ),
          actions: [
            //button for searching the users
            IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching ? CupertinoIcons.clear : Icons.search)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: APIs.me)));
                },
                icon: const Icon(Icons.more_vert))
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
            stream: APIs.getAllUsers(),
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
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        padding: EdgeInsets.only(top: mq.height * 0.02),
                        itemCount: _isSearching
                            ? _searchList.length
                            : _list
                                .length, //API call here to get the number of users
                        physics:
                            const BouncingScrollPhysics(), //This adds the bouncing effect to the scroll
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index]);
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
