import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/applicant_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/providers/applicant_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/models/notification_model.dart';
import 'package:worki_ui/src/providers/push_notifications_provider.dart';

class EditJobPage extends StatefulWidget {
  EditJobPage({Key key}) : super(key: key);

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  Job job = new Job();
  Applicant applicant = new Applicant();
  JobsProvider jobsProvider = new JobsProvider();
  ApplicantsProvider applicantProvider = new ApplicantsProvider();
  FocusNode _nameFocusNode = new FocusNode();
  FocusNode _descriptionFocusNode = new FocusNode();
  FocusNode _salaryFocusNode = new FocusNode();
  FocusNode _initialDateFocusNode = new FocusNode();
  FocusNode _finalDateFocusNode = new FocusNode();
  FocusNode _closeDateFocusNode = new FocusNode();
  FocusNode _maxWorkersFocusNode = new FocusNode();

  TextEditingController _jobFunction = new TextEditingController();
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  File _image;
  List<String> _functions = [];
  PushNotificationProvider pushProvider = new PushNotificationProvider();
  NotificationModel notification = new NotificationModel();

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

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    job = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.workiColor),
        elevation: 0.0,
        centerTitle: true,
        title: Text('Editar Trabajo ', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.only(bottom: 70.0),
                  child: Column(
                    children: <Widget>[
                      _nameInput(),
                      _descriptionInput(),
                      _salaryInput(),
                      _initialDateInput(),
                      _finalDateInput(),
                      SizedBox(
                        height: 20,
                      ),
                      _jobFunctions(),
                      SizedBox(
                        height: 20,
                      ),
                      _jobPicture(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Proceso de selección',
                        textAlign: TextAlign.center,
                      ),
                      _closeDate(),
                      _maxWorkersInput(),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _submitButton(),
          ),
        ],
      ),
    );
  }

  Widget _nameInput() {
    return ListTile(
      leading: Icon(Icons.note_add, size: 30, color: AppColors.workiColor),
      title: TextFormField(
        autofocus: false,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _nameFocusNode,
        initialValue: job.name,
        decoration: InputDecoration(
          labelText: 'Nombre',
        ),
        onSaved: (value) => job.name = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _nameFocusNode, _descriptionFocusNode);
        },
      ),
    );
  }

  Widget _descriptionInput() {
    return ListTile(
      leading: Icon(Icons.description, size: 30, color: AppColors.workiColor),
      title: TextFormField(
        autofocus: false,
        textCapitalization: TextCapitalization.sentences,
        focusNode: _descriptionFocusNode,
        initialValue: job.description,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Descripción',
        ),
        onSaved: (value) {
          job.description = value;
        },
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _descriptionFocusNode, _salaryFocusNode);
        },
      ),
    );
  }

  Widget _salaryInput() {
    return ListTile(
      leading: Icon(Icons.attach_money, size: 30, color: AppColors.workiColor),
      title: TextFormField(
        autofocus: false,
        autocorrect: false,
        focusNode: _salaryFocusNode,
        initialValue: job.salary.toString(),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Salario',
        ),
        onSaved: (value) => job.salary = double.parse(value),
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _descriptionFocusNode, _salaryFocusNode);
        },
      ),
    );
  }

  Widget _initialDateInput() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color: AppColors.workiColor),
      title: DateTimeField(
        focusNode: _initialDateFocusNode,
        format: DateFormat('dd-MM-yyyy'),
        initialValue: job.initialDate,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: job.initialDate,
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        decoration: new InputDecoration(
          labelText: "Fecha Inicial",
        ),
        validator: (value) {
          if (value == null) {
            return 'Fecha inicial inválida';
          }
          return null;
        },
        onSaved: (value) => job.initialDate = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _initialDateFocusNode, _finalDateFocusNode);
        },
      ),
    );
  }

  Widget _finalDateInput() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color: AppColors.workiColor),
      title: DateTimeField(
        focusNode: _finalDateFocusNode,
        format: DateFormat('dd-MM-yyyy'),
        initialValue: job.finalDate,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: job.initialDate,
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        decoration: new InputDecoration(
          labelText: "Fecha final",
        ),
        validator: (value) {
          if (value == null) {
            return 'Fecha final inválida';
          }
          return null;
        },
        onSaved: (value) {
          job.finalDate = value;
        },
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _initialDateFocusNode, _closeDateFocusNode);
        },
      ),
    );
  }

  _closeDate() {
    return ListTile(
      leading: Icon(Icons.event, size: 30, color: AppColors.workiColor),
      title: new DateTimeField(
        focusNode: _closeDateFocusNode,
        format: DateFormat('dd-MM-yyyy'),
        initialValue: job.initialDate,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: job.initialDate);
        },
        decoration: new InputDecoration(
          labelText: "Fecha de cierre proceso de selección",
        ),
        onSaved: (value) => applicant.closeDate = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _initialDateFocusNode, _finalDateFocusNode);
        },
      ),
    );
  }

  Widget _maxWorkersInput() {
    return ListTile(
      leading: Icon(Icons.work, size: 30, color: AppColors.workiColor),
      title: TextFormField(
        autofocus: false,
        focusNode: _maxWorkersFocusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        initialValue: job.people.toString(),
        decoration: InputDecoration(
          labelText: 'Número de vacantes',
        ),
        onSaved: (value) => applicant.maxWorkers = int.parse(value),
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _descriptionFocusNode, _salaryFocusNode);
        },
      ),
    );
  }

  Widget _jobPicture() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Row(
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
          Container(
            height: 180.0,
            width: 500,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(10)),
            child: FlatButton(
                onPressed: getImage,
                child: _image == null
                    ? Center(
                        child: job.jobPic != '' && job.jobPic != null
                            ? Image.network(job.jobPic, fit: BoxFit.cover)
                            : Icon(Icons.image, color: Colors.white, size: 40))
                    : Image.file(_image)),
          ),
        ],
      ),
    );
  }

  Widget _jobFunctions() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.format_list_numbered,
            color: Color.fromRGBO(0, 167, 255, 1.0),
            size: 30,
          ),
          title: TextField(
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Funciones',
            ),
            controller: _jobFunction,
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_circle_outline,
                color: AppColors.workiColor, size: 30),
            onPressed: () {
              setState(() {
                if (_jobFunction.text != '') {
                  job.functions.add(_jobFunction.text);
                  _jobFunction.text = '';
                }
              });
              //notifyParent();
            },
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: job.functions.length == 0 ? 0 : 50,
          padding: EdgeInsets.only(left: 10),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: job.functions.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Chip(
                    deleteIconColor: AppColors.workiColor,
                    label: Text(job.functions[i]),
                    onDeleted: () {
                      setState(() {
                        job.functions.remove(job.functions[i]);
                      });
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: job.registeredIds.length != 0 
        ? BoxDecoration(
          color: Colors.grey,
        )
        : ButtonDecoration.workiButton,
      child: FlatButton(
          onPressed: () {
            if(job.registeredIds.length == 0){
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                job.state = true;
                saveJob(job, applicant);
              }
            }else{
              showAlert(
                context, 
                'No se puede modificar el trabajo debido a que ya hay personas registradas. Deberá borrar los registros si desea modificar este trabajo.'
              );
            }
          },
          child: Text(
            'GUARDAR',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  saveJob(Job job, Applicant applicant) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Actualizando Trabajo',
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
      job.jobPic = await firebaseProvider.uploadFile(
          _image, 'job/' + _image.path.split('/').last, 'image');
    }
    final resp = await jobsProvider.updateJob(job);
    
    if (resp != null) {
      Map<String, String> noti = {
        'title': job.name,
        'body': 'Parece que hubo un cambio en el trabajo '+job.name,
        'color': '#3bb4fe',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK'
      };
      Map<String, String> notiData = {
        'page': 'chat_page',
        'document': job.id
      };
      notification.to = '';
      notification.notification = noti;
      notification.data = notiData;
      print('MENSAJES');
      job.workersId.forEach((w) {
        print(w);
        pushProvider.sendNotification(notification, w);
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Trabajo actualizado exitosamente')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok')),
            ],
          );
        }
      );
    } else {
      showAlert(context,
          'Parece que ha ocurrido un error, por favor intenta de nuevo');
    }
  }
}
