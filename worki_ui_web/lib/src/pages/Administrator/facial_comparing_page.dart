import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/firebase_provider.dart';

class FacialComparing extends StatefulWidget {
  @override
  _FacialComparingState createState() => _FacialComparingState();
}

class _FacialComparingState extends State<FacialComparing> {
  File _sourceimage;
  String _firebaseimage;
  FirebaseProvider firebaseProvider = FirebaseProvider();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Comparar rostros', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          leading: IconButton(
              icon: Icon(Icons.navigate_before,
                  color: Color.fromRGBO(0, 167, 255, 0.7)),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            Icon(Icons.add),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Comparar rostros',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Lato'),
                ),
                Container(
                  height: 120.0,
                  width: 120.0,
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
              ],
            ),
            FloatingActionButton(
              child: Container(
                child: Text('Buscar por comparando rostros'),
              ),
              onPressed: () {
                //compare_faces(_sourceimage);
              },
            )
          ],
        ));
  }

  void compare_faces(File sourceimage) async {
    if (_sourceimage != null) {
      _firebaseimage = await firebaseProvider.uploadFile(
          _sourceimage, 'face/' + _sourceimage.path.split('/').last, 'image');
    }
  }
}
