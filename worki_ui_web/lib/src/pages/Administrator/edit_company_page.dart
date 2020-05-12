import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/gradients.dart';

class EditCompanyPage extends StatefulWidget {
  EditCompanyPage({Key key}) : super(key: key);

  @override
  _EditCompanyPageState createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _nitFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  Company company = new Company();
  File _image; //foto de perfil de la empresa

  CompanyProvider companyProvider = new CompanyProvider();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _secondaryPhoneFocusNode = FocusNode();
  String category;
  FirebaseProvider firebaseProvider = new FirebaseProvider();
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
      company.profilePic = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    company = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Información de tu empresa',
          style: TextStyle(color: Colors.black)
        ),
        centerTitle: true,
        elevation: 0.0,

        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Color.fromRGBO(0, 167, 255, 0.7)),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          Icon(Icons.add),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                _profilePhoto(),
                SizedBox(height: 10.0),
                _nameInput(),
                SizedBox(height: 10.0),
                _nitInput(),
                SizedBox(height: 10.0),
                _descriptionInput(),
                SizedBox(height: 10.0),
                _addressInput(),
                SizedBox(height: 20.0),
                SizedBox(height: 10.0),
                _inputPhone(),
                SizedBox(height: 10.0),
                _inputSecondaryPhone(),
                SizedBox(height: 25.0),
                _inputCategory(),
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        width:MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: Gradients.workiGradient
        ),
        child: MaterialButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              company.category = category;
              updateCompany(company);
            }
          },
          textColor: Colors.white,
          child: Text("Guardar".toUpperCase(),
              style: TextStyle(fontSize: 15)),
        ),
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Widget _nameInput() {
    return new ListTile(
      leading: const Icon(
        Icons.business,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: company.name,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _nameFocusNode,
        decoration: new InputDecoration(
          hintText: "Nombre de la empresa",
        ),
        validator: (value) {
          if (value == '') {
            return 'Nombre inválido';
          }
          return null;
        },
        onSaved: (value) => company.name = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _nameFocusNode, _nitFocusNode);
        },
      ),
    );
  }

  Widget _nitInput() {
    return new ListTile(
      leading: const Icon(
        Icons.assignment,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: company.nit.toString(),
        focusNode: _nitFocusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "NIT de tu empresa",
        ),
        validator: (value) {
          if (value == '') {
            return 'NIT inválido';
          }
          return null;
        },
        onSaved: (value) => company.nit = int.parse(value),
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _nitFocusNode, _descriptionFocusNode);
        },
      ),
    );
  }

  Widget _descriptionInput() {
    return new ListTile(
      leading: const Icon(
        Icons.description,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: company.description,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _descriptionFocusNode,
        maxLines: 3,
        decoration: new InputDecoration(
          hintText: "Descripción de la empresa",
        ),
        validator: (value) {
          if (value == '') {
            return 'Descripción inválida';
          }
          return null;
        },
        onSaved: (value) => company.description = value,
      ),
    );
  }

  Widget _addressInput() {
    return new ListTile(
      leading: const Icon(
        Icons.location_on,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: company.address,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _addressFocusNode,
        decoration: new InputDecoration(
          hintText: "Dirección",
        ),
        validator: (value) {
          if (value == '') {
            return 'Dirección inválida';
          }
          return null;
        },
        onSaved: (value) => company.address = value,
      ),
    );
  }

  Widget _inputPhone() {
    return ListTile(
      leading: const Icon(
        Icons.phone,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: company.phone.toString(),
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
        initialValue: company.secondaryPhone.toString(),
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
            setState(() {
              category = value;
              company.category = value;
            });
          },
          value: company.category,
          titleText: 'Categoría',
          hintText: '',
          dataSource: [
            {'display': 'Logística', 'value': 'Logistica'},
            {'display': 'Publicidad', 'value': 'Publicidad'},
            {'display': 'Produccion', 'value': 'Produccion'},
            {'display': 'Entretenimiento', 'value': 'Entretenimiento'},
            {'display': 'Gastronomía', 'value': 'Gastronomia'},
          ],
          textField: 'display',
          valueField: 'value',
          validator: (value) {
            if (value == null) {
              value = company.category;
            }
            return null;
          },
        ));
  }

  _profilePhoto() {
    return Column(
      children: <Widget>[
        Container(
          height: 180.0,
          width: 180.0,
          child: FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Pick Image',
              child: company.profilePic == '' && _image == null
                  ? CircleAvatar(
                      backgroundImage:
                          ExactAssetImage('assets/noprofilepic.png'),
                      radius: 100.0,
                      backgroundColor: Colors.transparent,
                    )
                  : company.profilePic == '' && _image != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_image),
                          radius: 100.0,
                          backgroundColor: Colors.transparent,
                        )
                      : company.profilePic != '' && _image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(_image),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(company.profilePic),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )),
        ),
        SizedBox(
          height: 10.0,
        ),
        GestureDetector(
          onTap: () {
            removeImage();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.delete, color: Color.fromRGBO(0, 167, 255, 1.0)),
              Text('Borrar foto de perfil')
            ],
          ),
        ),
      ],
    );
  }

  void updateCompany(Company company) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Actualizando la empresa',
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

    if (_image != null) {
      company.profilePic = await firebaseProvider.uploadFile(
          _image, 'profilePic/' + _image.path.split('/').last, 'image');
    }

    Map<String, dynamic> data = await companyProvider.updateCompany(company);
    if (pr.isShowing()) pr.hide();
    if (data['ok']) {
      showAlert(context, 'Se ha actualizado satisfactoriamente');
    } else {
      data['message'] != null
          ? showAlert(
              context, "No es posible actualizar los datos. " + data['message'])
          : showAlert(context, "No es posible actualizar los datos.");
    }
  }
}
