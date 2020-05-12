import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/rating_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/administrator_provider.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/providers/event_provider.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';
import 'package:worki_ui/src/providers/job_provider.dart';
import 'package:worki_ui/src/providers/worker_provider.dart';
import 'package:worki_ui/src/utils/alert.dart';
import 'package:worki_ui/src/utils/shimmers/event_card_shimmer.dart';
import 'package:worki_ui/src/utils/shimmers/job_shimmer_widget.dart';
import 'package:worki_ui/src/values/button_decoration.dart';
import 'package:worki_ui/src/values/colors.dart';
import 'package:worki_ui/src/widgets/event_card_widget.dart';
import 'package:worki_ui/src/widgets/job_preview_widget.dart';

class CompanyDetails extends StatelessWidget {
  CompanyProvider companyProvider = new CompanyProvider();
  Map<String, dynamic> _arguments;
  EventsProvider _eventsProvider = new EventsProvider();
  JobsProvider _jobsProvider = new JobsProvider();
  WorkerProvider _workerProvider = new WorkerProvider();
  AdministratorProvider administratorProvider = new AdministratorProvider();
  FirebaseProvider firebaseProvider = new FirebaseProvider();

  Company company;
  User user;
  String rol;
  final commentController = TextEditingController();
  var rateValue = 1;
  bool cambioRate = false;
  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    company = _arguments['company'];
    user = _arguments['user'];
    rol = user.roles[0];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: AppColors.workiColor),
        centerTitle: true,
        title: Text(company.name, style: TextStyle(color: Colors.black)),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              _companyPic(company, context),
              _companyTitle(company, context),
              SizedBox(
                height: 10.0,
              ),
              _description(company),
              SizedBox(
                height: 20.0,
              ),
              _companyEvents(company),
              SizedBox(
                height: 20.0,
              ),
              _companyJobs(company),
              SizedBox(
                height: 20,
              ),
              _comments(company, context),
              SizedBox(
                height: 40,
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget _companyPic(Company company, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          rol == 'ADMINISTRATOR'
              ? IconButton(
                  icon: Icon(Icons.edit, color: AppColors.workiColor),
                  onPressed: () {
                    Navigator.pushNamed(context, 'edit_company',
                        arguments: company);
                  },
                )
              : Container(),
          SizedBox(),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      color: Colors.black38,
                      offset: Offset(1.0, 1.0))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: Image.network(
                company.profilePic,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(),
          rol == 'ADMINISTRATOR'
              ? IconButton(
                  icon:
                      Icon(FontAwesome5.trash_alt, color: AppColors.workiColor),
                  onPressed: () {
                    _confirmRemoveCompany(company.id, context);
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _companyTitle(Company company, BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  color: Colors.black38,
                  offset: Offset(0.0, 0.0))
            ]),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              company.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Lato'),
              overflow: TextOverflow.ellipsis,
            ),
            RatingBar(
              initialRating: company.getRating(),
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 10,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_city, color: AppColors.workiColor),
                      SizedBox(width: 5),
                      Text(
                        'Ciudad: ',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  company.city != null
                      ? Text(company.city, style: TextStyle(fontSize: 18))
                      : Container(),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: AppColors.workiColor),
                      SizedBox(width: 5),
                      Text('Dirección: ', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Text(company.address, style: TextStyle(fontSize: 18))
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.phone, color: AppColors.workiColor),
                      SizedBox(width: 5),
                      Text('Número: ', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(width: 10),
                  Text(company.phone.toString(), style: TextStyle(fontSize: 18))
                ],
              ),
            ),
          ],
        ));
  }

  Widget _description(Company company) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  color: Colors.black38,
                  offset: Offset(0.0, 0.0))
            ]),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Descripción:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 200,
              child: Stack(
                children: <Widget>[
                  ListView(
                    shrinkWrap: false,
                    physics: ScrollPhysics(),
                    children: <Widget>[
                      Text(
                        company.description,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(200, 255, 255, 255),
                            Color.fromARGB(100, 255, 255, 255),
                            Color.fromARGB(0, 255, 255, 255)
                          ])),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ));
  }

  void updateCompany(BuildContext context, Company company) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Agregando calificación de la empresa',
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

    Map<String, dynamic> data = await companyProvider.updateCompany(company);
    if (pr.isShowing()) pr.hide();
    if (data['ok']) {
      showAlert(context, 'Se ha calificado satisfactoriamente');
      //refreshs
      (context as Element).reassemble();
    } else {
      data['message'] != null
          ? showAlert(
              context, "No es posible calificar la empresa. " + data['message'])
          : showAlert(context, "No es posible calificar la empresa.");
    }
  }

  Widget _companyEvents(Company company) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Eventos',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato')),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: _eventsProvider.getEventsByCompany(company.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Event> events = snapshot.data;
                return Container(
                  height: events.length > 0 ? 200 : 10,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, i) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width,
                            child: EventCardWidget(e: events[i], user: user));
                      }),
                );
              } else {
                return EventCardShimmer();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _companyJobs(Company company) {
    return Container(
      child: FutureBuilder(
        future: _jobsProvider.getJobsByCompany(company.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Job> jobs = snapshot.data;
            return Column(
              children: <Widget>[
                jobs.length != 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text('Trabajos Destacados',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato')),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            )
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: jobs.length > 0 ? 200 : 10,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      itemCount: jobs.length,
                      itemBuilder: (context, i) {
                        return Row(
                          children: <Widget>[
                            i == 0 ? SizedBox(width: 10) : Container(),
                            JobPreviewWidget(job: jobs[i], user: user),
                          ],
                        );
                      }),
                ),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 20,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    children: <Widget>[
                      for (int i = 0; i < 4; i++) JobShimmerWidget(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  _comments(Company company, BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  color: Colors.black38,
                  offset: Offset(0.0, 0.0))
            ]),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Comentarios:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            company.rating.length > 0
                ? Container(
                    height: company.rating.length > 1 ? 220 : 110,
                    child: Stack(
                      children: <Widget>[
                        ListView(
                            shrinkWrap: false,
                            physics: ScrollPhysics(),
                            children: company.rating
                                .map((item) => _commentCard(item))
                                .toList()),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(200, 255, 255, 255),
                                  Color.fromARGB(100, 255, 255, 255),
                                  Color.fromARGB(0, 255, 255, 255)
                                ])),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(child: Text('Aún no hay comentarios')),
            SizedBox(
              height: 30.0,
            ),
            rol == 'WORKER'
                ? Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Califica la empresa:',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RatingBar(
                              initialRating: rateValue.toDouble(),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 10,
                              ),
                              onRatingUpdate: (rating) {
                                rateValue = rating.toInt();
                                cambioRate = true;
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          maxLines: 3,
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: "Comenta acerca de" + company.name,
                            hintStyle: TextStyle(color: Colors.white30),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(25.0))),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Center(
                          child: Container(
                            decoration: ButtonDecoration.workiButton,
                            height: 40,
                            width: 120,
                            child: FlatButton(
                              onPressed: () {
                                bool already = false;

                                company.rating.forEach((v) {
                                  if (v.userId == user.id) {
                                    if (cambioRate) {
                                      v.value = rateValue.toInt();
                                    }
                                    v.comment = commentController.text;
                                    already = true;
                                  }
                                });

                                if (!already) {
                                  Rating rat = new Rating();
                                  rat.userId = user.id;
                                  rat.value = rateValue.toInt();
                                  rat.comment = commentController.text;
                                  company.rating.add(rat);
                                }

                                updateCompany(context, company);
                              },
                              child: Text(
                                'Calificar',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ));
  }

  Widget _commentCard(Rating rating) {
    return FutureBuilder(
      future: _workerProvider.getWorker(rating.userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['ok']) {
          Worker worker = Worker.fromJson(snapshot.data['worker']);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: worker.profilePic != null
                    ? NetworkImage(worker.profilePic)
                    : AssetImage('assets/no-image.png'),
              ),
              title: new Column(
                children: <Widget>[
                  Text(worker.name),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RatingBar(
                        initialRating: rating.value.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 10,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              subtitle: rating.comment != null
                  ? Text(
                      rating.comment,
                      textAlign: TextAlign.justify,
                    )
                  : Text('...', textAlign: TextAlign.center),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void _confirmRemoveCompany(String id, BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("¿Está seguro de eliminar la empresa?"),
          content: new Text(
              "También se eliminarán los eventos, los trabajos actuales, el administrador y los coordinadores"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Sí"),
              onPressed: () {
                removeCompany(id, context);
              },
            ),
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void removeCompany(String id, BuildContext context) async {
    var pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Eliminando la empresa',
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

    final data = await companyProvider.deleteCompany(id);
    if (pr.isShowing()) pr.hide();
    if (data) {
      showAlert(context, 'Se ha eliminado la empresa satisfactoriamente');
      final dataAdmin =
          await administratorProvider.deleteAdministrator(user.id);
      if (dataAdmin) {
        showAlert(
            context, 'Se ha eliminado el administrador satisfactoriamente');
        firebaseProvider.signOut();
        Navigator.of(context).pushReplacementNamed('welcome');
      } else {
        showAlert(context, "No es posible eliminar los datos.");
      }
    } else {
      showAlert(context, "No es posible eliminar los datos.");
    }
  }
}
