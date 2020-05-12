import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_picker/flutter_picker.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/values.dart';

class GraphicsPage extends StatefulWidget {
  GraphicsPage({Key key}) : super(key: key);

  @override
  _GraphicsPageState createState() => _GraphicsPageState();
}

enum BarChartType { week, month, year }

class _GraphicsPageState extends State<GraphicsPage>
    with TickerProviderStateMixin {
  BarChartType _barChartType = BarChartType.year;
  CompanyProvider companyProvider = new CompanyProvider();
  Map<String, dynamic> _arguments;
  User user;
  Company company;
  AnimationController controller;
  DateTime initialDate = new DateTime.now();
  DateTime finalDate = new DateTime.now();
  List<String> months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  changeTime(value) {
    setState(() {
      _barChartType = value;
      print(initialDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    user = _arguments['user'];
    company = _arguments['company'];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Estadísticas',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.workiColor),
        ),
        body: ListView(
          children: <Widget>[
            _rating(company),
            _timeSelection(),
            _salaries(_barChartType),
            _gender(),
            _age()
          ],
        ));
  }

  Widget _timeSelection() {
    List<String> _timeSelection = ['Mensual', 'Anual'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < _timeSelection.length; i++)
          Container(
            width: 110,
            height: 40,
            margin: EdgeInsets.all(10),
            decoration: ButtonDecoration.workiButton,
            child: FlatButton(
              onPressed: () async {
                if (_timeSelection[i] == 'Mensual') {
                  changeTime(BarChartType.month);
                }
                if (_timeSelection[i] == 'Anual') {
                  changeTime(BarChartType.year);
                }
              },
              child: Text(_timeSelection[i],
                  style: TextStyle(color: Colors.white)),
            ),
          )
      ],
    );
  }

  Widget _salaries(BarChartType _barCharType) {
    var title;
    List<General> barData = [];
    Map<String, dynamic> data;
    return FutureBuilder(
      future: _barCharType == BarChartType.year
          ? companyProvider.getYearReportCompanyById(company.id)
          : companyProvider.getMonthlyReportCompanyById(company.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['ok']) {
          barData = [];
          data = snapshot.data['resp'];
          data.forEach((k, v) {
            barData.add(new General(k, v));
          });

          print(data);
          title = _barCharType == BarChartType.year
              ? title = 'Pago de salarios a lo largo de los años'
              : 'Pago de salarios a lo largo de los meses';

          var barSeries = [
            charts.Series(
                domainFn: (General salary, _) => salary.name,
                measureFn: (General salary, _) => salary.count,
                id: 'Salarios en COP',
                data: barData)
          ];

          var barChart = charts.BarChart(
            barSeries,
            behaviors: [new charts.SeriesLegend()],
            animate: true,
          );

          var barChartWidget = Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              height: 200.0,
              child: barChart,
            ),
          );

          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black38
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                barChartWidget,
              ],
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.all(10),
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }
      },
    );
  }

  Widget _rating(Company company) {
    var title;
    var barData;

    title = 'Calificación de ' + company.name;

    barData = [
      General('1', company.rating.where((i) => i.value == 1).length.toDouble()),
      General('2', company.rating.where((i) => i.value == 2).length.toDouble()),
      General('3', company.rating.where((i) => i.value == 3).length.toDouble()),
      General('4', company.rating.where((i) => i.value == 4).length.toDouble()),
      General('5', company.rating.where((i) => i.value == 5).length.toDouble())
    ];

    var barSeries = [
      charts.Series(
        domainFn: (General vote, _) => vote.name,
        measureFn: (General vote, _) => vote.count,
        id: 'Cantidad de votos',
        data: barData,
      ),
    ];

    var barChart = charts.BarChart(
      barSeries,
      animate: true,
      behaviors: [new charts.SeriesLegend()],
      defaultRenderer: new charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(30)),
    );

    var barChartWidget = Padding(
      padding: EdgeInsets.all(10.0),
      child: SizedBox(
        height: 200.0,
        child: barChart,
      ),
    );

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black38
          )
        ]
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          barChartWidget,
        ],
      ),
    );
  }

  Widget _gender() {
    List<General> barData = [];
    Map<String, dynamic> data;
    return FutureBuilder(
        future: companyProvider.getGenderReportCompanyById(company.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data['ok']) {
            barData = [];
            data = snapshot.data['resp'];
            data.forEach((k, v) {
              barData.add(new General(k, v.toDouble()));
            });
            var pieSeries = [
              charts.Series(
                id: 'División de trabajadores por género',
                domainFn: (General gender, _) => gender.name,
                measureFn: (General gender, _) => gender.count,
                data: barData,
                labelAccessorFn: (General row, _) =>
                    '${row.name}: ${row.count}',
              )
            ];
            var pieChart = charts.PieChart(pieSeries,
                animate: true,
                defaultRenderer: new charts.ArcRendererConfig(
                    arcWidth: 60,
                    arcRendererDecorators: [new charts.ArcLabelDecorator()]));

            var pieChartWidget = Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                height: 200.0,
                child: pieChart,
              ),
            );

            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black38
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'División de trabajadores por género',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  pieChartWidget
                ],
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(10),
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }
        });
  }

  Widget _age() {
    List<General> barData = [];
    Map<String, dynamic> data;
    return FutureBuilder(
        future: companyProvider.getAgeReportCompanyById(company.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data['ok']) {
            barData = [];
            data = snapshot.data['resp'];
            data.forEach((k, v) {
              barData.add(new General(k, v.toDouble()));
            });
            var pieSeries = [
              charts.Series(
                id: 'División de trabajadores por edad',
                domainFn: (General gender, _) => gender.name,
                measureFn: (General gender, _) => gender.count,
                data: barData,
                labelAccessorFn: (General row, _) =>
                    '${row.name} años: ${row.count}',
              )
            ];
            var pieChart = charts.PieChart(pieSeries,
                animate: true,
                defaultRenderer: new charts.ArcRendererConfig(
                    arcWidth: 60,
                    arcRendererDecorators: [new charts.ArcLabelDecorator()]));

            var pieChartWidget = Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                height: 200.0,
                child: pieChart,
              ),
            );

            return Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black38
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'División de trabajadores por edad',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  pieChartWidget
                ],
              ),
            );
          } else {
            return Container(
                margin: EdgeInsets.all(10),
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }
        });
  }
}

class General {
  final String name;
  final double count;
  General(this.name, this.count);
}
