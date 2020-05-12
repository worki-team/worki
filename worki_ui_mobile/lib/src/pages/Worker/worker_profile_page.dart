import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/rating_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Worker/register_user4_page.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'dart:math' as Math;
import 'package:worki_ui/src/pages/Worker/instagram_page.dart';
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

class _WorkerProfilePageState extends State<WorkerProfilePage>
    with TickerProviderStateMixin {
  Worker worker;
  _WorkerProfilePageState({this.worker});
  File _image;
  bool basic = false, work = false, physical = false, insta = false;
  User user;
  String companyId;
  WorkerProvider workerProvider = new WorkerProvider();
  CompanyProvider companyProvider =  new CompanyProvider();
  double activeButton = 150;
  AnimationController workController;
  var _arguments;
  bool owner = true;
  var rateValue = 1;
  bool cambioRate = false;
  final commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    workController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    workController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (worker == null) {
      _arguments = ModalRoute.of(context).settings.arguments;
      worker = _arguments['worker']; //
      owner = false;
      user = _arguments['user']; //administrator
      companyId = _arguments['companyId'];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 80),
        children: <Widget>[
          owner == true ? _header() : Container(),
          SizedBox(
            height: 20,
          ),
          _topInfo(),
          SizedBox(
            height: 20,
          ),
          _basicData(),
          SizedBox(height: 10,),
          _comments(worker, context),
        ],
      ),
      appBar: owner == true ? null : _createAppBar(),
    );
  }

  Widget _createAppBar() {
    return AppBar(
      title: Text(
        'Perfil',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: AppColors.workiColor),
      elevation: 0.0,
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
      height: 200,
      width: 200,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 190,
              width: 190,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black38)],
                  border: Border.all(color: Colors.white, width: 3)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: worker.profilePic != ''
                      ? Image.network(worker.profilePic, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/noprofilepic.png',
                          fit: BoxFit.cover)),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            //child: _instagramLogo(),
          ),
        ],
      ),
    );
  }

  Widget _topInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 340,
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
                        height: 50,
                      ),
                      Text(
                        worker.name,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        worker.email,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        worker.getAge() != 0
                            ? 'Edad: ' + worker.getAge().toString() + ' años'
                            : 'Edad: ??',
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
              duration: Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: basic == false ? 0 : 350,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.wc, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Género: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          worker.gender != null ? worker.gender : '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_city, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Ciudad: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          worker.city != null ? worker.city : '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.check_circle_outline, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Estado Civil: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          worker.maritalStatus != null
                              ? worker.maritalStatus
                              : '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.local_hospital, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Tipo de Sangre: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          worker.rh != null ? worker.rh : '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.school, color: Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Ocupación: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          worker.ocupation != null ? worker.ocupation : '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  worker.physicalLimitation.length != 0
                      ? Expanded(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.accessible, color: Colors.white),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Limitaciones Físicas: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(left: 10),
                                      itemCount:
                                          worker.physicalLimitation != null
                                              ? worker.physicalLimitation.length
                                              : 0,
                                      scrollDirection: Axis.horizontal,
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, i) {
                                        return Chip(
                                          backgroundColor: Colors.white,
                                          label: Text(
                                              worker.physicalLimitation[i]),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  worker.allergies != null && worker.allergies.length != 0
                      ? Expanded(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.local_hospital, color: Colors.white),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Alergias: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(left: 10),
                                      itemCount: worker.allergies.length,
                                      scrollDirection: Axis.horizontal,
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, i) {
                                        return Chip(
                                          backgroundColor: Colors.white,
                                          label: Text(worker.allergies[i]),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              )),
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
          worker.workExperience != null && worker.workExperience.length != 0
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          'Experiencia Laboral',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                        onPressed: () {
                          if (work) {
                            workController.reverse();
                          } else {
                            workController.forward();
                          }
                          setState(() {
                            work = !work;
                          });
                        },
                      )
                    ],
                  ),
                )
              : Container(),
          SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: workController, curve: Curves.fastOutSlowIn),
            axisAlignment: 1.0,
            child: Container(
              //height: work == false ? 0 : 100,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: worker.workExperience != null
                    ? worker.workExperience.length
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(blurRadius: 6, color: Colors.black54)
                        ]),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(FontAwesome5.user,
                                color: AppColors.workiColor, size: 25),
                            Text(
                              ' CARGO:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 30),
                            Text(worker.workExperience[index].position)
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_city,
                                color: AppColors.workiColor, size: 25),
                            Text(
                              ' COMPANÍA:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 30),
                            Text(worker.workExperience[index].company)
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'DESCRIPCIÓN:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.workiColor, width: 2),
                                    borderRadius: BorderRadius.circular(5)),
                                child:
                                    Text(worker.workExperience[index].company))
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(FontAwesome5.calendar_check,
                                    color: AppColors.workiColor, size: 30),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'FECHA INICIAL:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(worker.workExperience[index]
                                        .getInitialYear())
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(FontAwesome5.calendar_times,
                                    color: AppColors.workiColor, size: 30),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      'FECHA FINAL:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(worker.workExperience[index]
                                        .getFinalYear())
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
          worker.physicalProfile != null
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: physical == false ? 0 : 300,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Contextura: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              worker.physicalProfile.contexture != null
                                  ? EnumToString.parse(
                                      worker.physicalProfile.contexture)
                                  : '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Color de Ojos: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              worker.physicalProfile.eyeColor != null
                                  ? EnumToString.parse(
                                      worker.physicalProfile.eyeColor)
                                  : '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Tipo de Pelo: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              worker.physicalProfile.hairType != null
                                  ? EnumToString.parse(
                                      worker.physicalProfile.hairType)
                                  : '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Color de Pelo: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              worker.physicalProfile.hairColor != null
                                  ? EnumToString.parse(
                                      worker.physicalProfile.hairColor)
                                  : '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Color de Piel: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              worker.physicalProfile.skinColor != null
                                  ? EnumToString.parse(
                                      worker.physicalProfile.skinColor)
                                  : '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Talla Camiseta: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              worker.physicalProfile.shirtSize != null
                                  ? worker.physicalProfile.shirtSize
                                  : '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Estatura: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              worker.physicalProfile.height != null
                                  ? worker.physicalProfile.height.toString()
                                  : '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Peso: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              worker.physicalProfile.weight != null
                                  ? worker.physicalProfile.weight.toString()
                                  : '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          //_instagramPhotos()
        ],
      ),
    );
  }

  Widget _instagramPhotos() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 42, 176, 254),
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
                    'Fotos de instagram',
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
                      //work = !work;
                      insta = !insta;
                    });
                  },
                )
              ],
            ),
          ),
          AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: insta == false ? 0 : 350,
              child: Column(
                children: <Widget>[],
              )),
          //AQUI VA TODA ESA MONDA
        ],
      ),
    );
  }

  Widget _instagramLogo() {
    return ClipOval(
      child: Material(
        color: Color.fromRGBO(205, 45, 144, 1.0), // button colors
        child: InkWell(
          splashColor: Color.fromRGBO(88, 81, 219, 260), // inkwell color
          child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(FontAwesome5Brands.instagram, color: Colors.white)),
          onTap: () {
            Navigator.of(context).pushNamed('instagram_page');
          },
        ),
      ),
    );
  }

  _comments(Worker worker, BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  color: Colors.black38,
                  offset: Offset(0.0, 0.0))
            ]),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Comentarios:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            worker.rating.length > 0
                ? Container(
                    height: worker.rating.length > 1 ? 220 : 110,
                    child: Stack(
                      children: <Widget>[
                        ListView(
                            shrinkWrap: false,
                            physics: ScrollPhysics(),
                            children: worker.rating
                                .map((item) => _commentCard(item))
                                .toList()),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(200, 255, 255, 255),
                                  Color.fromARGB(100, 255, 255, 255),
                                  Color.fromARGB(0, 255, 255, 255)
                                ])),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(child: Text('Aún no hay comentarios')),
            SizedBox(
              height: 30.0,
            ),
            owner != true && companyId != null
                ? Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Califica a ${worker.name}' ,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RatingBar(
                              initialRating: rateValue.toDouble(),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 10,
                              ),
                              onRatingUpdate: (rating) {
                                rateValue = rating.toInt();
                                cambioRate = true;
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          maxLines: 3,
                          controller: commentController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: "Comenta acerca de" + worker.name,
                            hintStyle: TextStyle(color: Colors.white30),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(25.0))),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Center(
                          child: Container(
                            decoration: ButtonDecoration.workiButton,
                            height: 40,
                            width: 120,
                            child: FlatButton(
                              onPressed: () {
                                bool already = false;

                                worker.rating.forEach((v) {
                                  if (v.userId == companyId) {
                                    if (cambioRate) {
                                      v.value = rateValue.toInt();
                                    }
                                    v.comment = commentController.text;
                                    already = true;
                                  }
                                });

                                if (!already) {
                                  Rating rat = new Rating();
                                  rat.userId = companyId;
                                  rat.value = rateValue.toInt();
                                  rat.comment = commentController.text;
                                  worker.rating.add(rat);
                                }
                                updateWorker(context, worker);
                              },
                              child: Text(
                                'Calificar',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ));
  }
  void updateWorker(BuildContext context, Worker worker) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Agregando calificación del trabajador',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    pr.show();

    Map<String, dynamic> data = await workerProvider.updateWorker(worker);
    if (pr.isShowing()) pr.hide();
    if (data['ok']) {
      showAlert(context, 'Se ha calificado al trabajador');
      //refreshs
      (context as Element).reassemble();
    } else {
      data['message'] != null
          ? showAlert(
              context, "No es posible calificar al trabajador. " + data['message'])
          : showAlert(context, "No es posible calificar al trabajador.");
    }
  }

  Widget _commentCard(Rating rating) {
    return FutureBuilder(
      future: companyProvider.getCompanyById(rating.userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Company company = snapshot.data;
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: company.profilePic != '' && company.profilePic != null 
                    ? NetworkImage(company.profilePic)
                    : AssetImage('assets/no-image.png'),
              ),
              title: new Column(
                children: <Widget>[
                  Text(company.name),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RatingBar(
                        initialRating: rating.value.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 10,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              subtitle: rating.comment != null
                  ? Text(
                      rating.comment,
                      textAlign: TextAlign.justify,
                    )
                  : Text('...', textAlign: TextAlign.center),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

}
