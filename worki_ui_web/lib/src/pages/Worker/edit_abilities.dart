import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/workExperience_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/values/values.dart';

class EditAbilitiesPage extends StatefulWidget {
  final Worker worker;
  final Function() notifyParent;
  EditAbilitiesPage({@required this.worker, this.notifyParent});
  @override
  EditAbilitiesPageState createState() =>
      EditAbilitiesPageState(worker: this.worker, notifyParent:this.notifyParent);
}

class EditAbilitiesPageState extends State<EditAbilitiesPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  Worker worker;
  Function() notifyParent;
  EditAbilitiesPageState({this.worker, this.notifyParent});

  List<String> aptitudes = [
    'Logística',
    'Danzas',
    'Actuación',
    'Conducción',
    'Música',
    'Luces y Sonido',
    'Catering',
    'Bartender',
    'Recreación'
  ];

  List<String> languages = [
    'Inglés',
    'Alemán',
    'Francés',
    'Portugués',
    'Italiano',
    'Mandarín',
    'Japonés',
    'Ruso',
    'Otro'
  ];

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30.0),
          _aptitudes(),
          SizedBox(height: 30.0),
          _languages(),
        ],
      ),
    );
  }

  Widget _aptitudes(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Habilidades',
            style: TextStyle(
                fontFamily: 'Trebuchet',
                fontSize: 25,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Déjanos saber en que áreas te desempeñas para darte la mejor experiencia',
            style: TextStyle(fontFamily: 'Trebuchet', fontSize: 15),
            textAlign: TextAlign.justify,
          ),
        ),
        SizedBox(height: 30.0),
        Center(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceEvenly,
            children: <Widget>[
              for(int i = 0; i<aptitudes.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ChoiceChip(
                    label: Text(aptitudes[i]),
                    selected: worker.aptitudes.contains(aptitudes[i]),
                    selectedColor: Color.fromARGB(255, 178, 231, 255),
                    
                    backgroundColor: Color.fromARGB(255, 242, 242, 242),
                    elevation: 5,
                    onSelected: (value){
                      if(worker.aptitudes.contains(aptitudes[i])){
                        setState(() {
                          worker.aptitudes.remove(aptitudes[i]);
                        });
                        notifyParent();
                      }else{
                        setState(() {
                          worker.aptitudes.add(aptitudes[i]);
                        });
                        notifyParent();
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

   Widget _languages(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Idiomas',
            style: TextStyle(
                fontFamily: 'Trebuchet',
                fontSize: 25,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10.0),
        SizedBox(height: 30.0),
        Center(
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceEvenly,
            children: <Widget>[
              for(int i = 0; i<languages.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ChoiceChip(
                    label: Text(languages[i]),
                    selected: worker.languages.contains(languages[i]),
                    selectedColor: Color.fromARGB(255, 178, 231, 255),
                    
                    backgroundColor: Color.fromARGB(255, 242, 242, 242),
                    elevation: 5,
                    onSelected: (value){
                      if(worker.languages.contains(languages[i])){
                        setState(() {
                          worker.languages.remove(languages[i]);
                        });
                        notifyParent();
                      }else{
                        setState(() {
                          worker.languages.add(languages[i]);
                        });
                        notifyParent();
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
