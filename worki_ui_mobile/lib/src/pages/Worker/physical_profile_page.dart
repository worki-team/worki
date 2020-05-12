import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/physicalProfile_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/contextureType_enum.dart';
import 'package:worki_ui/src/utils/eyeType_enum.dart';
import 'package:worki_ui/src/utils/hairColor_enum.dart';
import 'package:worki_ui/src/utils/hairType_enum.dart';
import 'package:worki_ui/src/utils/skinType_enum.dart';

class PhysicalProfilePage extends StatefulWidget {
  final Worker worker;
  final Function notifyParent;
  PhysicalProfilePage({@required this.worker, this.notifyParent});
  @override
  _PhysicalProfilePageState createState() =>
      _PhysicalProfilePageState(worker: this.worker, notifyParent: this.notifyParent);
}

class _PhysicalProfilePageState extends State<PhysicalProfilePage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();
  final Worker worker;
  Function() notifyParent;
  _PhysicalProfilePageState({this.worker, this.notifyParent});
  final workerProvider = new WorkerProvider();


  @override

  build(BuildContext context) {
    var subTitles = TextStyle(fontWeight: FontWeight.bold);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Perfil Físico',
                style: TextStyle(fontFamily: 'Trebuchet', fontSize: 25, fontWeight: FontWeight.bold),

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text('Contextura:', style: subTitles,),
                      SizedBox(width: 20),
                      Expanded(
                        child:_contextura()
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text('Color de Ojos', style: subTitles),
                      SizedBox(width: 20),
                      Expanded(
                        child:_colorOjos()
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text('Tipo de Pelo', style: subTitles),
                      SizedBox(width: 20),
                      Expanded(
                        child:_tipoPelo(),
                      ),
                    ],
                  ),
                  
                  
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text('Color de Pelo', style: subTitles),
                      SizedBox(width: 20),
                      Expanded(
                        child:_colorPelo(),
                      ),
                    ],
                  ),
                  
                  
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text('Color de Piel', style: subTitles),
                      SizedBox(width: 20),
                      Expanded(
                        child:_colorPiel(),
                      ),
                    ],
                  ),
                  
                  
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text('Talla Camiseta', style: subTitles),
                      SizedBox(width: 20),
                      Expanded(
                        child:_tallaCamiseta(),
                      ),
                    ],
                  ),
                  
                  
                  SizedBox(height: 20.0),
                  Text('Estatura en centímetros', style: subTitles),
                  _estatura(),
                  SizedBox(height: 10.0),
                  Text('Talla Pantalon', style: subTitles),
                  _tallaPantalon(),
                  SizedBox(height: 10.0),
                  Text('Talla Zapatos', style: subTitles),
                  _tallaZapatos(),
                  SizedBox(height: 10.0),
                  Text('Peso en kg', style: subTitles),
                  _peso(),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }



  Widget _contextura() {
    Map<String, String> contextura = {
      'Delgada' : 'THIN',
      'Musculosa' : 'MUSCLE',
      'Gruesa' : 'THICK',
      '' : null
    };
    return DropdownButton(
        hint: Text('Contextura'),
        isExpanded: true,
        value: contextura.keys.firstWhere((k) => contextura[k] == EnumToString.parse(worker.physicalProfile.contexture)),
        itemHeight: 50.0,
        items: <String>['Delgada','Musculosa','Gruesa','']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) {
          worker.physicalProfile.contexture = EnumToString.fromString(ContextureType.values, contextura[newValue]);
          notifyParent();
        }
    );
  }

  Widget _colorOjos() {
    Map<String, String> eyeColor = {
      'Negros' : 'BLACK',
      'Cafes' : 'BROWN', 
      'Azules' : 'BLUE',
      'Verdes' : 'GREEN',
      'Grises' : 'GRAY',
      '' : null
    };
    return DropdownButton(
      hint: Text('Color de Ojos'),
      isExpanded: true,
      value: eyeColor.keys.firstWhere((k) => eyeColor[k] == EnumToString.parse(worker.physicalProfile.eyeColor)),
      itemHeight: 50.0,
      items: <String>['Negros','Cafes','Azules','Verdes','Grises','']
        .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (newValue) {
        worker.physicalProfile.eyeColor = EnumToString.fromString(EyeType.values, eyeColor[newValue]);
        notifyParent();
      }
    );
  }

  Widget _tipoPelo() {

    Map<String, String> hairType = {
      'Lacio' : 'STRAIGHT',
      'Crespo' : 'CURLY',
      'Ondulado' : 'WAVY',
      '' : null
    };
    return DropdownButton(
      hint: Text('Color de Ojos'),
      isExpanded: true,
      value: hairType.keys.firstWhere((k) => hairType[k] == EnumToString.parse(worker.physicalProfile.hairType)),
      itemHeight: 50.0,
      items: <String>['Lacio','Crespo','Ondulado','']
        .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (newValue) {
        worker.physicalProfile.hairType = EnumToString.fromString(HairType.values, hairType[newValue]);
        notifyParent();
      },
    );
  }


  Widget _colorPelo() {
    Map<String, String> hairColor = {
      'Negro' : 'BLACK',
      'Cafe' : 'BROWN',
      'Rojo' : 'RED',
      'Verde' : 'GREEN',
      'Gris' : 'GRAY',
      'Rubio' : 'BLONDE',
      'Otro' : 'OTHER',
      '' : null
    };
    return DropdownButton(
      hint: Text('Color de Ojos'),
      isExpanded: true,
      value: hairColor.keys.firstWhere((k) => hairColor[k] == EnumToString.parse(worker.physicalProfile.hairColor)),
      itemHeight: 50.0,
      items: <String>['Negro','Cafe','Rojo','Verde','Gris','Rubio','Otro','']
        .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (newValue) {
        worker.physicalProfile.hairColor = EnumToString.fromString(HairColorType.values, hairColor[newValue]);
        notifyParent();
      },
    );
  }

  Widget _colorPiel() {
    Map<String, String> skillColor = {
      'Clara' : 'WHITE',
      'Oscura' : 'BLACK',
      'Morena' : 'BROWN',
      'Amarilla' : 'YELLOW', 
      '' : null
    };
    return DropdownButton(
      hint: Text('Color de Ojos'),
      isExpanded: true,
      value: skillColor.keys.firstWhere((k) => skillColor[k] == EnumToString.parse(worker.physicalProfile.skinColor)),
      itemHeight: 50.0,
      items: <String>['Clara','Morena','Oscura','']
        .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (newValue) {
        worker.physicalProfile.skinColor = EnumToString.fromString(SkinType.values, skillColor[newValue]);
        notifyParent();
      },
    );
  }

  Widget _tallaCamiseta() {
    return DropdownButton(
      hint: Text('Talla Camiseta'),
      isExpanded: true,
      value: worker.physicalProfile.shirtSize,
      itemHeight: 50.0,
      items: <String>['XS','S','M','L','XL','Otro','']
        .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (newValue) {
        worker.physicalProfile.shirtSize = newValue;
        notifyParent();
      },
    );
  }

  Widget _tallaPantalon() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      initialValue: worker.physicalProfile.pantsSize.toString(),
      decoration: new InputDecoration(
        hintText: 'Talla Pantalón: ',
      ),
      validator: (value) {
        if (value == '') {
          return 'Talla de pantalón inválido';
        }
        return null;
      },
      onChanged: (value){
        worker.physicalProfile.pantsSize = int.parse(value);
        notifyParent();
      },
    );
  }

  Widget _tallaZapatos() {
     return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      initialValue: worker.physicalProfile.shoesSize.toString(),
      decoration: new InputDecoration(
        hintText: 'Talla Zapatos: ',
      ),
      validator: (value) {
        if (value == '') {
          return 'Talla de zapatos inválido';
        }
        return null;
      },
      onChanged: (value){
        worker.physicalProfile.shoesSize = int.parse(value);
        notifyParent();
      },
    );
  }
  
  Widget _peso() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      initialValue: worker.physicalProfile.weight.toString(),
      decoration: new InputDecoration(
        hintText: 'Peso (kg)',
      ),
      validator: (value) {
        if (value == '') {
          return 'Peso inválido';
        }
        return null;
      },
      onChanged: (value){
        worker.physicalProfile.weight= double.parse(value);
        notifyParent();
      },
    );
  }
  Widget _estatura() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      initialValue: worker.physicalProfile.height.toString(),
      decoration: new InputDecoration(
        hintText: 'Estatura (cms)',
      ),
      validator: (value) {
        if (value == '') {
          return 'Estatura inválido';
        }
        return null;
      },
      onChanged: (value){
        worker.physicalProfile.height = double.parse(value);
        notifyParent();
      },
    );
  }
  

}
