import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/report_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/providers/excel_provider.dart';


class ConsolidatedPage extends StatefulWidget {
  ConsolidatedPage({Key key}) : super(key: key);

  @override
  _ConsolidatedPageState createState() => _ConsolidatedPageState();
}

class _ConsolidatedPageState extends State<ConsolidatedPage> {
  Event event;
  Job job;
  Company company;
  DateTime initialDate;
  DateTime finalDate;
  List<Worker> workers; // = new List<Worker>();
  Map<String, dynamic> _arguments;
  ReportProvider reportProvider = new ReportProvider();
  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;
  double screenWidth;
  double totalPay;
  String queryBy = '';
  ExcelProvider excelProvider = new ExcelProvider();


  NumberFormat money = new NumberFormat.currency( symbol: '\$ ', decimalDigits: 0);


  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    if(_arguments['event'] != null) {
      event = _arguments['event'];
      queryBy = 'event';
    }
    if(_arguments['job'] != null) {
      job = _arguments['job'];
      queryBy = 'job';
    }
    if(_arguments['company'] != null) {
      print('COMPANIA');
      company = _arguments['company'];
      queryBy = 'company';
      if(_arguments['initialDate'] != null){
        initialDate =_arguments['initialDate'];
        queryBy = 'companyDate';
      }
      if(_arguments['finalDate'] != null){
        finalDate =_arguments['finalDate'];
      }

    }
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Reporte',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Container(
            height: 70,
            width: 70,
            child: FlatButton(
                onPressed: () async{
                  var result = await excelProvider.generateExcel(workers);
                  
                  if(result.type == ResultType.noAppToOpen){
                    showAlert(context, 'No se encontró ninguna aplicación para abrir este archivo');
                  }
                },
                child: Image.asset('assets/ms-excel.png', fit: BoxFit.contain)),
          )
        ],
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.workiColor),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height:30),
          _header(queryBy),
          SizedBox(height:30),
          Expanded(child: _workersBuilder()),
        ],
      ),
    );
  }

  Widget _header(String queryBy) {
    String topText;
    String dateRange = '';
    if(queryBy == 'event'){
      topText = 'Evento '+event.name;
    }
    if(queryBy == 'job'){
      topText = 'Trabajo '+job.name;
    }
    if(queryBy == 'company'){
      topText = 'Compañía '+company.name;
    }
    if(queryBy == 'companyDate'){
      String auxInitialDate = DateFormat('dd/MM/yyyy').format(initialDate).toString();
      String auxFinalDate = DateFormat('dd/MM/yyyy').format(finalDate).toString();
      
      topText = _arguments['timeType'];
      dateRange = auxInitialDate+' - '+auxFinalDate;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              topText,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'Lato'),
            ),
            dateRange != '' ? Text(
              dateRange,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Lato'),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _workersBuilder() {
    Future<List<Worker>> query;
    if(queryBy == 'event'){
      query = reportProvider.getReportByEventId(event.id);
    }
    if(queryBy == 'job'){
      query = reportProvider.getReportByJobId(job.id);
    }
    if(queryBy == 'company'){
      query = reportProvider.getReportByCompanyId(company.id);
    }
    if(queryBy == 'companyDate'){
      query = reportProvider.getReportByCompanyAndTimeId(company.id, initialDate, finalDate);
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: query,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            workers = snapshot.data;
            double total = 0;
            workers.forEach((w){
              total = total + w.reportSalary;
            });
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Valor Total: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                      Text(
                        money.format(total.toInt()),
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Total Personas a Pagar:  ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                      Text(
                        workers.length.toString(),
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:20),
                Expanded(child: _table()),
              ],
            );
          } else {
            return Center(
              child: AwesomeLoader(
                  loaderType: AwesomeLoader.AwesomeLoader3,
                  color: AppColors.workiColor),
            );
          }
        },
      ),
    );
  }

  Widget _table() {
    return Container(
      //margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black38
          )
        ]
      ),
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 600,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: workers.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFF2A2A2A),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(3, 0)
            )
          ]
        ),
        
        child: FlatButton(
          padding: EdgeInsets.all(0),
          child: _getTitleItemWidget(
              'Nombre' + (sortType == sortName ? (isAscending ? '↓' : '↑') : ''),
              screenWidth*0.4),
          onPressed: () {
            sortType = sortName;
            isAscending = !isAscending;
            //user.sortName(isAscending);
            setState(() {});
          },
        ),
      ),
      _getTitleItemWidget('Documento', 150),
      _getTitleItemWidget('Telefono', 150),
      _getTitleItemWidget('Trabajo', 150),
      _getTitleItemWidget('Pago', 150),
      //_getTitleItemWidget('Firma', 200),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      width: width,
      height: 56,
      decoration: BoxDecoration(
        //gradient: Gradients.workiGradient,
        color: Color.fromRGBO(128, 207, 255, 1.0),
      ),
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(
        (index+1).toString() + '. '+workers[index].name,
      ),
      width: screenWidth*0.4,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Colors.black12,
            offset: Offset(3, 0)
          )
        ]

      ),
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child:
              Text(workers[index].cardId != null ? workers[index].cardId : ''),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(workers[index].phone != null
              ? workers[index].phone.toString()
              : ''),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: ListView.builder(
            itemCount: workers[index].reportJobs.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context,i){
              return Text('- '+workers[index].reportJobs[i]);
            }
          ),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(money.format(workers[index].reportSalary.toInt())),
          width: 150,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
