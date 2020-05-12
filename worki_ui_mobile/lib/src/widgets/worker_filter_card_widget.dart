import 'package:awesome_loader/awesome_loader.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:flutter_picker/flutter_picker.dart';

class FilterWorkerCardWidget extends StatefulWidget {
  final PanelController panelController;
  final ScrollController sc;
  final user;
  bool push;
  FilterWorkerCardWidget(
      {this.panelController, this.sc, this.user, @required this.push});

  @override
  _FilterWorkerCardWidgetState createState() => _FilterWorkerCardWidgetState(
      panelController: this.panelController,
      sc: this.sc,
      user: this.user,
      push: this.push);
}

class _FilterWorkerCardWidgetState extends State<FilterWorkerCardWidget> {
  PanelController panelController;
  ScrollController sc;
  var user;
  bool push;
  String _selectedCity = '';
  String _selectedLanguage = '';
  String _selectedAptitude = '';
  String _selectedContexture = '';
  String _selectedEyeColor = '';
  String _selectedHairColor = '';
  String _selectedHairType = '';
  String _selectedSkinColor = '';
  TextEditingController _selectedHeight = new TextEditingController();
  TextEditingController _selectedWeight = new TextEditingController();
  TextEditingController _selectedPantSize = new TextEditingController();
  String _selectedShirtSize = '';
  TextEditingController _selectedShoeSize = new TextEditingController();

