import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/gradients.dart';
import 'package:worki_ui/src/widgets/filter_card_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const CustomAppBar({Key key, this.onTap, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: appBar);
  }

  // TODO: implement preferredSize
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class ChatPage extends StatefulWidget {
  final String chatKey;
  final String profilePic;
  final User user;
  ChatPage(
      {Key key,
      @required this.chatKey,
      @required this.profilePic,
      @required this.user})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(
      chatKey: this.chatKey, profilePic: this.profilePic, user: this.user);
}

class _ChatPageState extends State<ChatPage> {
  final String chatKey;
  final String profilePic;
  final User user;
  FirestoreProvider firestoreProvider = new FirestoreProvider();

  _ChatPageState({this.chatKey, this.profilePic, this.user});
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  var listMessage;
  PanelController _panelController = new PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: CustomAppBar(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: new Text(
                'CHAT',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.info), color: Colors.white)
              ],
              centerTitle: true,
              iconTheme: IconThemeData(color: AppColors.workiColor),
            ),
            onTap: () {
              _panelController.open();
            }),
        body: Stack(
          children: <Widget>[
            chatScreen(),
            SlidingUpPanel(
              margin: EdgeInsets.all(10),
              maxHeight: 300,
              minHeight: 0,
              backdropEnabled: true,
              controller: _panelController,
              borderRadius: BorderRadius.circular(20),
              isDraggable: true,
              slideDirection: SlideDirection.DOWN,
              panel: Center(child: Text('info del grupo')),
            )
          ],
        ));
  }

  Widget chatScreen() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            buildListMessage(),
            buildInput(),
          ],
        ),
        //buildLoading()
      ],
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          /*
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                //onPressed: getImage,
                color: AppColors.workiColor,
              ),
            ),
            color: Colors.white,
          ),
          */
          // Edit text
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text),
                color: AppColors.workiColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 60.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  void onSendMessage(String content) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('chats')
          .document(chatKey)
          .collection('messages')
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'from': user.id,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      showAlert(context, 'Nothing to send');
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: chatKey == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.workiColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('chats')
                  .document(chatKey)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.workiColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    FirestoreProvider firestoreProvider = new FirestoreProvider();

    if (document['from'] == user.id) {
      // Right (my message)
      return Container(
          child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            //document['type'] == 0 ?
            //text
            Container(
              child: Text(
                document['content'],
                style: TextStyle(color: Colors.black),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black26,
                      offset: Offset(3.0, 3.0)
                    )
                  ]
              ),
              margin: EdgeInsets.only(
                  bottom: isLastMessageRight(index) ? 5.0 : 5.0, right: 10.0),
            )
            /*
                : document['type'] == 1
                    // Image
                    ? Container(
                        child: FlatButton(
                          child: Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                ),
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: greyColor2,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  'images/img_not_available.jpeg',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: document['content'],
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                          },
                          padding: EdgeInsets.all(0),
                        ),
                        margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                      )
                    // Sticker
                    : Container(
                        child: new Image.asset(
                          'images/${document['content']}.gif',
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                      ),
                      */
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        Container(
          child: Text(
            DateFormat('dd MMM kk:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(document['timestamp']))),
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontStyle: FontStyle.italic),
          ),
          margin: EdgeInsets.only(left: 50.0, bottom: 10.0),
        )
      ]));
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                FutureBuilder(
                  future: firestoreProvider.getUser(document['from']),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data.documents.length > 0) {
                      return GestureDetector(
                        onTap: () {
                          print(document['from']);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    snapshot.data.documents[0]['name'],
                                    textAlign: TextAlign.center,
                                  ),
                                  content: GestureDetector(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.6,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 5,
                                                color: Colors.black38,

                                              )
                                            ]
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image(
                                              image: snapshot.data.documents[0]
                                                          ['profilePic'] !=
                                                      null
                                                  ? NetworkImage(
                                                      snapshot.data.documents[0]
                                                          ['profilePic'])
                                                  : AssetImage(
                                                      'assets/no-image.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    )
                                  ],
                                );
                              });
                        },
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.workiColor),
                              ),
                              width: 35.0,
                              height: 35.0,
                              padding: EdgeInsets.all(10.0),
                            ),
                            imageUrl: snapshot.data.documents[0]['profilePic'],
                            width: 35.0,
                            height: 35.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                      );
                    } else {
                      return Container(width: 35.0);
                    }
                  },
                ),
                //document['type'] == 0?
                //text
                Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      gradient: Gradients.workiGradient,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black26,
                          offset: Offset(3.0, 3.0)
                        )
                      ]
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                /*
                    : document['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: new Image.asset(
                              'images/${document['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                          ),
                          */
              ],
            ),

            // Time
            /* isLastMessageLeft(index)
                ? 
             */
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document['timestamp']))),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
            //: Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['from'] == user.id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['from'] != user.id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
