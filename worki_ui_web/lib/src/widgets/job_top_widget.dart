import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:barcode_scan/barcode_scan.dart';

class JobTopWidget extends StatefulWidget {
  Job job;
  JobTopWidget({this.job});

  @override
  _JobTopWidgetState createState() => _JobTopWidgetState(job: this.job);
}

class _JobTopWidgetState extends State<JobTopWidget> {
  Job job;
  WorkerProvider _workerProvider = new WorkerProvider();
  _JobTopWidgetState({this.job});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
              gradient: Gradients.workiGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2.0),
                  blurRadius: 5.0,
                  color: Color.fromARGB(100, 0, 0, 0),
                ),
              ]),
          //padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.message,
                          size: 25,
                          color: Colors.white,
                        ),
                        onPressed: () {}),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.directions,
                          size: 25,
                          color: Colors.white,
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),
              Container(
                height: 70,
                width: 70,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  //color:Colors.black,
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              job.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(job.getInitialDate(),
                                  style: TextStyle(color: Colors.white)))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.circular(50)),
        child: Material(
          borderRadius: BorderRadius.circular(50),
          elevation: 0.0,
          borderOnForeground: true,
          color: AppColors.workiColor,
          child: FloatingActionButton(
            child:
                Icon(Icons.center_focus_strong, size: 40, color: Colors.white),
            onPressed: _scanQR,
          ),
        ),
      ),
    ]);
  }

  _scanQR() async {
    String idWorker = '';
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Buscando Trabajador',
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
    
    try {
      idWorker = await BarcodeScanner.scan();
    } catch (e) {
      idWorker = e.toString();
    }

    if (idWorker != null) {
      pr.show();
      Map<String, dynamic> res = await _workerProvider.getWorker(idWorker);
      pr.hide();
      if (res['ok']) {
        Worker worker = Worker.fromJson(res['worker']);
        print(worker.toJson().toString());
        Navigator.of(context)
            .pushNamed('worker_qr', arguments: {'worker': worker, 'job': job});
      }else{
        showAlert(context, 'No se encontró el trabajador');
      }
    }
  }
}