  List<String> _genderList = ['Femenino', 'Masculino', 'Otro', 'Todos'];
  String _selectedGender = 'Todos';
  _FilterWorkerCardWidgetState(
      {this.panelController, this.sc, this.user, this.push});
  DateTime initialDate;
  DateTime finalDate;
  int durationFil;
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  final cityController = TextEditingController();
  final companyController = TextEditingController();
  final functionsController = TextEditingController();
  double _lowerValue = 18;
  double _upperValue = 70;
  bool button = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(controller: sc, children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Filtros',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato')),
            GestureDetector(
              onTap: () {
                panelController.close();
              },
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 20,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('Puedes filtrar por uno o varios de los siguientes campos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontFamily: 'Lato')),
        SizedBox(
          height: 40.0,
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 2, color: Colors.black26, offset: Offset(0, 3.0))
            ],
            border: Border.all(color: AppColors.workiColor, width: 1),
          ),
          child: TextField(
            controller: nameController,
            autofocus: false,
            decoration: new InputDecoration(
                hintText: "Nombre de la persona",
                suffixIcon:
                    Icon(Icons.search, size: 25, color: AppColors.workiColor),
                border: InputBorder.none),
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
        Text('Edad: ',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Lato')),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_lowerValue.toInt().toString()),
            Expanded(
              flex: 5,
              child: frs.RangeSlider(
                min: 18,
                max: 70,
                lowerValue: _lowerValue,
                upperValue: _upperValue,
                divisions: 100,
                showValueIndicator: true,
                valueIndicatorMaxDecimals: 0,
                onChanged: (double newLowerValue, double newUpperValue) {
                  setState(() {
                    _lowerValue = newLowerValue.truncateToDouble();
                    _upperValue = newUpperValue.truncateToDouble();
                  });
                },
                onChangeStart:
                    (double startLowerValue, double startUpperValue) {
                  print(
                      'Started with values: $startLowerValue and $startUpperValue');
                },
                onChangeEnd: (double newLowerValue, double newUpperValue) {
                  print('Ended with values: $newLowerValue and $newUpperValue');
                },
              ),
            ),
            Text(_upperValue.toInt().toString()),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('Ciudad: ',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Lato')),
        DropdownButton(
            hint: Text('Ciudad'),
            isExpanded: true,
            value: _selectedCity,
            itemHeight: 50.0,
            items: <String>[
              'Bogotá',
              'Medellin',
              'Cali',
              'Bucaramanga',
              'Barranquilla',
              'Pereira',
              'Manizales',
              'Armenia',
              'Cartagena',
              'Santa Marta',
              'Otra',
              ''
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedCity = newValue;
              });
            }),
        SizedBox(
          height: 10.0,
        ),
        Text('Género: ',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Lato')),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (int i = 0; i < _genderList.length; i++)
              ChoiceChip(
                label: Text(_genderList[i]),
                elevation: 3,
                selected: _selectedGender == _genderList[i] ? true : false,
                onSelected: (value) {
                  setState(() {
                    _selectedGender = _genderList[i];
                  });
                },
              )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Text('Idiomas: ',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Lato')),
        DropdownButton(
            hint: Text('Idioma'),
            isExpanded: true,
            value: _selectedLanguage,
            itemHeight: 50.0,
            items: <String>[
              'Inglés',
              'Alemán',
              'Francés',
              'Portugués',
              'Italiano',
              'Mandarín',
              'Japonés',
              'Ruso',
              'Otro',
              ''
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedLanguage = newValue;
              });
            }),
        SizedBox(
          height: 10,
        ),
        Text('Habilidades: ',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Lato')),
        DropdownButton(
            hint: Text('Habilidades'),
            isExpanded: true,
            value: _selectedAptitude,
            itemHeight: 50.0,
            items: <String>[
              'Logística',
              'Danzas',
              'Actuación',
              'Conducción',
              'Música',
              'Luces y Sonido',
              'Catering',
              'Bartender',
              'Recreación',
              'Otro',
              ''
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedAptitude = newValue;
              });
            }),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Características Físicas',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lato'),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: <Widget>[
            Text('Contextura: ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato')),
            Expanded(
              child: DropdownButton(
                  hint: Text('Contextura'),
                  isExpanded: true,
                  value: _selectedContexture,
                  itemHeight: 50.0,
                  items: <String>['Delgada', 'Musculosa', 'Gruesa', '']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedContexture = newValue;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: <Widget>[
            Text('Color de Ojos: ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato')),
            Expanded(
              child: DropdownButton(
                  hint: Text('Color de Ojos'),
                  isExpanded: true,
                  value: _selectedEyeColor,
                  itemHeight: 50.0,
                  items: <String>[
                    'Negros',
                    'Cafes',
                    'Azules',
                    'Verdes',
                    'Grises',
                    ''
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedEyeColor = newValue;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text('Color de Pelo: ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato')),
            Expanded(
              child: DropdownButton(
                  hint: Text('Color de Pelo'),
                  isExpanded: true,
                  value: _selectedHairColor,
                  itemHeight: 50.0,
                  items: <String>[
                    'Negro',
                    'Cafe',
                    'Rojo',
                    'Verde',
                    'Gris',
                    'Rubio',
                    'Otro',
                    ''
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedHairColor = newValue;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text('Tipo de Pelo: ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato')),
            Expanded(
              child: DropdownButton(
                  hint: Text('Tipo de Pelo'),
                  isExpanded: true,
                  value: _selectedHairType,
                  itemHeight: 50.0,
                  items: <String>['Lacio', 'Crespo', 'Ondulado', '']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedHairType = newValue;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text('Color de Piel: ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato')),
            Expanded(
              child: DropdownButton(
                  hint: Text('Color de Piel'),
                  isExpanded: true,
                  value: _selectedSkinColor,
                  itemHeight: 50.0,
                  items: <String>['Clara', 'Morena', 'Oscura', '']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSkinColor = newValue;
                    });
                  }),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Estatura: ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato')),
            GestureDetector(
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.workiColor, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        _selectedHeight.text,
                       textAlign: TextAlign.center,
                      )
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _selectedHeight.text != '' ? 1 : 0,
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Icon(Icons.cancel, color: Colors.red),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedHeight.text = '';
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showPickerHeight(context);
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Peso: ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato')),
            GestureDetector(
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.workiColor, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        _selectedWeight.text,
                       textAlign: TextAlign.center,
                      )
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _selectedWeight.text != '' ? 1 : 0,
                        child: GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Icon(Icons.cancel, color: Colors.red),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedWeight.text = '';
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showPickerWeight(context);
              },
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              setState(() {
                button = !button;
              });

              Map<String, dynamic> arguments = {
                'name': nameController.text,
                'startAge': _lowerValue.toInt().toString(),
                'endAge': _upperValue.toInt().toString(),
                'city': _selectedCity,
                'gender': _selectedGender,
                'language': _selectedLanguage,
                'aptitude': _selectedAptitude,
                'contexture': _selectedContexture,
                'eyeColor': _selectedEyeColor,
                'hairColor': _selectedHairColor,
                'hairType': _selectedHairType,
                'skinColor': _selectedSkinColor,
                'height': _selectedHeight.text,
                'weight': _selectedWeight.text
              };

              await Future.delayed(Duration(milliseconds: 1500));
              if (push) {
                panelController.close();
                Navigator.of(context).pushNamed('workers_page',
                    arguments: {'arguments': arguments, 'user': user});
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('workers_page',
                    arguments: {'arguments': arguments, 'user': user});
              }
              await Future.delayed(Duration(milliseconds: 100));
              setState(() {
                button = !button;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: button == false ? 500 : 50,
              height: 50,
              margin: EdgeInsets.all(10.0),
              decoration: ButtonDecoration.workiButton,
              child: Center(
                child: button == false
                    ? Text(
                        'Filtrar',
                        style: TextStyle(color: Colors.white),
                      )
                    : AwesomeLoader(
                        loaderType: AwesomeLoader.AwesomeLoader3,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ),
        SizedBox(height: 150.0),
      ]),
    );
  }

  showPickerHeight(BuildContext context) {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 80, end: 230, initValue: 170),
        ]),
        hideHeader: false,
        title: new Text('Estatura'),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            _selectedHeight.text = picker.getSelectedValues()[0].toString();
          });
        }).showModal(context);
  }

  showPickerWeight(BuildContext context) {
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 40, end: 300, initValue: 60),
        ]),
        hideHeader: false,
        title: new Text('Peso'),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            _selectedWeight.text = picker.getSelectedValues()[0].toString();
          });
        }).showModal(context);
  }
}
