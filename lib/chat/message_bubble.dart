import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final message;
  final isMe;
  MessageBubble(this.message, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).backgroundColor
                : Theme.of(context).primaryColor,
            border: Border.all(
                color: isMe
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(20),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(20)),
          ),
          width: 150,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Text(
            message,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isMe
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor),
          ),
        ),
      ],
    );
  }
}
