import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worki_ui/src/models/applicant_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:worki_ui/src/providers/applicant_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddJobPage extends StatefulWidget {
  AddJobPage({Key key}) : super(key: key);

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  Job job = new Job();
  Applicant applicant = new Applicant();
  JobsProvider jobsProvider = new JobsProvider();
  ApplicantsProvider applicantProvider = new ApplicantsProvider();
  Event event;
  FocusNode _nameFocusNode = new FocusNode();
  FocusNode _descriptionFocusNode = new FocusNode();
  FocusNode _salaryFocusNode = new FocusNode();
  FocusNode _initialDateFocusNode = new FocusNode();
  FocusNode _finalDateFocusNode = new FocusNode();
  FocusNode _closeDateFocusNode = new FocusNode();
  FocusNode _maxWorkersFocusNode = new FocusNode();

  FirebaseProvider firebaseProvider = new FirebaseProvider();
  File _image;
  List<String> _functions = [];

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

  void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.workiColor),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Crear trabajo en '+event.name, 
          style: TextStyle(color:Colors.black)
        ),
      ),
      body: ListView(

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
                  
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _submitButton(),
    );
  }

  Widget _nameInput() {
    return ListTile(
      leading: Icon(Icons.note_add, size: 30, color: AppColors.workiColor),
      title: TextFormField(
        focusNode: _nameFocusNode,
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
      leading: Icon(Icons.description, size: 30,color: AppColors.workiColor),
      title: TextFormField(
        focusNode: _descriptionFocusNode,
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
        focusNode: _salaryFocusNode,
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
        format: DateFormat('yyyy-MM-dd'),
        initialValue: event.initialDate,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
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
        format: DateFormat('yyyy-MM-dd'),
        initialValue: event.finalDate,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
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
      title: DateTimeField(
        focusNode: _closeDateFocusNode,
        format: DateFormat('yyyy-MM-dd'),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2021));
        },
        decoration: new InputDecoration(
          labelText: "Fecha de cierre proceso de selección",
        ),
        validator: (value) {
          if (value == null) {
            return 'Fecha inválida';
          }
          return null;
        },
        onSaved: (value) => applicant.closeDate = value,
        onFieldSubmitted: (_) {
          fieldFocusChange(context, _initialDateFocusNode, _finalDateFocusNode);
        },
      ),
    );
  }

  Widget _maxWorkersInput() {
    return ListTile(
      leading: Icon(Icons.attach_money, size: 30, color: AppColors.workiColor),
      title: TextFormField(
        focusNode: _maxWorkersFocusNode,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
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
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10)

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

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: ButtonDecoration.workiButton,
      child: FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              job.functions = [];
              job.companyId = event.companyId;
              job.eventId = event.id;
              job.state = true;
              job.people = 0;
              saveJob(job, applicant);
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
      message: 'Creando Trabajo',
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
      job.jobPic = await firebaseProvider.uploadFile(_image, 'job/' + _image.path.split('/').last, 'image');
    }
    final resp = await jobsProvider.saveJob(job);

    if (resp != null) {
      applicant.jobId = resp['id'];
      applicant.workersId = [];
      Map<String, dynamic> data =
          await applicantProvider.saveApplicant(applicant);
      if (data['ok']) {
        //showAlert(context, 'Trabajo creado exitosamente');
        
        if (pr.isShowing()) pr.hide();
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Center(child: Text('Trabajo creado exitosamente')),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async{
                    Navigator.of(context).popUntil(ModalRoute.withName('admin_main'));
                  }, 
                  child: Text('Ok')
                ),
              ],
            );
          }
        );
      } else {
        data['message'] != null
            ? showAlert(
                context, "No es posible crear el trabajo. " + data['message'])
            : showAlert(context, "No es posible crear el trabajo. ");
      }
      //Navigator.of(context).pushNamed('worker_main');
    } else {
      showAlert(context,
          'Parece que ha ocurrido un error, por favor intenta de nuevo');
    }
  }
}
