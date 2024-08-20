
import 'package:chatapp/widget/chat_message.dart';
import 'package:chatapp/widget/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Flutter Chat'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon : Icon(
                Icons.exit_to_app,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
        body: Column(children: [ChatMessage(),NewMessage()],)
    );
  }
}