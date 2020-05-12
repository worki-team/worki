import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/applicant_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/pages/Worker/worker_profile_page.dart';
import 'package:worki_ui/src/providers/applicant_provider.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/firestore_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/providers/user_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/shimmers/company_shimmer_widget.dart';
import 'package:worki_ui/src/utils/shimmers/job_shimmer_widget.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/values/gradients.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:worki_ui/src/widgets/job_preview_widget.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:worki_ui/src/widgets/job_top_widget.dart';
import 'package:worki_ui/src/widgets/user_small_card_widget.dart';

class JobDetails extends StatefulWidget {
  JobDetails({Key key}) : super(key: key);

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  FirebaseProvider firebaseProvider = new FirebaseProvider();
  UserProvider userProvider = new UserProvider();
  WorkerProvider workerProvider = new WorkerProvider();
  JobsProvider jobProvider = new JobsProvider();
  CompanyProvider companyProvider = new CompanyProvider();
  ApplicantsProvider applicantProvider = new ApplicantsProvider();
  FirestoreProvider firestoreProvider = new FirestoreProvider();
  Future<Map<String, dynamic>> userResult;
  bool showWorkersApplicant = false;
  Map<String, dynamic> _arguments;
  Applicant applicant;
  Job job;
  var user;
  var rol;
  bool cancel = false;
  bool right = false;
  bool left = false;
  bool cardInformation = false;
  int cardPosition = 0;

