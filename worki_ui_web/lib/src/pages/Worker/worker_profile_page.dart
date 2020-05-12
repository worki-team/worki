import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Worker/register_user4_page.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'dart:math' as Math;

import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/values.dart';

class WorkerProfilePage extends StatefulWidget {
  final Worker worker;
  WorkerProfilePage({@required this.worker});
  @override
  _WorkerProfilePageState createState() =>
      _WorkerProfilePageState(worker: this.worker);
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  final Worker worker;
  _WorkerProfilePageState({this.worker});
  File _image;
  bool basic = false, work = false, physical = false;
  User user;
  WorkerProvider workerProvider = new WorkerProvider();
  double activeButton = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 80),
        children: <Widget>[
          _header(),
          SizedBox(
            height: 20,
          ),
          _topInfo(),
          SizedBox(
            height: 20,
          ),
          _basicData(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Perfil',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, fontFamily: 'Lato'),
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('edit_profile', arguments: worker);
                },
                icon: Icon(Icons.edit, color: Colors.blue),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: activeButton,
                height: 40,
                decoration: BoxDecoration(
                  gradient: worker.isActive == true
                      ? Gradients.greenGradient
                      : Gradients.redGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FlatButton(
                    onPressed: () async {
                      if (worker.isProfileFinished == true) {
                        worker.isActive = !worker.isActive;
                        setState(() {});
                        await workerProvider.updateWorker(worker);
                        
                      } else {
                        showAlert(context,
                            'Debes finalizar tu perfil para activar tu perfil');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        worker.isActive == true
                            ? Text('Perfil Activo',
                                style: TextStyle(color: Colors.white))
                            : Text('Perfil Inactivo',
                                style: TextStyle(color: Colors.white)),
                        worker.isActive == true
                            ? Icon(Icons.check, color: Colors.white)
                            : Icon(Icons.cancel, color: Colors.white),
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profilePhoto() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black38)],
          border: Border.all(color: Colors.white, width: 3)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(worker.profilePic, fit: BoxFit.cover)),
    );
  }

  Widget _topInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black38,
                        )
                      ]),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        worker.name,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        worker.email,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Edad: ' + worker.getAge().toString() + ' años',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Text(
                            worker.getRating().toString() == '0.0'
                                ? 'No ha sido calificado'
                                : worker.getRating().toString(),
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            Align(alignment: Alignment.topCenter, child: _profilePhoto()),
          ],
        ),
      ),
    );
  }

  Widget _basicData() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 147, 214, 254),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black38)]),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Datos Básicos',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: [Shadow(blurRadius: 3, color: Colors.black26)]),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      basic = !basic;
                    });
                  },
                )
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 150),
            height: basic == false ? 0 : 100,
            width: MediaQuery.of(context).size.width,
          ),
          _workExperienceEducation(),
        ],
      ),
    );
  }

  Widget _workExperienceEducation() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 104, 198, 254),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black38)]),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'Experiencia Laboral y Educación',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      work = !work;
                    });
                  },
                )
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 150),
            height: work == false ? 0 : 100,
            width: MediaQuery.of(context).size.width,
          ),
          _physicalProfile(),
        ],
      ),
    );
  }

  Widget _physicalProfile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 59, 180, 254),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black38)]),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'Perfil Físico',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      physical = !physical;
                    });
                  },
                )
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 150),
            height: physical == false ? 0 : 100,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}
