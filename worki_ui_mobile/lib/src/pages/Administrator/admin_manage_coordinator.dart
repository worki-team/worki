import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/pages/Administrator/coordinator_list.dart';
import 'package:worki_ui/src/pages/Administrator/coordinators_events.dart';
import 'package:worki_ui/src/pages/Administrator/create_coordinator.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/widgets/coordinator_card_widget.dart';


var colors = [
  Color.fromARGB(255, 147, 214, 254),
  Color.fromARGB(255, 104, 198, 254),
  Color.fromARGB(255, 59, 180, 254),
];
class AdminManageCoordinatorPage extends StatefulWidget {
  Administrator admin;
  AdminManageCoordinatorPage({this.admin});

  @override
  _AdminManageCoordinatorPageState createState() =>
      _AdminManageCoordinatorPageState(admin:this.admin);
}

class _AdminManageCoordinatorPageState extends State<AdminManageCoordinatorPage> {
  Administrator admin;
  _AdminManageCoordinatorPageState({this.admin});
  FirebaseProvider firebaseProvider = FirebaseProvider();
  CoordinatorProvider coordinatorProvider = new CoordinatorProvider();
  Map<String,dynamic> _arguments;
  
  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    admin = _arguments['admin'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Coordinadores',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato'
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.workiColor),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: AppColors.workiColor),
            onPressed: (){
              Navigator.of(context).pushNamed('registerUser1',arguments: jsonEncode({'rol': 'COORDINATOR','companyId':admin.companyId,'admin':admin}));
            }
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _header(),
          _coordinatorsBuilder()
          /*
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
          SizedBox(height: 20),*/
        ],
      ),
    );
  }

  Widget _header(){
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            ListTile(
              title: Text('Tus coordinadores',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 167, 255, 1.0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text(
                'Aquí podrás crear y ver los coordinadores de tu empresa',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _coordinatorsBuilder(){
    return FutureBuilder(
      future: coordinatorProvider.getCoordinatorsByCompanyId(admin.companyId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          List<Coordinator> coordinators = snapshot.data;
          
          return ListView.builder(
            itemCount: coordinators.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, i){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CoordinatorCardWidget(color: colors[ Random().nextInt(3)] ,coordinator: coordinators[i],notifyParent: refresh, admin: admin),
              );
            }
          );
        }else{
          return Column(
            children: <Widget>[
              for(int i=0; i<3; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: 210,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  refresh(){
    setState(() {
    });
  }
}