  @override
  void initState() {
    super.initState();
    //userResult = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    job = _arguments['job'];
    user = _arguments['user'];
    rol = user.roles[0];
    print('FUNCIONES: ' + job.functions.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppbar(job),
          SliverList(
            delegate: SliverChildListDelegate([
              rol == 'WORKER' ? _workerDetails() : Text(''),
              rol == 'ADMINISTRATOR' ? _adminDetails() : Text(''),
            ]),
          )
        ],
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  _createAppbar(Job job) {
    return SliverAppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      iconTheme: IconThemeData(color: AppColors.workiColor),
      actions: <Widget>[
        rol == 'ADMINISTRATOR' ? IconButton(
          icon: Icon(Icons.edit, color:AppColors.workiColor, size: 20), 
          onPressed: (){

          }
        ) : Text(''),
        rol == 'ADMINISTRATOR' ?IconButton(
          icon: Icon(FontAwesome5.trash_alt, color:Colors.red, size: 18), 
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: Text('¿Está seguro que desea eliminar este trabajo?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Si'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        jobProvider.deleteJob(job.id);
                        setState(() {});
                      }, 
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }, 
                    )
                  ],
                );
              }
            );
          }
        ) : Text(''),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        title: Text(
          job.name,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
              fontSize: 16),
        ),
        centerTitle: true,
        background: Stack(
          //overflow: Overflow.visible,
          //fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.black),
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: FadeInImage(
                  image: job.jobPic != ''
                      ? NetworkImage(job.jobPic)
                      : AssetImage('assets/no-image.png'),
                  placeholder: AssetImage('assets/loading.gif'),
                  fit: BoxFit.cover),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _workerDetails() {
    return Column(
      children: <Widget>[
        _jobStatus(),
        _jobTitle(job, context),
        _description(job, context),
        _moreJobs(job),
      ],
    );
  }

  Widget _adminDetails() {
    return Column(
      children: <Widget>[
        JobTopWidget(job: job),
        _description(job, context),
        _workers(),
        _swipeCard(job.id),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _jobTitle(Job job, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 130,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: Colors.black38,
                  offset: Offset(1.0, 1.0))
            ],
            color: Colors.white),
        child: FutureBuilder(
          future: companyProvider.getCompanyById(job.companyId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              Company company = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'companyDetails',
                            arguments: {'company': company, 'user': user});
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 1),
                            borderRadius: BorderRadius.circular(100)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: company.profilePic != ''
                              ? Image.network(
                                  company.profilePic,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/no-image.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          //color: Colors.black,
                          child: Text(
                            company.name,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Text(
                            company.address,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: 'Lato', fontSize: 15),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.message,
                                    color: AppColors.workiColor,
                                  )),
                              IconButton(
                                  icon: Icon(Icons.directions,
                                      color: AppColors.workiColor),
                                  onPressed: () {})
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                child: ProfileShimmer(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _description(
    Job job,
    context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black38,
                )
              ],
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Descripción:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        color: AppColors.workiColor,
                        borderRadius: BorderRadius.circular(10)),
                    child:
                        Icon(Icons.attach_money, color: Colors.white, size: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(job.salary.toString(), style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        color: AppColors.workiColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.person, color: Colors.white, size: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(job.people.toString(), style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(FontAwesome5.calendar_check,
                          color: AppColors.workiColor, size: 18),
                      SizedBox(
                        width: 10,
                      ),
                      Text(job.getInitialDate(),
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesome5.calendar_times,
                          color: AppColors.workiColor, size: 18),
                      SizedBox(
                        width: 10,
                      ),
                      Text(job.getFinalDate(), style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(job.description,
                  textAlign: TextAlign.justify, style: TextStyle(fontSize: 15)),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  children: <Widget>[
                    for (int i = 0; i < job.functions.length; i++)
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Chip(
                            backgroundColor: Colors.black12,
                            label: Text(job.functions[i])),
                      ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _moreJobs(Job job) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Text(
              'Más trabajos',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              //color: Colors.black,
              child: FutureBuilder(
                future: jobProvider.getJobsByCompany(job.companyId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Job> jobs = snapshot.data;
                    int more = jobs.length - 2;
                    return Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: jobs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return JobPreviewWidget(job: jobs[i], user: user);
                        },
                      ),
                    );
                  } else {
                    return Container(
                      height: 200.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          SizedBox(width: 15),
                          for (int i = 0; i < 4; i++) JobShimmerWidget(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  addWorkerToApplicant(workerId, jobId, context) async {
    ApplicantsProvider applicantsProvider = new ApplicantsProvider();

    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Aplicando al trabajo',
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
    pr.show();
    Map<String, dynamic> data =
        await applicantsProvider.addWorkerToApplicant(workerId, jobId);
    setState(() {});
    if (pr.isShowing()) pr.hide();
    if (data['ok']) {
      showAlert(context, 'Se ha aplicado al trabajo satisfactoriamente');
    } else {
      data['message'] != null
          ? showAlert(context, "No es posible aplicar. " + data['message'])
          : showAlert(context, "No es posible aplicar al trabajo.");
    }
  }

  Widget showApplicants(jobId) {
    return FutureBuilder(
      future: workerProvider.getWorkersApplicantsByJobId(jobId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _createWorkersPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createWorkersPageView(List<Worker> workers) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: PageController(viewportFraction: 0.3, initialPage: 0),
        itemCount: workers.length,
        itemBuilder: (context, i) => _workerCard(workers[i]),
      ),
    );
  }

  Widget _workerCard(Worker worker) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: GestureDetector(
                  onTap: () {
                    var materialPageRoute;

                    materialPageRoute = MaterialPageRoute(
                        builder: (_) => new WorkerProfilePage(worker: worker));
                    Navigator.push(context, materialPageRoute);
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image(
                        image: worker.profilePic != null
                            ? NetworkImage(worker.profilePic)
                            : AssetImage('assets/no-image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: 100,
                        child: FlatButton(
                          color: Colors.green,
                          onPressed: () async {
                            print('aceptar');
                          },
                          child: Text('Aceptar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white)),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 100,
                        child: FlatButton(
                          color: Colors.red,
                          onPressed: () {
                            print('rechazar');
                          },
                          child: Text('Rechazar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              );
            });
      },
      child: Container(
        padding: EdgeInsets.only(top: 10),
        width: 120,
        height: 80,
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.workiColor),
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage(
                  image: worker.profilePic != null
                      ? NetworkImage(worker.profilePic)
                      : AssetImage('assets/no-image.png'),
                  placeholder: AssetImage('assets/noprofilepic.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              worker.name,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        margin: EdgeInsets.only(left: 8.0),
      ),
    );
  }

  Widget _bottomButton() {
    if (rol == 'WORKER') {
      if (!job.workersId.contains(user.id)) {
        return FutureBuilder(
          future: applicantProvider.getApplicantbyJobId(job.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              applicant = snapshot.data;
              bool isApplicant = applicant.workersId.contains(user.id);
              if (isApplicant) {
                return _unApplyButton();
              } else {
                return _applyButtom();
              }
            } else {
              if (snapshot.connectionState == ConnectionState.done) {
                return _applyButtom();
              } else {
                return Container(
                  height: 0,
                );
              }
            }
          },
        );
      } else {
        return Container(
          height: 0,
        );
      }
    }
  }

  Widget _applyButtom() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(gradient: Gradients.workiGradient, boxShadow: [
        BoxShadow(
            blurRadius: 3.0, color: Colors.black38, offset: Offset(3.0, 3.0))
      ]),
      child: FlatButton(
        onPressed: () {
          addWorkerToApplicant(user.id, job.id, context);
        },
        child: Text(
          'Postularme',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
    );
  }

  Widget _unApplyButton() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(gradient: Gradients.redGradient, boxShadow: [
        BoxShadow(
            blurRadius: 3.0, color: Colors.black38, offset: Offset(3.0, 3.0))
      ]),
      child: FlatButton(
        onPressed: () async {
          applicant.workersId.remove(user.id);
          await applicantProvider.updateApplicant(applicant);
          setState(() {});
        },
        child: Text(
          'Cancelar Postulación',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _swipeCard(jobId) {
    CardController controller;
    
    return FutureBuilder(
      future: workerProvider.getWorkersApplicantsByJobId(jobId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Worker> workers = snapshot.data;
          if (workers.length != 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Candidatos',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    )),
                Container(
                  height: MediaQuery.of(context).size.width*1.2,
                  child: TinderSwapCard(
                      orientation: AmassOrientation.TOP,
                      totalNum: workers.length,
                      stackNum: 3,
                      swipeEdge: 4.0,
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.width * 0.9,
                      minWidth: MediaQuery.of(context).size.width * 0.89,
                      minHeight: MediaQuery.of(context).size.width * 0.89,
                      cardBuilder: (context, index) { 
                        
                        return Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: GestureDetector(
                            onTap: () {
                              print('PERFIL');
                              setState(() {
                                cardInformation = !cardInformation;
                              });
                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height:MediaQuery.of(context).size.width * 0.9,
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                        workers[index].profilePic,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    height: cardInformation ==false || cardPosition != index ? MediaQuery.of(context).size.width *0.2 : MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Color.fromARGB(255, 0, 0, 0),
                                              Color.fromARGB(0, 0, 0, 0),
                                            ])),
                                  ),
                                ),
                                AnimatedAlign(
                                  duration: Duration(milliseconds: 300),
                                  alignment: cardInformation ==false || cardPosition != index ? Alignment.bottomCenter : Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(workers[index].name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text(workers[index].getAge().toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    height: cardInformation ==false || cardPosition != index ? 0 :  MediaQuery.of(context).size.width * 0.7,
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      
                                    ),
                                  ),
                                ),
                                AnimatedAlign(
                                  duration: Duration(milliseconds: 100),
                                  alignment: Alignment.topLeft,
                                  child: Transform.rotate(
                                    angle: 100,
                                    child: right == true  && cardPosition == index 
                                        ? Container(
                                            height: 60,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            margin: EdgeInsets.only(top: 50),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 5),
                                            ),
                                            child: Center(
                                              child: Text('ACEPTAR',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25)),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ),
                                AnimatedAlign(
                                  duration: Duration(milliseconds: 100),
                                  alignment: Alignment.topRight,
                                  child: Transform.rotate(
                                    angle: -100,
                                    child: left == true  && cardPosition == index 
                                        ? Container(
                                            height: 60,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            margin: EdgeInsets.only(top: 50),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.red,
                                                  width: 5),
                                            ),
                                            child: Center(
                                              child: Text('RECHAZAR',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25)),
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      cardController: controller = CardController(),
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        /// Get swiping card's alignment
                        if (align.x > -1 && align.x < 1) {
                          setState(() {
                            right = false;
                            left = false;
                          });
                        }
                        if (align.x < -1) {
                          setState(() {
                            left = true;
                          });
                        } else if (align.x > 1) {
                          setState(() {
                            right = true;
                          });
                        }
                      },
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) {
                        /// Get orientation & index of swiped card!
                        if (orientation == CardSwipeOrientation.RIGHT) {
                          applicantProvider.acceptApplicant(workers[index], job, context);
                          setState(() {
                            cardPosition++;
                            right = false;
                            left = false;
                          });
                        }
                        if (orientation == CardSwipeOrientation.LEFT) {
                          print('POS ++');
                          setState(() {
                            cardPosition++;
                            right = false;
                            left = false;
                          });
                        }
                      }),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _workers() {
    return FutureBuilder(
      future: jobProvider.getWorkersByJobId(job.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          List<Worker> workers = snapshot.data;
          if(workers.length != 0){
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Trabajadores',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Lato'
                        )
                      ),
                      GestureDetector(
                        onTap: (){
                          print('ACA');
                          Navigator.of(context).pushNamed('workers_list_page',arguments:{'workers':workers, 'job':job});
                        },
                        child: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: workers.length,
                    itemBuilder: (context, i) {
                      return Row(
                        children: <Widget>[
                          i == 0 ? SizedBox(width: 15,) : Container(),
                          UserSmallCardWidget(user: workers[i]),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }else{
            return Container();
          }
        }else{
          return Container();
        }
      },
    );
  }

  Widget _jobStatus() {
    if (job.workersId.contains(user.id)) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: 70,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.only(left: 10),
        decoration: cancel == false
            ? BoxDecoration(
                gradient: Gradients.workiGradient,
                borderRadius: BorderRadius.circular(10))
            : BoxDecoration(
                gradient: Gradients.redGradient,
                borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            cancel == false
                ? Row(
                    children: <Widget>[
                      Text('Fuiste aceptado en este trabajo',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: Text('¿Seguro que deseas quitar este trabajo?',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.white),
                        onPressed: () {
                          var pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
                          firestoreProvider.deleteMemberFromChat(job.eventId, user.id);
                          job.workersId.remove(user.id);
                          jobProvider.updateJob(job);
                          setState(() {});
                        },
                      )
                    ],
                  ),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.white),
              onPressed: () {
                setState(() {
                  cancel = !cancel;
                  print(cancel.toString());
                });
              },
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
