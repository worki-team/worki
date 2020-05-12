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
  FirestoreProvider f = new FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Chats',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'Lato'),
              ),
            ),
            SizedBox(height: 30.0),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder(
                      future: f.chatsWithUserId(user.id),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    'assets/chat_undraw.png',
                                    fit: BoxFit.cover,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Parece que aún no tienes ninguna conversación',
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) => buildItem(snapshot.data[index],context,
                                 user),
                            itemCount: snapshot.data.length,
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
      ),
    );
  }
}

Widget buildItem(document, BuildContext context, User user) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5),
    decoration: ButtonDecoration.workiButton,
    child: FlatButton(
      child: Row(
        children: <Widget>[
          Material(
            child: document['profilePic'] != null || document['profilePic']!=''
                ? CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
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
                    chat: document,
                    chatKey: document['documentID'],
                    user: user)));
      },
      padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
    ),
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
