import 'package:flutter/material.dart';
import 'package:worki_ui/src/pages/Administrator/coordinator_list.dart';
import 'package:worki_ui/src/pages/Administrator/coordinators_events.dart';
import 'package:worki_ui/src/pages/Administrator/create_coordinator.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class AdminManageCoordinatorPage extends StatefulWidget {
  AdminManageCoordinatorPage({Key key}) : super(key: key);

  @override
  _AdminManageCoordinatorPageState createState() =>
      _AdminManageCoordinatorPageState();
}

class _AdminManageCoordinatorPageState
    extends State<AdminManageCoordinatorPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Coordinadores',
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(0, 167, 255, 1.0),
      ),
      body: ListView(
        children: <Widget>[
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
                      leading: Icon(Icons.format_list_numbered_rtl, size: 50),
                      title: Text('Ver lista de coordinadores',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 167, 255, 1.0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                        child: Text(
                          'Aquí podrás ver todos los coordinadores que están en tu empresa',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Ver lista',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 167, 255, 1.0))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CoordinatorListPage()),
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
                      leading: Icon(Icons.add_to_queue, size: 50),
                      title: Text('Agregar un coordinador',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 167, 255, 1.0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                        child: Text(
                          'Aquí podrás agregar un nuevo coordinador a tu empresa',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Agregar',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 167, 255, 1.0))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateCoordinatorPage()),
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
                      leading: Icon(Icons.event, size: 50),
                      title: Text('Coordinadores en Eventos',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 167, 255, 1.0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                        child: Text(
                          'Aquí podrás ver cuales eventos tienen coordinadores asignados y cuales no',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Ver eventos',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 167, 255, 1.0))),
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
    );
  }
}
