import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:windson/screens/connect_user_screen.dart';
import 'package:windson/widgets/chats_list.dart';
import 'package:windson/screens/chat_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userUID;
  String userName;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    getUserUid().then((value) {
      userUID = value;
      setState(() {});
    });
  }

  Future<String> getUserUid() async {
    return (await FirebaseAuth.instance.currentUser()).uid;
  }

  // void newUserChatSreen(chatDocument, userUid) {
  //   setState(() {

  //   });

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => ChatScreen(chatDocument, userUid)),
  //   );
  // }

  startNewChat(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: ConnectUser());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: false,
        title: Text(
          'WIND',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(Icons.more_vert, color: Theme.of(context).primaryColor),
            items: [
              DropdownMenuItem(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '=> LOGOUT',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        Icon(Icons.exit_to_app,
                            color: Theme.of(context).primaryColor),
                      ],
                    ),
                  ),
                  value: 'logout'),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: ChatsList(userUID)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startNewChat(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
