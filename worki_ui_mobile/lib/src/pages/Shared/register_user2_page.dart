import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/pages/Shared/register_user3_page.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/button_decoration.dart';

class RegisterUser2Page extends StatefulWidget {
  final Map<String, dynamic> info;

  const RegisterUser2Page({@required this.info});

  @override
  RegisterUser2PageState createState() =>
      RegisterUser2PageState(info: this.info);
}

class RegisterUser2PageState extends State<RegisterUser2Page> {
  Map<String, dynamic> info;
  RegisterUser2PageState({this.info});

  final format = DateFormat("yyyy-MM-dd");
  File _image;
  String _genero;
  String _city;

  User user;

  final _formKey = GlobalKey<FormState>();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _dateBirthFocusNode = FocusNode();
  FocusNode _cityFocusNode = FocusNode();

  Position currentLocation;

  Future getImage() async {
    //Obtener imagen de la galería
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  removeImage() async {
    //Quitar imagen de la empresa
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = User.fromJson(info['user']);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Registro',
            style: TextStyle(color: Colors.black)),
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
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 70.0),
                  user.roles[0] != 'COORDINATOR'? 
                  Center(
                    child: Text(
                      'Queremos saber un poco más',
                      style: TextStyle(
                          fontFamily: 'Trebuchet',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ) : Container(),
                  SizedBox(height: 10.0),
                  
                  Center(
                    child: Text(
                      'Por favor llena los siguientes datos',
                      style: TextStyle(fontFamily: 'Trebuchet', fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Container(
                          height: 120.0,
                          width: 120.0,
                          child: FloatingActionButton(
                              onPressed: getImage,
                              tooltip: 'Pick Image',
                              child: _image == null
                                  ? CircleAvatar(
                                      backgroundImage: ExactAssetImage(
                                          'assets/noprofilepic.png'),
                                      radius: 100.0,
                                      backgroundColor: Colors.transparent,
                                    )
                                  : CircleAvatar(
                                      backgroundImage: FileImage(_image),
                                      radius: 100.0,
                                      backgroundColor: Colors.transparent,
                                    )),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            removeImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.delete,
                                  color: Color.fromRGBO(0, 167, 255, 1.0)),
                              Text('Borrar foto de perfil')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        user.roles[0] != 'COORDINATOR' ?
                        _dateBirthInput(): Container(),
                        SizedBox(height: 10.0),
                        _genderInput(),
                        SizedBox(height: 10.0),
                        _cityInput(),
                        SizedBox(height: 10.0),
                        _phoneInput(),
                      ],
                    ),
                  ),
                  SizedBox(height: 100.0),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: ButtonDecoration.workiButton,
              child: MaterialButton(
                minWidth: 200,
                onPressed: () {
                  print(user.city);
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if(user.roles[0] !='COORDINATOR' ? user.birthDate != null : true){
                      var rol = user.roles[0];
                      user.gender = _genero;
                      user.city = _city;
                      var materialPageRoute;

                      if (rol == 'WORKER') {
                        materialPageRoute = MaterialPageRoute(
                            builder: (_) => new RegisterUser3Page(
                                  info: {'user': user.toJson()},
                                  image: _image,
                                ));
                        // Navigator.of(context).pushNamed('registerUser3', arguments: jsonEncode({'user':user.toJson()}));
                      } else if (rol == 'ADMINISTRATOR') {
                        //Navigator.push(context, MaterialPageRoute(builder: (_) => new RegisterUser3Page(info: {'user':user.toJson(), 'companyId':info['companyId']}, image: _image,)));
                        materialPageRoute = MaterialPageRoute(
                            builder: (_) => new RegisterUser3Page(info: {
                                  'user': user.toJson(),
                                  'company': info['company']
                                }, image: _image));
                        //Navigator.of(context).pushNamed('registerUser3', arguments: jsonEncode({'user':user.toJson(), 'companyId':params['companyId']}));
                      } else if (rol == 'COORDINATOR') {
                        materialPageRoute =  MaterialPageRoute(
                          builder: (_) => new RegisterUser3Page(info: {
                            'user':user.toJson(), 
                            'companyId':info['companyId'],
                            'admin':info['admin']
                            }, image: _image));
                        
                      }
                      Navigator.push(context, materialPageRoute);
                    }else{
                      showAlert(context,'Por favor verifica tu fecha de nacimiento');
                    }
                  }
                },
                textColor: Colors.white,
                child: Text("Siguiente".toUpperCase(),
                    style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _phoneInput() {
    return new ListTile(
      leading: const Icon(
        Icons.phone_iphone,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        autofocus: false,
        autocorrect: false,
        focusNode: _phoneFocusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "Numero de teléfono (+57)",
        ),
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        onSaved: (value) => user.phone = int.parse(value),
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _phoneFocusNode, _dateBirthFocusNode);
        },
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _dateBirthInput() {
    return new ListTile(
      leading: const Icon(
        Icons.cake,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime.now());
        },
        decoration: new InputDecoration(
          hintText: "Fecha de nacimiento",
        ),
        validator: (value) {
          if (value == null) {
            return 'Fecha de nacimiento inválido';
          }
          return null;
        },
        onChanged: (value){
          print(DateTime.now().difference(value).inDays);
          if(DateTime.now().difference(value).inDays<6570){
            showAlert(context, 'Por favor revisa que la fecha este bien!');
          }
        },
        onSaved: (value) { 
           if(DateTime.now().difference(value).inDays<6570){
            user.birthDate = null;
          }else{
            user.birthDate = value;
          }
        },
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _phoneFocusNode, _dateBirthFocusNode);
        },
      ),
    );
  }

  Widget _genderInput() {
    return new ListTile(
      leading: const Icon(
        Icons.wc,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new DropDownFormField(
        onSaved: (value) => _genero = value,
        onChanged: (value) {
          setState(() {
            _genero = value;
          });
        },
        titleText: 'Género',
        hintText: '',
        value: _genero,
        dataSource: [
          {'display': 'Femenino', 'value': 'Femenino'},
          {'display': 'Masculino', 'value': 'Masculino'},
          {'display': 'Otro', 'value': 'Otro'}
        ],
        textField: 'display',
        valueField: 'value',
        validator: (value) {
          if (value == null) {
            return 'Género inválido';
          }
          return null;
        },
      ),
    );
  }

  Widget _cityInput() {
    return new ListTile(
      leading: const Icon(
        Icons.location_city,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title:  DropDownFormField(
        onSaved:  (value) => _city = value,
        onChanged: (value) {
          setState(() {
            _city = value;
          });
        },
        titleText: 'Ciudad',
        hintText: '',
        value: _city,
        dataSource: [
          {'display': 'Bogotá', 'value': 'Bogotá'},
          {'display': 'Medellin', 'value': 'Medellin'},
          {'display': 'Cali', 'value': 'Cali'},
          {'display': 'Bucaramanga', 'value': 'Bucaramanga'},
          {'display': 'Barranquilla', 'value': 'Barranquilla'},
          {'display': 'Pereira', 'value': 'Pereira'},
          {'display': 'Manizales', 'value': 'Manizales'},
          {'display': 'Armenia', 'value': 'Armenia'},
          {'display': 'Cartagena', 'value': 'Cartagena'},
          {'display': 'Santa Marta', 'value': 'Santa Marta'},
          {'display': 'Otra', 'value': 'Otra'},
        ],
        textField: 'display',
        valueField: 'value',
        validator: (value) {
          if (value == null) {
            return 'Ciudad inválida';
          }
          return null;
        },
      ),
      /*new TextFormField(
        textCapitalization: TextCapitalization.sentences,
        focusNode: _cityFocusNode,
        decoration: new InputDecoration(
          hintText: "Ciudad de residencia",
        ),
        validator: (value) {
          if (value == '') {
            return 'Ciudad inválida';
          }
          return null;
        },
        onSaved: (value) => user.city = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _phoneFocusNode, _dateBirthFocusNode);
        },
      ),*/
    );
  }
}
