import 'dart:io';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/values.dart';

class EditMainPage extends StatefulWidget {
  final Worker worker;
  final Function() notifyParent;
  
  EditMainPage({@required this.worker, this.notifyParent});
  @override
  EditMainPageState createState() =>
      EditMainPageState(worker: this.worker, notifyParent: this.notifyParent);
}

class EditMainPageState extends State<EditMainPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  Worker worker;
  Function() notifyParent;
  EditMainPageState({this.worker, this.notifyParent});
  File image;
  final workerProvider = new WorkerProvider();
  final _formKey = GlobalKey<FormState>();

  String gender;
  String aux;
  final format = DateFormat("dd-MM-yyyy");
  String generoId;

  @override
  Widget build(BuildContext context) {
    print(image);
    return SingleChildScrollView(
        child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Datos Básicos',
              style: TextStyle(fontFamily: 'Trebuchet', fontSize: 25, fontWeight: FontWeight.bold),

            ),
          ),
          SizedBox(height: 30.0),
          _profilePhoto(),
          SizedBox(height: 10.0),
          Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              
              _nameInput(),
              SizedBox(height: 10.0),
              _emailInput(),
              SizedBox(height: 10.0),
              _idInput(),
              SizedBox(height: 10.0),
              _phoneInput(),
              SizedBox(height: 10.0),
              _dateBirthInput(),
              SizedBox(height: 10.0),
              //_genderInput(),
              _genderInput2(),
              SizedBox(height: 10.0),
              _cityOfResidency(),
              SizedBox(height: 100.0),
            ],
          ),
        ],
      ),
    ));
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
        enabled: true,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime.now());
        },
        decoration: new InputDecoration(
          hintText: worker.birthDate != null
              ? worker.birthDate.toIso8601String().substring(0, 10)
              : 'Fecha de nacimiento',
        ),
        initialValue: worker.birthDate,
        onChanged: (value){
          print(DateTime.now().difference(value).inDays);
          if(DateTime.now().difference(value).inDays < 6570){
            showAlert(context, 'Por favor revisa que la fecha sea correcta');
            worker.birthDate = null;
          }else{
            worker.birthDate = value;
          }
        },
        validator: (value) {
          if (value == null) {
            return 'Fecha de nacimiento inválido';
          }
          return null;
        },
      ),
    );
  }

  Widget _nameInput() {
    return new ListTile(
        leading: const Icon(
          Icons.person_outline,
          color: Color.fromRGBO(0, 167, 255, 1.0),
          size: 30,
        ),
        title: new TextFormField(
            autofocus: false,
            textCapitalization: TextCapitalization.sentences,
            decoration: new InputDecoration(
              hintText: worker.name,
            ),
            initialValue: worker.name,
            validator: (value) {
              if (value == '') {
                return 'Nombre inválido';
              }
              return null;
            },
            onSaved: (value) => worker.name = value,
            onChanged: (value) {
              worker.name = value;
              notifyParent();
            }));
  }

  Widget _emailInput() {
    return new ListTile(
      leading: const Icon(
        Icons.alternate_email,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        enabled: false,
        decoration: new InputDecoration(
          hintText: worker.email,
        ),
        initialValue: worker.email,
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
    );
  }

  Widget _idInput() {
    return new ListTile(
      leading: const Icon(
        Icons.credit_card,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        autofocus: false,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "Documento de identidad ",
        ),
        validator: (value) {
          if (value == '') {
            return 'Documento inválido';
          }
          return null;
        },
        //controller: _cardId,
        initialValue: worker.cardId,
        onChanged: (value){
          worker.cardId = value;
          notifyParent();
        },
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
      title: TextFormField(
        autofocus: false,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Celular',
        ),
        initialValue: worker.phone.toString(),
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        onSaved: (value) => worker.phone = int.parse(value),
        onChanged: (value) {
          worker.phone = int.parse(value);
          notifyParent();
        },
      ),
    );
  }

  Widget _genderInput2() {
    return ListTile(
      leading: Icon(
        Icons.wc,
        color: AppColors.workiColor
      ),
      title: DropdownButton(
        hint: Text('Género'),

        isExpanded: true,
        value: worker.gender,
        items: <String>['Femenino', 'Masculino', 'Otro','']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String newValue) {
          worker.gender = newValue;
          notifyParent();
        }
      ),
    );
  }

  Future getImage() async {
    //Obtener imagen de la galería
    var auxImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = auxImage;
    });
    worker.picFile = auxImage;
    notifyParent();
  }

  removeImage() async {
    //Quitar imagen de la empresa
    setState(() {
      image = null;
      worker.profilePic = '';
    });
  }

  Widget _profilePhoto() {
    return Center(
      child: Container(
        height: 150.0,
        width: 150.0,
        child: Stack(
          children: <Widget>[
            Container(
              height: 150.0,
              width: 150.0,
              child: FloatingActionButton(
                  onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: worker.profilePic == '' && image == null
                      ? CircleAvatar(
                          backgroundImage:
                              ExactAssetImage('assets/noprofilepic.png'),
                          radius: 100.0,
                          backgroundColor: Colors.transparent,
                        )
                      : worker.profilePic == '' && image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(image),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )
                          : worker.profilePic != '' && image != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(image),
                                  radius: 100.0,
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(worker.profilePic),
                                  radius: 100.0,
                                  backgroundColor: Colors.transparent,
                                )),
            ),
           
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  removeImage();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                     boxShadow: [
                       BoxShadow(
                         blurRadius: 5,
                         color: Colors.black38
                       )
                     ]
                  ),
                  child: Icon(Icons.delete, color: Color.fromRGBO(0, 167, 255, 1.0))
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cityOfResidency() {
    return ListTile(
      leading: const Icon(
        Icons.location_city,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: DropdownButton(
        hint: Text('Ciudad'),
        isExpanded: true,
        value: worker.city,
        itemHeight: 50.0,
        items: <String>['Bogotá', 'Medellin', 'Cali','Bucaramanga','Barranquilla','Pereira','Manizales','Armenia','Cartagena','Santa Marta','Otra','']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (String newValue) {
          worker.city = newValue;
          notifyParent();
        }
      ),
    );
  }
}
