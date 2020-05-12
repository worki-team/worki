import 'package:flutter/material.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class CoordinatorEventPage extends StatefulWidget {
  CoordinatorEventPage({Key key}) : super(key: key);

  @override
  _CoordinatorEventPageState createState() => _CoordinatorEventPageState();
}

var COLORS = [
  Color.fromARGB(255, 147, 214, 254),
  Color.fromARGB(255, 104, 198, 254),
  Color.fromARGB(255, 59, 180, 254),
];

class _CoordinatorEventPageState extends State<CoordinatorEventPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: new Text(
          'Coordinadores en Eventos',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 85.0, 30.0, 0),
                child: Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        const ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://pbs.twimg.com/media/EOud9fBXsAQ4jh3.jpg'),
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text('Nombre del Evento',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 167, 255, 1.0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 15.0, 10.0, 0.0),
                            child: Text(
                              'Fecha del evento: 12/04/2020 \n\n información del evento',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Coordinador(es) asignado(s)',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 167, 255, 1.0),
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/noprofilepic.png'),
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text('Nombre del coordinador'),
                        ),
                        ButtonTheme(
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Icon(Icons.edit, size: 30),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                                          ),
                                          content: Container(
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/noprofilepic.png'),
                                              radius: 20.0,
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            title:
                                                Text('Nombre del coordinador'),
                                          ),
                                        ));
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                child: Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        const ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://pbs.twimg.com/media/EOud9fBXsAQ4jh3.jpg'),
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text('Nombre del Evento',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 167, 255, 1.0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 15.0, 10.0, 0.0),
                            child: Text(
                              'Fecha del evento: 12/04/2020 \n\n información del evento',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Coordinador(es) asignado(s)',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 167, 255, 1.0),
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/noprofilepic.png'),
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text('Nombre del coordinador'),
                        ),
                        ButtonTheme(
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Icon(Icons.edit, size: 30),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                child: Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        const ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://pbs.twimg.com/media/EOud9fBXsAQ4jh3.jpg'),
                            radius: 30.0,
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text('Nombre del Evento',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 167, 255, 1.0),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 15.0, 10.0, 0.0),
                            child: Text(
                              'Fecha del evento: 12/04/2020 \n\n información del evento',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Coordinador(es) asignado(s)',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 167, 255, 1.0),
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/noprofilepic.png'),
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text('Nombre del coordinador'),
                        ),
                        ButtonTheme(
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Icon(Icons.edit, size: 30),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CoordinatorEventPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
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
