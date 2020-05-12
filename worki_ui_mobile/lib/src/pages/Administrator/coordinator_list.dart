import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worki_ui/src/pages/Coordinator/coordinator_profile.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class CoordinatorListPage extends StatefulWidget {
  CoordinatorListPage({Key key}) : super(key: key);

  @override
  _CoordinatorListPageState createState() => _CoordinatorListPageState();
}

var colors = [
  Color.fromARGB(255, 147, 214, 254),
  Color.fromARGB(255, 104, 198, 254),
  Color.fromARGB(255, 59, 180, 254),
];

class _CoordinatorListPageState extends State<CoordinatorListPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();

  var data = [
    {
      "title": "Juan Sebastián Gonzalez",
      "content": "j@hotmail.com \n \n 3103046755",
      "color": COLORS[new Random().nextInt(3)],
      "image": "https://picsum.photos/200?random"
    },
    {
      "title": "Nicolás Suárez Jimenez",
      "content": "N@hotmail.com \n \n 3103046755",
      "color": COLORS[new Random().nextInt(3)],
      "image": "https://picsum.photos/100?random"
    },
    {
      "title": "Juan David Ocampo",
      "content": "J@j.com \n \n 3103046755",
      "color": COLORS[new Random().nextInt(3)],
      "image": "https://picsum.photos/150?random"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: new Text(
          'Lista coordinadores',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Transform.translate(
            offset:
                new Offset(0.0, MediaQuery.of(context).size.height * 0.1050),
            child: Container(
              child: new ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                scrollDirection: Axis.vertical,
                primary: true,
                itemCount: data.length,
                itemBuilder: (BuildContext content, int index) {
                  /*return AwesomeListItem(
                      title: data[index]["title"],
                      content: data[index]["content"],
                      color: data[index]["color"],
                      image: data[index]["image"]);*/
                },
              ),
            ),
          ),
          new Transform.translate(
            offset: Offset(0.0, -56.0),
            child: new Container(
              child: new ClipPath(
                clipper: new MyClipper(),
                child: new Stack(
                  children: [
                    new Image.asset(
                      "assets/background3Horizontal.png",
                      fit: BoxFit.contain,
                    ),
                    new Opacity(
                      opacity: 0.2,
                      child: new Container(color: COLORS[0]),
                    ),
                    new Transform.translate(
                      offset: Offset(0.0, 50.0),
                      child: new ListTile(
                        leading: new CircleAvatar(
                          child: new Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/noprofilepic.png"),
                              ),
                            ),
                          ),
                        ),
                        title: new Text(
                          "María Jose Castillo",
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              letterSpacing: 2.0),
                        ),
                        subtitle: new Text(
                          "Administrador",
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              letterSpacing: 2.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 5.50);
    p.lineTo(0.0, size.height / 4.30);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}


