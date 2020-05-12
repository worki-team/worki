import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/workExperience_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/values.dart';

class PersonalReferencesPage extends StatefulWidget {
  final Worker worker;
  final Function() notifyParent;
  PersonalReferencesPage({@required this.worker, this.notifyParent});
  @override
  _PersonalReferencesPageState createState() =>
      _PersonalReferencesPageState(worker: this.worker, notifyParent: this.notifyParent);
}

class _PersonalReferencesPageState extends State<PersonalReferencesPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  final Worker worker;
  Function() notifyParent;

  _PersonalReferencesPageState({this.worker,this.notifyParent});
  final workerProvider = new WorkerProvider();
  bool _newExperience = false;
  String _experiencia;
  TextEditingController _referenceName = new TextEditingController();
  TextEditingController _referenceEmail = new TextEditingController();
  TextEditingController _referencePhone = new TextEditingController();

  TextEditingController _position = new TextEditingController();
  TextEditingController _company = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  String _city;
  DateTime initialDate;
  DateTime finalDate;

  bool _positionError = false;
  FilePicker _filePath;

  @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Referencia Personal',
                style: TextStyle(fontFamily: 'Trebuchet', fontSize: 25, fontWeight: FontWeight.bold),

              ),
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0),
                _referenceNameInput(),
                SizedBox(height: 10.0),
                _referenceEmailInput(),
                SizedBox(height: 10.0),
                _referencePhoneInput(),
                SizedBox(height: 30.0),
                _experience(),
                SizedBox(height: 10.0),
              ],
            ),
            SizedBox(height: 10.0),
            
          ],
        ),
      );
    }


  Future getFile() async {
    //YA CASI ESTÁ SOLO FALTA SOLUCIONAR ESTA MONDÁ
    String filePath = await FilePicker.getFilePath(type: FileType.ANY);
    setState(() {
      _filePath = filePath as FilePicker;
    });
  }

  removeFile() async {
    //Quitar imagen de la empresa
    setState(() {
      _filePath = null;
    });
  }

  
  Widget _referenceNameInput() {
    return ListTile(
      leading: Icon(
        Icons.person_outline,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: 'Nombre de tu referencia',
        ),
        //controller:_referenceName,
        validator: (value) {
          if (value == '') {
            return 'Nombre inválido';
          }
          return null;
        },
        initialValue: worker.personalReference,
        onChanged: (value){
          worker.personalReference = value;
          notifyParent();
        },
      )
    );
  }

  Widget _referenceEmailInput() {
    return ListTile(
      leading: Icon(
        Icons.alternate_email,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: TextFormField(
        enabled: true,
        decoration: InputDecoration(
          hintText: 'Correo de tu referencia',
        ),
        //controller:_referenceEmail,
        initialValue: worker.referenceEmail,
        validator: (value) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return 'Email inválido';
          }
          return null;
        },
        onChanged: (value){
          worker.referenceEmail = value;
          notifyParent();
        },
      ),
    );
  }

  Widget _referencePhoneInput() {
    return ListTile(
      leading: const Icon(
        Icons.phone_iphone,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: TextFormField(
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Celular de tu referencia',
        ),
        //controller: _referencePhone,
        validator: (value) {
          if (value == '') {
            return 'Número inválido';
          }
          return null;
        },
        initialValue: worker.referencePhone.toString(),
        onChanged: (value){
          worker.referencePhone = int.parse(value);
          notifyParent();
        },
      ),
    );
  }

  Widget _experience() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Experiencia Laboral',
                  style: TextStyle(fontFamily: 'Trebuchet', fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _newExperience = !_newExperience;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _newExperience == false ? 
                      Icon(Icons.arrow_drop_down, color: Color.fromRGBO(0, 167, 255, 1.0))
                      :Icon(Icons.arrow_drop_up, color: Color.fromRGBO(0, 167, 255, 1.0)),
                    Text('Agrega Experiencia',style: TextStyle(fontSize: 18))
                  ],
                ),
              ),
              _cv(),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(
          //duration:Duration(milliseconds:500),
          padding: EdgeInsets.all(20),
          height: _newExperience == false ? 0 : 500,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black38
              )
            ],
            color: Colors.white
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: _positionError != false ? InputDecoration(
                  labelText: 'Cargo',
                  errorText: '*Obligatorio',
                  errorStyle: TextStyle(color: Colors.red),
                ) : InputDecoration(
                  labelText: 'Cargo',
                ),
                controller: _position,
                validator: (value) {
                  if (value == '') {
                    return 'Valor invalido';
                  }
                  return null;
                },
                onChanged: (value){
                  if(value == ''){
                    setState(() {
                      _positionError = true;
                    });
                  }else{
                    setState(() {
                      _positionError = false;
                    });
                  }
                },
              ),
              TextFormField(
                
                decoration: InputDecoration(
                  labelText: 'Compañía'
                ),
                controller: _company,
                validator: (value) {
                  if (value == '') {
                    return 'Valor invalido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              Text('Descripción:'),
              SizedBox(height: 5,),
              Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.workiColor, width: 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  maxLines: 3,
                  controller: _description,
                  validator: (value) {
                    if (value == '') {
                      return 'Valor invalido';
                    }
                    return null;
                  },
                ),
              ),
              DropdownButton(
                hint: Text('Ciudad'),
                isExpanded: true,
                value: _city,
                itemHeight: 50.0,
                items: <String>['Bogotá', 'Medellin', 'Cali','Bucaramanga','Barranquilla','Pereira','Manizales','Armenia','Cartagena','Santa Marta','Otra','']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _city = newValue;
                  });
                }
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2.4,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.workiColor,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DateTimeField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5.calendar_check, size:20, color: AppColors.workiColor),
                        contentPadding: EdgeInsets.only(top:15),
                        hintText: 'Fecha inicial',
                        
                      ),
                      format: DateFormat('dd-MM-yyyy'),
                      onChanged: (date){
                        setState(() {
                          initialDate = date;
                        });
                      },
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: currentValue ?? DateTime(2000),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime.now()
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2.4,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.workiColor,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: DateTimeField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5.calendar_times, size:20, color: AppColors.workiColor),
                        contentPadding: EdgeInsets.only(top:15),
                        hintText: 'Fecha final',
                        
                      ),
                      format: DateFormat('dd-MM-yyyy'),
                      onChanged: (date){
                        setState(() {
                          finalDate = date;
                        });
                      },
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: currentValue ?? DateTime(2000),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime.now()
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Center(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  decoration: ButtonDecoration.workiButton,
                  child: FlatButton(
                    onPressed: (){
                      WorkExperience w = new WorkExperience();
                      if(_position.text == ''){
                        setState((){
                          _positionError = true;
                        });
                      }else{
                        setState((){
                          _positionError = false;
                        });
                      }
                      if(_city != '' && _company.text != '' && _position.text !='' && _description.text!=''&&initialDate != null && finalDate != null){
                        w.city = _city;
                        _city = '';
                        w.company = _company.text;
                        _company.text = '';
                        w.position = _position.text;
                        _position.text = '';
                        w.description = _description.text;
                        _description.text = '';
                        w.initialYear = initialDate;
                        initialDate = null;
                        w.finalYear = finalDate;
                        //finalDate = null;
                        print('AGREGAR');
                        setState(() {
                          worker.workExperience.add(w);
                        });
                        notifyParent();
                      }else{
                        print('FALTA ALGÚN CAMPO');
                      }

                    }, 
                    child: Icon(Icons.add, color: Colors.white)
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: worker.workExperience.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, i){
            WorkExperience w = worker.workExperience[i];
            return ListTile(
              title: Text(w.position + ' - '+w.company),
              subtitle: Text(w.description),
              trailing: IconButton(
                icon: Icon(FontAwesome5.trash_alt, color: Colors.red), 
                onPressed: (){
                  setState(() {
                    worker.workExperience.remove(w);
                  });
                }
              ),
            );
          }
        ),
      ],
    );
  }

  Widget _cv() {
    return GestureDetector(
      onTap: () {
        getFile();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add, color: Color.fromRGBO(0, 167, 255, 1.0)),
          Text('Agrega Archivo',style: TextStyle(fontSize: 18))
        ],
      ),
    );
  }

  void updateWorker(Worker worker) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Actualizando el perfil',
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
    worker.personalReference  = _referenceName.text;
    worker.referenceEmail = _referenceEmail.text;
    worker.referencePhone = _referencePhone.text as int;
    worker.workExperience = _experiencia as List<WorkExperience>;

    Map<String, dynamic> data = await workerProvider.updateWorker(worker);
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

