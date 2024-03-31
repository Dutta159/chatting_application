import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          //This is a user profile picture
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
          //User name
          title: Text("Demo User"),
          //last message
          subtitle: Text(
            "Last User Message",
            maxLines: 1,
          ),
          //last seen
          trailing: Text(
            "12:00 PM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
