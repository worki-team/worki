import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/face_answer_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Shared/notification_page.dart';
import 'package:worki_ui/src/providers/aws_provider.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/progressDialog.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/widgets/worker_card_widget.dart';
import '../../providers/firebase_provider.dart';

class FacialComparing extends StatefulWidget {
  @override
  _FacialComparingState createState() => _FacialComparingState();
}

class _FacialComparingState extends State<FacialComparing> {
  File _sourceimage;
  String _firebaseimage;
  FirebaseProvider firebaseProvider = FirebaseProvider();
  AWSProvider awsProvider = AWSProvider();
  int _value = 80;
  bool results = false;
  var data = [];
  WorkerProvider _workerProvider = new WorkerProvider();
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  Administrator admin;
  Company company;
  Map<String, dynamic> arguments;
  Future getSourceImage() async {
    //Obtener imagen de la galería
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _sourceimage = image;
    });
  }

  removeSourceImage() async {
    //Quitar imagen de la empresa
    setState(() {
      _sourceimage = null;
    });
  }

  changeResults(Map<String, dynamic> workers) async {
    setState(() {
      results = true;
      data = [];

      var sortedEntries = workers.entries.toList()
        ..sort((e1, e2) {
          //Sort the map
          var diff = e2.value.compareTo(e1.value);
          if (diff == 0) diff = e2.key.compareTo(e1.key);
          return diff;
        });

      var newMap = Map<String, dynamic>.fromEntries(sortedEntries);
      newMap.forEach((k, v) {
        data.add(FaceAnswer(k, v));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    admin = arguments['admin'];
    company = arguments['company'];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          title:
              Text('Comparar rostros', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          
          iconTheme: IconThemeData(color: AppColors.workiColor),
        ),
        body: ListView(
          padding: EdgeInsets.only(bottom: 100),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 190.0,
                  width: 190.0,
                  child: FloatingActionButton(
                      onPressed: getSourceImage,
                      tooltip: 'Selecciona la imagen',
                      child: _sourceimage == null
                          ? CircleAvatar(
                              backgroundImage:
                                  ExactAssetImage('assets/noprofilepic.png'),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(_sourceimage),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    removeSourceImage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.delete,
                          color: Color.fromRGBO(0, 167, 255, 1.0)),
                      Text('Borrar imagen fuente')
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Slider(
                              min: 10,
                              max: 100,
                              divisions: 9,
                              value: _value.toDouble(),
                              activeColor: AppColors.workiColor,
                              inactiveColor: AppColors.workiColor,
                              label: 'Similaridad',
                              onChanged: (double newValue) {
                                setState(() {
                                  _value = newValue.round();
                                });
                              },
                              semanticFormatterCallback: (double newValue) {
                                return '${newValue.round()} dollars';
                              })),
                      Text(_value.toString()),
                    ]),
                Container(
                  width: 250,
                  height: 50,
                  decoration: ButtonDecoration.workiButton,
                  margin: EdgeInsets.only(bottom: 10),
                  child: FlatButton(
                    onPressed: () {
                      compareFaces(_sourceimage, _value);
                    },
                    textColor: Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "Buscar similitudes",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                results ? showWorkers() : Container(),
              ],
            ),
          ],
        ));
  }

  compareFaces(File _sourceimage, int _value) async {
    if (_sourceimage != null) {
      print(_sourceimage);
      print(_value);
      var pr = showProgressDialog(context);
      pr.show();
      _firebaseimage = await firebaseProvider.uploadFile(
          _sourceimage, 'face/' + _sourceimage.path.split('/').last, 'image');
      Map<String, dynamic> results =
          await awsProvider.facesCompare(_firebaseimage, _value.toDouble());
      print(results);
      if (results['ok']) changeResults(results['resp']);

      if (pr.isShowing()) pr.hide();
    } else {
      showAlert(context, 'Por favor selecciona una imagen');
    }
  }

  Widget showWorkers() {
    return ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: data.map((item) => _workerCard(item)).toList());
  }

  Widget _workerCard(FaceAnswer faceAnswer) {
    return FutureBuilder(
      future: _workerProvider.getWorker(faceAnswer.userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['ok']) {
          Worker worker = Worker.fromJson(snapshot.data['worker']);
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('profile_page', arguments: {'worker': worker});
            },
            child: Stack(
              children: [
                WorkerCardWidget(worker: worker),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 30,left: 20),
                    child: Text('Similitud del ' +
                          faceAnswer.similarity.toInt().toString() +
                          '%',
                           style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                  )
                )
              ],
            ),
            
            /*Card(
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: worker.profilePic != null
                        ? NetworkImage(worker.profilePic)
                        : AssetImage('assets/no-image.png'),
                  ),
                  title: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(worker.name),
                      GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      '¿Crear chat con ' + worker.name + '?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Si'),
                                      onPressed: () async {
                                        List<User> userIds = new List<User>();

                                        User fireUserAdmin = new User();
                                        fireUserAdmin.id = admin.id;
                                        fireUserAdmin.name = admin.name;
                                        fireUserAdmin.profilePic =
                                            admin.profilePic;
                                        fireUserAdmin.roles = admin.roles;
                                        userIds.add(fireUserAdmin);

                                        User fireUserWorker = new User();
                                        fireUserWorker.id = worker.id;
                                        fireUserWorker.name = worker.name;
                                        fireUserWorker.profilePic =
                                            worker.profilePic;
                                        fireUserWorker.roles = worker.roles;
                                        userIds.add(worker);

                                        firestoreProvider
                                            .createChat(
                                                worker.id + admin.id,
                                                'Chat: ' +
                                                    admin.name +
                                                    "-" +
                                                    worker.name,
                                                _firebaseimage,
                                                userIds)
                                            .then((docRef) {
                                          var materialPageRoute;
                                          materialPageRoute = MaterialPageRoute(
                                              builder: (_) =>
                                                  new NotificationPage(
                                                      user: admin));
                                          Navigator.push(
                                              context, materialPageRoute);
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Icon(
                                Icons.chat,
                                size: 30,
                              )))
                    ],
                  ),
                  subtitle: Text(
                    'Similitud del ' +
                        faceAnswer.similarity.toInt().toString() +
                        '%',
                    textAlign: TextAlign.start,
                  )),
            ),*/
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
