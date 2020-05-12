import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';

class EditEventPage extends StatefulWidget {
  EditEventPage({Key key}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _nitFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  Company company = new Company();
  Event event = new Event();
  File _image; //foto de perfil de la empresa
  FirestoreProvider firestoreProvider = new FirestoreProvider();

  EventsProvider eventProvider = new EventsProvider();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _secondaryPhoneFocusNode = FocusNode();
  String category;
  String eventType;
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
      event.eventPic = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Editar Evento',
          style: TextStyle(
            color: Colors.black
          )
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
          icon:Icon(Icons.arrow_back, color: Color.fromRGBO(0, 167, 255, 0.7)),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesome5.trash_alt, color: Colors.red, size: 18),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Text('¿Está seguro que desea eliminar este evento? Se eliminarán todos los trabajos y registros asociados:'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Si'),
                        onPressed: () async {
                          firestoreProvider.deleteChat(event.id);
                          eventProvider.deleteEvent(event.id);
                          Navigator.of(context).popUntil((route)=> route.isFirst);
                          setState(() {});
                        }, 
                      ),
                      FlatButton(
                        child: Text('No'),
                        onPressed: (){
                          Navigator.of(context).pop();
                        }, 
                      )
                    ],
                  );
                }
              );
            },
          )
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
                _eventPhoto(),
                SizedBox(height: 10.0),
                _nameInput(),
                SizedBox(height: 10.0),
                _descriptionInput(),
                SizedBox(height: 10.0),
                _addressInput(),
                SizedBox(height: 20.0),
                _inputTotalJobs(),
                SizedBox(height: 25.0),
                _inputEventType(),
                SizedBox(height: 25.0),
                _initialDateInput(),
                SizedBox(height: 25.0),
                _finalDateInput(),
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: Gradients.workiGradient
        ),
        child: MaterialButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              event.eventType = eventType;
              updateEvent(event);
            }
          },
          textColor: Colors.white,
          child: Text("Guardar".toUpperCase(),
              style: TextStyle(fontSize: 14)),
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
        initialValue: event.name,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _nameFocusNode,
        decoration: new InputDecoration(
          hintText: "Nombre del evento",
        ),
        validator: (value) {
          if (value == '') {
            return 'Nombre inválido';
          }
          return null;
        },
        onSaved: (value) => event.name = value,
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
        initialValue: event.description,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _descriptionFocusNode,
        maxLines: 3,
        decoration: new InputDecoration(
          hintText: "Descripción del evento",
        ),
        validator: (value) {
          if (value == '') {
            return 'Descripción inválida';
          }
          return null;
        },
        onSaved: (value) => event.description = value,
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
        initialValue: event.address,
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
        onSaved: (value) => event.address = value,
      ),
    );
  }

  Widget _inputTotalJobs() {
    return ListTile(
      leading: const Icon(
        Icons.group,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: new TextFormField(
        initialValue: event.totalJobs.toString(),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: new InputDecoration(
          hintText: "Número de trabajos",
        ),
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        onSaved: (value) => event.totalJobs = int.parse(value),
      ),
    );
  }

  Widget _inputEventType() {
    return ListTile(
        leading: const Icon(
          Icons.category,
          color: Color.fromRGBO(0, 167, 255, 1.0),
          size: 30,
        ),
        title: new DropDownFormField(
          
          onSaved: (value) => event.eventType = value,
          onChanged: (value) {
            setState(() {
              eventType = value;
              event.eventType = value;
            });
          },
          value: event.eventType,
          titleText: 'Tipo de evento',
          hintText: '',
          dataSource: [
            {'display': 'PUBLICIDAD', 'value': 'PUBLICIDAD'},
            {'display': 'LOGISTICA', 'value': 'LOGISTICA'},
            {'display': 'PRODUCCIÓN', 'value': 'PRODUCCIÓN'},
            {'display': 'E. MERCADO', 'value': 'E. MERCADO'},
            {'display': 'OTROS', 'value': 'OTROS'},
          ],
          textField: 'display',
          valueField: 'value',
          validator: (value) {
            if (value == null) {
              value = event.eventType;
            }
            return null;
          },
        ));
  }

  Widget _initialDateInput() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color:AppColors.workiColor),
      title: DateTimeField(
        //focusNode: _initialDateFocusNode,
        format: DateFormat('yyyy-MM-dd'),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        initialValue: event.initialDate,
        validator: (value) {
          if (value == null) {
            return 'Fecha inicial inválida';
          }
          return null;
        },
        onSaved: (value) => event.initialDate = value,
      ),
    );
  }


  Widget _finalDateInput() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color:AppColors.workiColor),
      title: DateTimeField(
        format: DateFormat('yyyy-MM-dd'),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        
        initialValue: event.finalDate,
        validator: (value) {
          if (value == null) {
            return 'Fecha final inválida';
          }
          return null;
        },
        onSaved: (value) {
        event.finalDate = value;
        },
      ),
    );
  }



  _eventPhoto() {
    return Column(
      children: <Widget>[
        Container(
          height: 180.0,
          width: 180.0,
          child: FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Pick Image',
              child: event.eventPic == '' && _image == null
                  ? CircleAvatar(
                      backgroundImage:
                          ExactAssetImage('assets/noprofilepic.png'),
                      radius: 100.0,
                      backgroundColor: Colors.transparent,
                    )
                  : event.eventPic == '' && _image != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_image),
                          radius: 100.0,
                          backgroundColor: Colors.transparent,
                        )
                      : event.eventPic != '' && _image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(_image),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(event.eventPic),
                              radius: 100.0,
                              backgroundColor: Colors.transparent,
                            )
          ),
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
              Text('Borrar foto del evento')
            ],
          ),
        ),
      ],
    );
  }

  void updateEvent(Event event) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Actualizando evento',
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
      event.eventPic = await firebaseProvider.uploadFile(
          _image, 'eventPic/' + _image.path.split('/').last, 'image');
    }

    Map<String, dynamic> data = await eventProvider.updateEvent(event);
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
