import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final chatDocument;
  final userId;
  NewMessage(this.chatDocument, this.userId);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _textEntered = '';

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    Firestore.instance
        .collection('ChatRooms')
        .document(widget.chatDocument)
        .collection('Messages')
        .add({
      'text': _textEntered,
      'createdAt': DateTime.now(),
      'from': widget.userId
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Theme.of(context).primaryColor),
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: Theme.of(context).primaryColor),
                decoration: InputDecoration(
                    labelText: 'Type here',
                    labelStyle:
                        TextStyle(color: Theme.of(context).accentColor)),
                onChanged: (value) {
                  setState(() {
                    _textEntered = value;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: _textEntered.trim().isEmpty ? null : _sendMessage,
            )
          ],
        ));
  }
}
