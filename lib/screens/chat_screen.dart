import 'package:flutter/material.dart';
import 'package:windson/chat/messages.dart';
import 'package:windson/chat/new_message.dart';
import 'package:windson/screens/home_page.dart';

class ChatScreen extends StatelessWidget {
  final chatDocument;
  final userId;
  ChatScreen(this.chatDocument, this.userId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false),
        child: Container(
            child: Column(
          children: <Widget>[
            Expanded(child: Messages(chatDocument)),
            NewMessage(chatDocument, userId),
          ],
        )),
      ),

      // floatingActionButton: FloatingActionButton(
      //     onPressed: () => Firestore.instance
      //         .collection('/ChatRooms/PavanPappaChat/Messages')
      //         .add({'message': 'Is working now !'}),
      //     child: Icon(Icons.add)),
    );
  }
}
