import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/values.dart';

class EditMoreInfoPage extends StatefulWidget {
  final Worker worker;
  final Function() notifyParent;
  EditMoreInfoPage({@required this.worker, this.notifyParent});
  @override
  EditMoreInfoPageState createState() =>
      EditMoreInfoPageState(worker: this.worker, notifyParent: this.notifyParent);
}

class EditMoreInfoPageState extends State<EditMoreInfoPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  final Worker worker;
  Function() notifyParent;
  EditMoreInfoPageState({this.worker, this.notifyParent});
  final workerProvider = new WorkerProvider();
  TextEditingController _cardId = new TextEditingController();
  TextEditingController _allergie = new TextEditingController();
  String _estadoCivil;
  String _tipoSangre;
  String _ocupacion;
  String _limitacionFisica;
  TextEditingController _physicalLim = new TextEditingController();
  TextEditingController _allergiesItem =  new TextEditingController();
  bool ingles = false;
  bool frances = false;
  bool aleman = false;
  bool italiano = false;
  bool mandarin = false;
  bool japones = false;
  bool ruso = false;
  bool portugues = false;
  bool otro = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Información Adicional',
              style: TextStyle(fontFamily: 'Trebuchet', fontSize: 25, fontWeight: FontWeight.bold),

            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              _idInput(),
              SizedBox(height: 10.0),
              _civilStatus(),
              SizedBox(height: 10.0),
              _bloodType(),
              SizedBox(height: 10.0),
              _occupation(),
              SizedBox(height: 10.0),
              _physicalLimitation(),
              SizedBox(height: 10.0),
              _allergies(),
              SizedBox(height: 20.0),
            ],
          ),
          SizedBox(height: 10.0),
        ],
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

  Widget _allergies() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.local_hospital,
            color: Color.fromRGBO(0, 167, 255, 1.0),
            size: 30,
          ),
          title: TextFormField(
            decoration: InputDecoration(
              hintText: 'Alergias: ',
            ),
            validator: (value) {
              if (value == '') {
                return 'Alergia inválida';
              }
              return null;
            },
            controller: _allergiesItem,
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColors.workiColor,size:30),
            onPressed: (){
              if(_allergiesItem.text != ''){
                setState(() {
                  worker.allergies.add(_allergiesItem.text);
                  _allergiesItem.text='';
                });
              }
            },
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: worker.allergies.length == 0 ? 0 : 50,
          padding: EdgeInsets.only(left: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: worker.allergies.length,
            itemBuilder: (context, i){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Chip(
                  deleteIconColor: AppColors.workiColor,
                  label: Text(worker.allergies[i]),
                  onDeleted: (){
                    setState(() {
                      worker.allergies.remove(worker.allergies[i]);
                    });
                  },
                ),
              );
            }
          ),
        ),
      ],
    );
  }


  Widget _civilStatus() {
    return ListTile(
      leading: const Icon(
        Icons.check_circle_outline,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: DropdownButton(
        hint: Text('Estado Civil'),
        isExpanded: true,
        value: worker.maritalStatus,
        itemHeight: 50.0,
        items: <String>['Soltero(a)', 'Casado(a)', 'Separado(a)','Viudo(a)']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) {
          worker.maritalStatus = newValue;
          notifyParent();
        }
      ),
    );
  }

  Widget _bloodType() {
    return  ListTile(
      leading: const Icon(
        Icons.local_hospital,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title:  DropdownButton(
        hint: Text('Tipo de Sangre'),
        isExpanded: true,
        value: worker.rh,
        itemHeight: 50.0,
        items: <String>['A+', 'O+', 'B+','AB+','A-','O-','B-','AB-']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) {
          worker.rh = newValue;
          notifyParent();
        }
      ),
    );
  }

  Widget _occupation() {
    return new ListTile(
      leading: const Icon(
        Icons.school,
        color: Color.fromRGBO(0, 167, 255, 1.0),
        size: 30,
      ),
      title: DropdownButton(
        hint: Text('Ocupación'),
        isExpanded: true,
        value: worker.ocupation,
        itemHeight: 50.0,
        items: <String>['Estudiante', 'Trabajador(a)','Desempleado(a)','Pensionado(a)','Otra']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) {
          worker.ocupation = newValue;
          notifyParent();
        }
      ),
    );
  }

  Widget _physicalLimitation() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.accessible,
            color: Color.fromRGBO(0, 167, 255, 1.0),
            size: 30,
          ),
          title: TextFormField(
            decoration: InputDecoration(
              hintText: 'Limitaciones Físicas',
            ),
            validator: (value) {
              if (value == '') {
                return 'Número inválido';
              }
              return null;
            },
            controller: _physicalLim,
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_circle_outline, color: AppColors.workiColor, size: 30),
            onPressed: (){
              setState(() {
                if(_physicalLim.text != ''){
                  worker.physicalLimitation.add(_physicalLim.text);
                  _physicalLim.text='';
                }
              });
              //notifyParent();
            },
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: worker.physicalLimitation.length == 0 ? 0 : 50,
          padding: EdgeInsets.only(left: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: worker.physicalLimitation.length,
            itemBuilder: (context, i){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Chip(
                  deleteIconColor: AppColors.workiColor,
                  label: Text(worker.physicalLimitation[i]),
                  onDeleted: (){
                    setState(() {
                      worker.physicalLimitation.remove(worker.physicalLimitation[i]);
                    });
                  },
                ),
              );
            }
          ),
        ),
      ],
    );
  }


  
}
