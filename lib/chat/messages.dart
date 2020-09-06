import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:windson/chat/message_bubble.dart';

class Messages extends StatefulWidget {
  final chatDocument;
  Messages(this.chatDocument);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Future<String> getCurrentUser() async {
    return (await FirebaseAuth.instance.currentUser()).uid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getCurrentUser(),
        builder: (context, futureSnapshot) => StreamBuilder(
            stream: Firestore.instance
                .collection('/ChatRooms')
                .document(widget.chatDocument)
                .collection('Messages')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final document = snapshot.data.documents;
              return ListView.builder(
                  reverse: true,
                  itemCount: document.length,
                  itemBuilder: (ctx, index) => Container(
                        padding: EdgeInsets.all(8),
                        child: document[index]['from'] == 'key'
                            ? Center(
                                child: Text(
                                'Tap below to start typing',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ))
                            : MessageBubble(document[index]['text'],
                                document[index]['from'] == futureSnapshot.data),
                      ));
            }),
      ),
    );
  }
}
