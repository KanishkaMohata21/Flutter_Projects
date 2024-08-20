import 'package:chatapp/widget/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').snapshots(),
        builder: (ctx, chatShapshots) {
          if (chatShapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (chatShapshots.hasData || chatShapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No message found'),
            );
          }
          if (chatShapshots.hasError) {
            return Text('Error: ${chatShapshots.error}');
          }
          final chatDocs = chatShapshots.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(
                bottom: 40, left: BorderSide.strokeAlignCenter),
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) {
              final ChatMessage = chatDocs[index].data();
              final nextChatMessage = index + 1 < chatDocs.length
                  ? chatDocs[index + 1].data()
                  : null;
              final currentMessageUserId = ChatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;
              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: ChatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId);
              } else {
                return MessageBubble.first(
                    image: ChatMessage['image'],
                    username: ChatMessage['username'],
                    message: ChatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId);
              }
            },
          );
        });
  }
}
