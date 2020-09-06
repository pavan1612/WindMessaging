import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windson/screens/chat_screen.dart';

class ConnectUser extends StatefulWidget {
  // Function newUserChatSreen;

  // ConnectUser(this.newUserChatSreen);

  @override
  _ConnectUserState createState() => _ConnectUserState();
}

class _ConnectUserState extends State<ConnectUser> {
  String chatDocument;
  String userUid;
  bool checkEmail;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    getUserUid().then((value) {
      userUid = value;
      setState(() {
        checkEmail = true;
      });
    });
  }

  Future<String> getUserUid() async {
    return (await FirebaseAuth.instance.currentUser()).uid;
  }

  var _enteredEmailText = '';

  Future<bool> checkEmailExists() async {
    var doc = (await Firestore.instance
        .collection('Users')
        .where('email', isEqualTo: _enteredEmailText)
        .getDocuments());

    if (doc.documents.length == 0)
      return false;
    else
      return true;
  }

  Future<bool> addChatRoom() async {
    var choosenUserDoc = (await Firestore.instance
        .collection('Users')
        .where('email', isEqualTo: _enteredEmailText)
        .getDocuments());

    if (choosenUserDoc.documents == null) {
      return false;
    } else {
      var choosenUser = '';
      choosenUserDoc.documents.forEach((element) {
        choosenUser = element.documentID;
      });
      try {
        await Firestore.instance.collection('ChatRooms').add({
          'userId': [userUid, choosenUser],
          'createdTime': DateTime.now()
        }).then((value) async {
          var docs = (await Firestore.instance
              .collection('ChatRooms')
              // .where('userId', arrayContains: userUid)
              .where('userId', arrayContains: userUid)
              .orderBy('createdTime', descending: true)
              .limit(1)
              .getDocuments());
          docs.documents.forEach((element) {
            chatDocument = element.documentID;
            print('chatDocument');
            print(chatDocument);
          });
        });

        Firestore.instance
            .collection('ChatRooms')
            .document(chatDocument)
            .collection('Messages')
            .document()
            .setData({'createdAt': DateTime.now(), 'from': 'key', 'text': ''});

        return true;
      } on PlatformException catch (err) {
        print(err.message);
        return false;
      }
    }
  }

  void startChat(context) {
    checkEmailExists().then((value) async {
      if (value) {
        bool success = await addChatRoom();
        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(chatDocument, userUid)),
          );

          // Navigator.pop(context);
          // widget.newUserChatSreen(chatDocument, userUid);
        }
      } else {
        setState(() {
          checkEmail = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  FutureBuilder(
                      future: checkEmailExists(),
                      builder: (context, snapshot) {
                        return Container(
                          width: MediaQuery.of(context).size.width - 70,
                          child: TextField(
                            style: TextStyle(
                                color: checkEmail
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).errorColor),
                            decoration: InputDecoration(
                              labelText: checkEmail
                                  ? 'Chat with Email'
                                  : 'Email not found , Enter again.',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onChanged: (value) {
                              setState(() {
                                checkEmail = true;
                                _enteredEmailText = value;
                              });
                            },
                          ),
                        );
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => startChat(context)),
                ],
              ),
            ],
          )),
    );
  }
}
