import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/colors.dart';

class SpecificEventPage extends StatefulWidget {
  Event event;
  SpecificEventPage({@required this.event});

  @override
  _SpecificEventPageState createState() => _SpecificEventPageState(event: this.event);
}

class _SpecificEventPageState extends State<SpecificEventPage> {
  final eventProvider = new EventsProvider();
  final _formKey = GlobalKey<FormState>();
  Administrator admin;
  Company company;
  Event event;
  final format = DateFormat("yyyy-MM-dd");
  FirebaseProvider firebaseProvider = FirebaseProvider();
  _SpecificEventPageState({this.event});

  EventsProvider _eventsProvider = new EventsProvider();
  List<Event> events;
  String state;
  String eventType;
  File _image;


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
  Widget build
(BuildContext context) {
    event = ModalRoute.of(context).settings.arguments;
    return Scaffold(
    appBar: AppBar(
      title: Text(
          'Información evento',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
    ),
    body: ListView(
        children: <Widget>[
          Form(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Nombre evento: ',
                   textAlign: TextAlign.start,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                  _nameInput(),
                Text(
                  'Id: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                  _idInput(),
                Text(
                  'Descripción: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                _descriptionInput(),
                Text(
                  'Dirección: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                _addressInput(),
                Text(
                  'Duración: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                _durationInput(),
                Text(
                  'Fecha inicial: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                _initialDateInput(),
                Text(
                  'Fecha final: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                _finalDateInput(),
                Text(
                  'Estado: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                _stateInput(),
                Text(
                  'Total trabajos: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                _totalJobsInput(),
                Text(
                  'Tipo de evento: ',
                   textAlign: TextAlign.center,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decorationStyle: TextDecorationStyle.solid,
                      fontFamily: 'Lato'),
                ),
                _typeEventInput(),
                _eventPicture(),
                _submitButton(),              
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _nameInput() {
    return ListTile(
      leading: Icon(Icons.star, size: 30, color:AppColors.workiColor),
      title: TextFormField(
        initialValue: event.name,
        decoration: InputDecoration(
          //labelText: event.name,
        ),
        onSaved: (value) => event.name = value,
      ),
    );
  }
    Widget _idInput() {
    return ListTile(
      leading: Icon(Icons.looks_one, size: 30, color:AppColors.workiColor),
      title: TextFormField(
        initialValue: event.id,
        decoration: InputDecoration(
          //labelText: event.id,
        ),
        
        onSaved: (value) => event.id = value,
      ),
    );
  }
    Widget _descriptionInput() {
    return ListTile(
      leading: Icon(Icons.textsms, size: 30, color:AppColors.workiColor),
      title: TextFormField(
        initialValue: event.description,
        decoration: InputDecoration(
          //labelText: event.description,
        ),
        onSaved: (value) => event.description = value,
      ),
    );
  }
  Widget _addressInput() {
    return ListTile(
      leading: Icon(Icons.location_on, size: 30, color:AppColors.workiColor),
      title: TextFormField(
        initialValue: event.address,
        decoration: InputDecoration(
          //labelText: event.address,
        ),
        onSaved: (value) => event.address = value,
      ),
    );
  }
  Widget _durationInput() {
    return ListTile(
      leading: Icon(Icons.timer, size: 30, color:AppColors.workiColor),
      title: TextFormField(
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        initialValue: event.duration.toString(),
        decoration: InputDecoration(
          //labelText: event.duration.toString(),
        ),
        onSaved: (value) => event.duration = int.parse(value),
      ),
    );
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
        decoration: new InputDecoration(
          labelText: event.getInitialDate(),
        ),
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
        decoration: new InputDecoration(
          labelText: event.getFinalDate(),
        ),
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


  Widget _stateInput() {
    return ListTile(
      leading: Icon(Icons.done, size: 30, color:AppColors.workiColor),
        title: new DropDownFormField(
        onSaved: (value) => event.state = value,
        onChanged: (value) {
          setState(() {
            state = value;
            event.state = value;
          });
        },
        titleText: 'Estado',
        value: event.state,
        dataSource: [
          {'display': 'Activo', 'value': true},
          {'display': 'Inactivo', 'value': false}
        ],
        textField: 'display',
        valueField: 'value',
        validator: (value) {
          if (value == null) {
            value = event.state;
          }
          return null;
        },
      ),
    );
  }
  Widget _totalJobsInput() {
    return ListTile(
      leading: Icon(Icons.group, size: 30, color:AppColors.workiColor),
      title: TextFormField(
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        initialValue: event.totalJobs.toString(),
        decoration: InputDecoration(
          //labelText: event.totalJobs.toString(),
        ),
        onSaved: (value) => event.totalJobs = int.parse(value),
      ),
    );
  }
  Widget _typeEventInput() {
    return ListTile(
      leading: Icon(Icons.list, size: 30, color:AppColors.workiColor),
      title: new DropDownFormField(
        onSaved: (value) => event.eventType = value,
        onChanged: (value) {
          setState(() {
            eventType = value;
            event.eventType = value;
          });
        },
        titleText: 'Tipo de evento',
        value: event.eventType,
        dataSource: [
          //'PUBLICIDAD', 'LOGISTICA','PRODUCCIÓN','E. MERCADO', 'OTROS'
          {'display': 'PUBLICIDAD', 'value': 'PUBLICIDAD'},
          {'display': 'LOGISTICA', 'value': 'PUBLICIDAD'},
          {'display': 'PRODUCCIÓN', 'value': 'PRODUCCIÓN'},
          {'display': 'E. MERCADO', 'value': 'ESTUDIO DE MERCADO'},
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
      ),
    );
  }
  
  Widget _submitButton() {
    return Center(
      child: Container(
        width: 500,
        margin: EdgeInsets.all(10.0),
        decoration: ButtonDecoration.workiButton,
        child:FlatButton(
                    color: AppColors.workiColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        event.eventType = eventType;
                        updateEvent(event);
                      }
                    },
                    child: Text(
                      'Actualizar',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                  )
      ),
    );
  }
void updateEvent(Event event) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Actualizando el evento',
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
          _image, 'profilePic/' + _image.path.split('/').last, 'image');
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


saveEvent(Event event) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      message: 'Creando Evento',
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
      event.eventPic = await firebaseProvider.uploadFile(_image, 'event/' + _image.path.split('/').last, 'image'); 
    }
    final resp = await EventsProvider().saveEvent(event);
    if (pr.isShowing()) pr.hide();

    if (resp != null) {
      showAlert(context, 'Evento creado exitosamente');
      
      Navigator.of(context).pushReplacementNamed('admin_main', arguments: {'admin':admin,'company':company});
    } else {
      showAlert(context,'Parece que ha ocurrido un error, por favor intenta de nuevo');
    }
  }

  Widget _eventPicture() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Fotografía',
                  style: TextStyle(
                      fontFamily: 'Trebuchet', fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    removeImage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.delete, color: Color.fromRGBO(0, 167, 255, 1.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 180.0,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12
            ),
            
            child: FlatButton(
                onPressed: getImage,
                child: _image == null
                    ? Center(
                        child: Icon(Icons.image, color: Colors.white, size: 40))
                    : Image.file(_image)),
          ),
        ],
      ),
    );
  }


}