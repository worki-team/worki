import 'dart:convert';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/coordinator_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/models/job_model.dart';
import 'package:worki_ui/src/models/worker_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';
import 'package:worki_ui/src/values/colors.dart';

class JobCardWidget extends StatelessWidget {
  final Job job;
  final user;
  
  JobCardWidget({@required this.job, this.user});
  CompanyProvider companyProvider = new CompanyProvider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: GestureDetector(
        onTap: () {
          if(user != null){
            Navigator.of(context).pushNamed('jobDetails', arguments: {'job':job,'user':user});
          }
         
        },
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 5.0,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder(
                future: companyProvider.getCompanyById(job.companyId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    final company = snapshot.data;
                    return Stack(
                      children: <Widget>[
                        _backgroundPicture(),
                        _blackShadow(),
                        _topCardContent(company),
                        _bottomCardContent(),
                      ],
                    );
                  } else {
                    return Container(
                      /*height: 400.0,
                      child: Center(
                        child: AwesomeLoader(
                          loaderType: AwesomeLoader.AwesomeLoader4,
                          color: AppColors.workiColor,
                        ),
                      )*/
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget _backgroundPicture() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: job.jobPic != '' && job.jobPic != null
          ? FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage(job.jobPic),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          : Image.network(
              'https://image.shutterstock.com/image-vector/picture-vector-icon-no-image-260nw-1350441335.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
    );
  }

  Widget _blackShadow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _companyPhoto(Company company) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: company.profilePic != '' || company.profilePic != null
            ? FadeInImage(
                placeholder: AssetImage('assets/loading.gif'),
                image: NetworkImage(company.profilePic),
                fit: BoxFit.cover,
              )
            : Image.network(
                'https://image.shutterstock.com/image-vector/picture-vector-icon-no-image-260nw-1350441335.jpg',
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _companyRating(int rating) {
    return Row(
      children: <Widget>[
        for (var i = 0; i < rating; i++) Icon(Icons.star, color: Colors.yellow),
      ],
    );
  }

  Widget _topCardContent(Company company) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _companyPhoto(company),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      company.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    _companyRating(company.getRating().toInt()),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomCardContent() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      job.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          job.getInitialDate(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(children: <Widget>[
                  Icon(Icons.person, color: Colors.white),
                  Text(job.people.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Lato',
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ))
                ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (var i = 0; i < job.functions.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Chip(
                        backgroundColor: Colors.white,
                        label: Text(job.functions[i])),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
