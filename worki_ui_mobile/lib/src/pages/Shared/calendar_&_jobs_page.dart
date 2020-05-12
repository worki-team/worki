import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Worker/calendar_page.dart';
import 'package:worki_ui/src/providers/applicant_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/utils/shimmers/job_shimmer_widget.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/widgets/job_card_widget.dart';
import 'package:worki_ui/src/widgets/job_preview_widget.dart';

class CalendarJobsPage extends StatefulWidget {
  CalendarJobsPage({Key key}) : super(key: key);

  @override
  _CalendarJobsPageState createState() => _CalendarJobsPageState();
}

class _CalendarJobsPageState extends State<CalendarJobsPage> {
  var user;
  JobsProvider jobsProvider = new JobsProvider();
  ApplicantsProvider applicantsProvider = new ApplicantsProvider();
  Map<String, dynamic> _arguments;
  List<Job> jobs;

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    user = _arguments['user'];
    jobs = _arguments['jobs'];
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Tus Trabajos', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: AppColors.workiColor),
      ),
      body: ListView(
        shrinkWrap: true,

        physics: ScrollPhysics(),
        children: <Widget>[
           AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              /*boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black38
                )
              ]*/
            ),
            child: CalendarPage(jobs: jobs, isExpanded: true, user: user),
          ),
          SizedBox(height: 20),
          user.roles[0] == 'WORKER' ? _yourApplicantJobs() : Container(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Trabajos',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato')),
          ),
          SizedBox(height: 20,),
          _jobs(),
        ],
      ),
      
    );
  }

  Widget _yourApplicantJobs() {
    return FutureBuilder(
        future: applicantsProvider.getWorkerApplicantJobs(user.id),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          print(snapshot.error);
          if (snapshot.hasData) {
            List<Job> jobs = snapshot.data;
            if (jobs.length == 0) {
              return Container();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Trabajos por confirmar',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato')),
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: jobs.length,
                      scrollDirection: Axis.horizontal,
                      //PageController(viewportFraction: 0.3, initialPage: 0),
                      itemBuilder: (context, i) =>
                          _applicantJobCard(jobs[i], i),
                    ),
                  ),
                ],
              );
            }
          } else {
          
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Trabajos por confirmar',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato')),
                ),
                Container(
                  height: 200.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(width: 15),
                      for (int i = 0; i < 4; i++) JobShimmerWidget(),
                    ],
                  ),
                ),
              ],
            );
          }
          
        });
  }

  Widget _applicantJobCard(Job job, int i) {
    return Row(
      children: <Widget>[
        i == 0 ? SizedBox(width: 15) : Container(),
        JobPreviewWidget(job: job, user: user),
      ],
    );
  }

  Widget _jobs(){
    return ListView.builder(
      itemCount: jobs.length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, i){
        
        if (i == (jobs.length - 1)) {
          return Column(
            children: <Widget>[
              JobCardWidget(
                job: jobs[i],user:user
              ),
              SizedBox(
                height: 100,
              )
            ],
          );
        }
        return JobCardWidget(job: jobs[i],user:user); 
      },
    );
  }

}