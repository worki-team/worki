import 'dart:convert';
import 'dart:io';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/pages/Shared/register_user3_page.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/values.dart';

class RegisterCompany2Page extends StatefulWidget {
  @override
  RegisterCompany2PageState createState() => RegisterCompany2PageState();
}

class RegisterCompany2PageState extends State<RegisterCompany2Page> {
  File _image; //foto de perfil de la empresa
  Company company;
  CompanyProvider companyProvider = new CompanyProvider();
  final _formKey = GlobalKey<FormState>();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _secondaryPhoneFocusNode = FocusNode();
  FocusNode _categoryFocusNode = FocusNode();

  FirebaseProvider firebaseProvider = FirebaseProvider();

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
    company = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _createAppBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 180.0,
                      width: 180.0,
                      child: FloatingActionButton(
                          onPressed: getImage,
                          tooltip: 'Pick Image',
                          child: _image == null
                              ? CircleAvatar(
                                  backgroundImage:
                                      ExactAssetImage('assets/no-image.png'),
                                  radius: 160.0,
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(_image),
                                  radius: 160.0,
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
                          Text('Borrar logo')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    //_inputEmail(),
                    SizedBox(height: 10.0),
                    _inputPhone(),
                    SizedBox(height: 10.0),
                    _inputSecondaryPhone()
                  ],
                ),
                SizedBox(height: 25.0),
                _inputCategory(),
                SizedBox(height: 80.0),
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: ButtonDecoration.workiButton,
        child: MaterialButton(
          minWidth: 200,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              registerCompany();
            }
          },
          textColor: Colors.white,
          child: Text("Siguiente".toUpperCase(),
              style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }

  Widget _createAppBar() {
    return AppBar(
      elevation: 0.0,
      title: Text('Registro de empresa',
          style: TextStyle(color: Colors.black)),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromRGBO(0, 167, 255, 0.7)),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: <Widget>[
        Icon(Icons.add),
      ],
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _inputPhone() {
    return ListTile(
      leading: const Icon(
        Icons.phone,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        focusNode: _phoneFocusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "Número de contacto (+57)",
        ),
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        onSaved: (value) => company.phone = int.parse(value),
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _phoneFocusNode, _secondaryPhoneFocusNode);
        },
      ),
    );
  }

  Widget _inputSecondaryPhone() {
    return ListTile(
      leading: const Icon(
        Icons.phone_in_talk,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        focusNode: _secondaryPhoneFocusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "Número secundario (+57)",
        ),
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        onSaved: (value) => company.secondaryPhone = int.parse(value),
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _secondaryPhoneFocusNode, null);
        },
      ),
    );
  }

  Widget _inputCategory() {
    return ListTile(
        leading: const Icon(
          Icons.category,
          color: Color.fromRGBO(0, 167, 255, 1.0),
          size: 30,
        ),
        title: new DropDownFormField(
          onSaved: (value) => company.category = value,
          onChanged: (value) {
            fieldFocusChange(context, _secondaryPhoneFocusNode, null);
            setState(() {
              company.category = value;
            });
          },
          value: company.category,
          titleText: 'Categoría',
          hintText: '',
          dataSource: [
            {'display': 'Logística', 'value': 'Logistica'},
            {'display': 'Publicidad', 'value': 'Publicidad'},
            {'display': 'Producción', 'value': 'Produccion'},
            {'display': 'Entretenimiento', 'value': 'Entretenimiento'},
            {'display': 'Gastronomía', 'value': 'Gastronomia'},
            {'display': 'Otro', 'value': 'Otro'},
          ],
          textField: 'display',
          valueField: 'value',
          validator: (value) {
            if (value == null) {
              return 'Categoría inválida';
            }
            return null;
          },
        ));
  }

  registerCompany() async {
    if (_image != null) {
      company.profilePic = await firebaseProvider.uploadFile(
          _image, 'company/' + _image.path.split('/').last, 'image');
    }
    User user = new User();
    user.roles.add('ADMINISTRATOR');
    //var materialPageRoute;
    //materialPageRoute = MaterialPageRoute(builder: (_) => new RegisterUser3Page(info: {'user':user.toJson(), 'company':company.toJson()}, image: null));
    //Navigator.push(context, materialPageRoute);

    Navigator.pushNamed(context, 'registerUser1',
        arguments:
            jsonEncode({'rol': 'ADMINISTRATOR', 'company': company.toJson()}));
  }
}
