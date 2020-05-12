import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Shared/chat_page.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/colors.dart';

class NotificationPage extends StatefulWidget {
  final User user;
  const NotificationPage({@required this.user});

  @override
  _NotificationPageState createState() =>
      _NotificationPageState(user: this.user);
}

class _NotificationPageState extends State<NotificationPage> {
  final User user;
  _NotificationPageState({this.user});
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30.0
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Chats',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 30, fontFamily: 'Lato'),
              ),
            ),
            SizedBox(
              height: 30.0
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  // List
                  Container(
                    child: StreamBuilder(
                      stream: Firestore.instance.collection('chats').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              for(int i=0; i<3 ; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                                child: Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        width: 50,
                                        margin: EdgeInsets.only(left: 30),
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(100)
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ),
                            ],
                          );
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) => buildItem(
                                context, snapshot.data.documents[index], user),
                            itemCount: snapshot.data.documents.length,
                          );
                        }
                      },
                    ),
                  ),
                  // Loading
                  Positioned(
                    child: isLoading
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.workiColor)),
                            ),
                            color: Colors.white.withOpacity(0.8),
                          )
                        : Container(),
                  )
                ],
              ),
            ),
          ],
        ),
        //onWillPop: onBackPress,
      ),
    );
  }
}

Widget buildItem(BuildContext context, DocumentSnapshot document, User user) {
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  return FutureBuilder(
    future: firestoreProvider.getMemberListChat(document.documentID, user.id),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData && snapshot.data.documents.length > 0) {
        return Container(
          decoration: ButtonDecoration.workiButton,
          child: FlatButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: document['profilePic'] != null
                      ? CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(15.0),
                          ),
                          imageUrl: document['profilePic'],
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            document['groupName'].toString().toUpperCase(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                          chatKey: document.documentID,
                          profilePic: document['profilePic'],
                          user: user)));
            },
            padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          ),
        );
      } else {
        return Text('');
      }
    },
  );
}

void createRecord() async {
  DocumentReference ref = await Firestore.instance.collection("users").add({
    'email': 'Flutter in Action',
  });
  print(ref.documentID);
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
