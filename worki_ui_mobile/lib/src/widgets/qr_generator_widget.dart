import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:worki_ui/src/values/values.dart';

class QrGeneratorWidget extends StatelessWidget {
  final PanelController panelController;
  final ScrollController sc;
  final user;
  final Job job;
  bool push;
  QrGeneratorWidget(
      {this.panelController, this.sc, this.user, this.job, @required this.push});

  @override
  Widget build(BuildContext context) {
    print(user.id + '\\'+job.id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        controller: sc,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Código QR',
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
          Text(
              'Muestra este codigo al coordinador del trabajo para que pueda registrarte',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato')),
          SizedBox(
            height: 30.0,
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: QrImage(
                data: user.id ,//+ '\\'+job.id,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: job.jobPic != '' ? 
                          Image.network(job.jobPic, fit: BoxFit.cover) :
                          Image.asset('assets/no-image.png',fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(width:10),
                    Text(
                      job.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(FontAwesome5.calendar_check, color: AppColors.workiColor),
                    SizedBox(width: 10,),
                    Text(
                      job.getInitialDate(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Descripción: '+job.description,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 200,)
        ],
      ),
    );
  }
}
