import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/providers/coordinator_provider.dart';
import 'package:worki_ui/src/values/values.dart';

class CoordinatorProfilePage extends StatefulWidget {
  final Coordinator coordinator;
  CoordinatorProfilePage({@required this.coordinator});
  @override
  _CoordinatorProfilePageState createState() =>
      _CoordinatorProfilePageState(coordinator: this.coordinator);
}

var COLORS = [
  Color.fromARGB(255, 147, 214, 254),
  Color.fromARGB(255, 104, 198, 254),
  Color.fromARGB(255, 59, 180, 254),
];

class _CoordinatorProfilePageState extends State<CoordinatorProfilePage> {
  Coordinator coordinator;
  _CoordinatorProfilePageState({this.coordinator});
  User user;
  final format = DateFormat("yyyy-MM-dd");

  CoordinatorProvider coordinatorProvider = new CoordinatorProvider();
  Map<String, dynamic> _arguments;

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    coordinator = _arguments['coordinator'];
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: new Text(
          'Perfil',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: AppColors.workiColor),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.asset(
              "assets/background3Horizontal.png",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //for user profile header
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 0, top: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipOval(
                              child: coordinator.profilePic == '' ? Image.asset(
                                'assets/noprofilepic.png', fit: BoxFit.cover) :
                                Image.network(coordinator.profilePic, fit: BoxFit.cover),
                            )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                coordinator.name,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Coordinador(a)",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                            onPressed: null,
                            child: Icon(
                              Icons.sms,
                              color: COLORS[2],
                              size: 30,
                            ))
                      ],
                    ),
                  ),
                  //performace bar
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    color: COLORS[2],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.check_box,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "5",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24),
                                )
                              ],
                            ),
                            Text(
                              "Eventos",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.event,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "2",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24),
                                )
                              ],
                            ),
                            Text(
                              "Próximos",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "5",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24),
                                )
                              ],
                            ),
                            Text(
                              "Calificación",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.alternate_email,
                      color: Color.fromRGBO(0, 167, 255, 1.0),
                      size: 30,
                    ),
                    title: new TextFormField(
                      enabled: false,
                      initialValue: coordinator.email,
                      //initialValue: coordinator.email,
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.phone_iphone,
                      color: Color.fromRGBO(0, 167, 255, 1.0),
                      size: 30,
                    ),
                    title: TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Celular',
                      ),
                      initialValue: coordinator.phone.toString(),
                      validator: (value) {
                        if (value == '') {
                          return 'Número inválido';
                        }
                        return null;
                      },
                      onSaved: (value) => coordinator.phone = int.parse(value),
                      onChanged: (value) {
                        coordinator.phone = int.parse(value);
                        //notifyParent();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.cake,
                      color: Color.fromRGBO(0, 167, 255, 1.0),
                      size: 30,
                    ),
                    title: new DateTimeField(
                      format: format,
                      enabled: true,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime.now());
                      },
                      initialValue: coordinator.birthDate,
                      decoration: new InputDecoration(
                        hintText:'fecha de nacimiento' //coordinator.birthDate != null
                            //? coordinator.birthDate
                              //  .toIso8601String()
                               // .substring(0, 10)
                            //: 'Fecha de nacimiento',
                      ),
                      //initialValue: coordinator.birthDate,
                      onChanged: (value) {
                        coordinator.birthDate = value;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Fecha de nacimiento inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
