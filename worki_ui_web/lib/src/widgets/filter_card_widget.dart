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

class FilterCardWidget extends StatefulWidget {
  final PanelController panelController;
  final ScrollController sc;
  final user;
  bool push;
  FilterCardWidget({this.panelController, this.sc, this.user, @required this.push});

  @override
  _FilterCardWidgetState createState() => _FilterCardWidgetState(panelController: this.panelController, sc: this.sc, user: this.user, push: this.push);
}

class _FilterCardWidgetState extends State<FilterCardWidget> {
  PanelController panelController;
  ScrollController sc;
  var user;
  bool push;
  _FilterCardWidgetState({this.panelController, this.sc, this.user, this.push});
  DateTime initialDate;
  DateTime finalDate;
  int durationFil;
  final nameController =  TextEditingController();
  final durationController =  TextEditingController();
  final cityController =  TextEditingController();
  final companyController =  TextEditingController();
  final functionsController =  TextEditingController();
  double _lowerValue = 20000.0;
  double _upperValue = 99999.0;
  bool button = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical:10),
      child: ListView(
        controller: sc,
        children:<Widget>[ 
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
                  fontFamily: 'Lato'
                )
              ),
              GestureDetector(
                onTap: (){
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
          Text(
            'Puedes filtrar por uno o varios de los siguientes campos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Lato'
            )
          ),
          SizedBox(
            height: 40.0,
          ),
          Text('Nombre: ',
            style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato')
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppColors.workiColor,
                width: 1
              ),
            ),
            child: TextField(
              controller: nameController,
              decoration: new InputDecoration(
                hintText: "Nombre del trabajo",
                suffixIcon: Icon(Icons.search, size: 25, color: AppColors.workiColor),
                border: InputBorder.none
              ),
            ),
          ),   
          SizedBox(
            height: 30.0,
          ),
          Text(
            'Salario: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato'
            )
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(_lowerValue.toInt().toString()),
              Expanded(
                flex: 5,
                child: frs.RangeSlider(
                  min: 20000.0,
                  max: 100000.0,
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
                    print(
                        'Ended with values: $newLowerValue and $newUpperValue');
                  },
                ),
              ),
              Text(_upperValue.toInt().toString()),
            ],
          ),
              
        SizedBox(
          height: 20.0,
        ),
        Text('Fechas: ',
          style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lato')
        ),
        SizedBox(height: 10,),
        Container(
          height: 50,
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
                firstDate: currentValue ?? DateTime.now(),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2021)
              );
            },
          ),
        ),
        
        SizedBox(
          height: 20.0,
        ),
        Container(
          height: 50,
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
                firstDate: currentValue ?? DateTime.now(),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2021)
              );
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('Duración: ',
              style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato')
            ),
        TextField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          controller: durationController,
          decoration: new InputDecoration(
            hintText: "Duración del trabajo",
            icon: Icon(
              Icons.timer,
              color: Color.fromRGBO(0, 167, 255, 1.0),
              size: 25,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('Ciudad: ',
              style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato')
            ),
        TextField(
          controller: cityController,
          decoration: new InputDecoration(
            hintText: "Ciudad ",
            icon: Icon(
              Icons.location_on,
              color: Color.fromRGBO(0, 167, 255, 1.0),
              size: 25,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text('Empresa: ',
          style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lato')
        ),
        TextField(
          controller: companyController,
          decoration: new InputDecoration(
            hintText: "Nombre de la empresa ",
            icon: Icon(
              Icons.business,
              color: Color.fromRGBO(0, 167, 255, 1.0),
              size: 25,
            ),
          ),
        ),    
        
        SizedBox(
          height: 20.0,
        ),
        Text('Funciones: ',
          style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lato')
        ),
        TextField(
          controller: functionsController,
          decoration: new InputDecoration(
            hintText: "Ej: Cantar: Bailar (Separadas por : )",
            icon: Icon(
              Icons.format_list_numbered,
              color: Color.fromRGBO(0, 167, 255, 1.0),
              size: 25,
            ),
          ),
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
              var initialDateAux = initialDate != null ? DateFormat('yyyy/MM/dd').format(initialDate).toString() : '';
              var finalDateAux = finalDate != null ? DateFormat('yyyy/MM/dd').format(finalDate).toString() : '';

              Map<String,dynamic> arguments = {
                'name' : nameController.text,
                'startSalary' : _lowerValue.toInt().toString(),
                'endSalary' : _upperValue.toInt().toString(),
                'initialDate' : initialDateAux,
                'finalDate' : finalDateAux,
                'duration' : durationController.text,
                'city' : cityController.text,
                'company' : companyController.text,
                'functions' : functionsController.text
              };
              await Future.delayed(Duration(milliseconds: 1500));
              if(push){
                panelController.close();
                Navigator.of(context).pushNamed('filter_job_page', arguments: {'arguments':arguments,'user':user});
              }else{
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('filter_job_page', arguments: {'arguments':arguments,'user':user});
              }
              await Future.delayed(Duration(milliseconds: 100));
              setState(() {
                button = !button;
              });
             
            },
            child: AnimatedContainer(
              duration:Duration(milliseconds: 500),
              width: button == false ? 500 : 50,
              height: 50,
              margin: EdgeInsets.all(10.0),
              decoration: ButtonDecoration.workiButton,
              child: Center(
                child: button == false ? Text(
                  'Filtrar',
                  style: TextStyle(color: Colors.white),
                ) : AwesomeLoader(
                  loaderType: AwesomeLoader.AwesomeLoader3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 150.0
        ),
        ]
      ),
    );

  }
}