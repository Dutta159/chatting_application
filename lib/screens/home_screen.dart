import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            onPressed: () {}, child: const Icon(Icons.message)),
      ),
    );
  }
}
