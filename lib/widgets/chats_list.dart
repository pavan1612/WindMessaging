import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:windson/screens/chat_screen.dart';

class ChatsList extends StatefulWidget {
  final userUID;

  ChatsList(this.userUID);
  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  Future<String> otherPerson(doc) {
    List<dynamic> newList = doc['userId'];
    String personid = '';
    newList.forEach((element) {
      if (element != widget.userUID) {
        personid = element.toString();
      }
    });
    return Firestore.instance
        .collection('Users')
        .document(personid)
        .get()
        .then((value) => value.data['username']);
  }

  Future<String> getLastTextMessage(path) {
    return Firestore.instance
        .collection('ChatRooms')
        .document(path)
        .collection('Messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .getDocuments()
        .then((value) => value.documents[0]['text']);
  }

  Future getLastTextMessageTime(path) {
    return Firestore.instance
        .collection('ChatRooms')
        .document(path)
        .collection('Messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .getDocuments()
        .then((value) => value.documents[0]['createdAt'].toDate());
  }

  void chatScreen(doc) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(doc, widget.userUID)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('ChatRooms')
            .where("userId", arrayContains: widget.userUID)
            .snapshots(),
        builder: (context, documentSnapshot) {
          if (documentSnapshot == null) {
            return Center(
              child: Text(
                'No conversations. Tap + to add .',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            );
          }
          if (documentSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            var document = documentSnapshot.data.documents;
            print(widget.userUID);
            print(document.length);
            return ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              // shrinkWrap: true,
              itemCount: document.length,
              itemBuilder: (context, index) => Card(
                color: Theme.of(context).backgroundColor,
                elevation: 5,
                child: InkWell(
                  onTap: () =>
                      chatScreen(document[index].documentID.toString()),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FutureBuilder(
                                future: otherPerson(document[index]),
                                builder: (context, personsnapshot) {
                                  return Text(
                                    '=> ' + personsnapshot.data.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection('ChatRooms')
                                    .document(
                                        document[index].documentID.toString())
                                    .collection('Messages')
                                    .orderBy('createdAt', descending: true)
                                    .snapshots(),
                                builder: (context, messagesnapshot) {
                                  if (messagesnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else
                                    return Text(
                                      messagesnapshot.data.documents[0]['text']
                                          .toString(),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    );
                                },
                              )

                              // FutureBuilder(
                              //   future: getLastTextMessage(
                              //       document[index].documentID.toString()),
                              //   builder: (context, messagesnapshot) {
                              //     if (messagesnapshot.data == null) {
                              //       return Container(child: Text(''));
                              //     }
                              //     return Text(
                              //       messagesnapshot.data.toString(),
                              //       style: TextStyle(
                              //           color: Theme.of(context).accentColor),
                              //     );
                              //   },
                              // ),
                            ],
                          )),
                          Container(
                            child: FutureBuilder(
                              future: getLastTextMessageTime(
                                  document[index].documentID.toString()),
                              builder: (context, timesnapshot) {
                                print(timesnapshot.data.toString());
                                if (timesnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (timesnapshot.data == null) {
                                  return Container(child: Text(''));
                                }
                                // if (snapshot.connectionState !=
                                //     ConnectionState.waiting) {
                                // else
                                else
                                  return Container(
                                    child: Text(
                                      DateFormat.jm()
                                          .add_MEd()
                                          .format(timesnapshot.data),
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                  );
                                // }
                                // return Center(child: CircularProgressIndicator());
                              },
                            ),
                          )
                        ],
                      )

                      // ListTile(
                      //   title: FutureBuilder(
                      //     future: otherPerson(document[index]),
                      //     builder: (context, personsnapshot) {
                      //       return Text(
                      //         '=> ' + personsnapshot.data.toString(),
                      //         style:
                      //             TextStyle(color: Theme.of(context).primaryColor),
                      //       );
                      //     },
                      //   ),
                      //   subtitle: FutureBuilder(
                      //     future: getLastTextMessage(
                      //         document[index].documentID.toString()),
                      //     builder: (context, messagesnapshot) {
                      //       return Text(
                      //         messagesnapshot.data.toString(),
                      //         style:
                      //             TextStyle(color: Theme.of(context).accentColor),
                      //       );
                      //     },
                      //   ),
                      //   trailing: FutureBuilder(
                      //     future: getLastTextMessageTime(
                      //         document[index].documentID.toString()),
                      //     builder: (context, timesnapshot) {
                      //       if (timesnapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return Center(child: CircularProgressIndicator());
                      //       }
                      //       // if (snapshot.connectionState !=
                      //       //     ConnectionState.waiting) {
                      //       else
                      //         return Container(
                      //           child: Flexible(
                      //             child: Text(
                      //               DateFormat.yMd()
                      //                   .add_jm()
                      //                   .format(timesnapshot.data),
                      //               style: TextStyle(
                      //                   color: Theme.of(context).accentColor),
                      //             ),
                      //           ),
                      //         );
                      //       // }
                      //       // return Center(child: CircularProgressIndicator());
                      //     },
                      //   ),
                      //   onTap: () =>
                      //       chatScreen(document[index].documentID.toString()),
                      // ),
                      ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
