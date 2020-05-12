import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/job_model.dart';

class JobPreviewWidget extends StatelessWidget {
  final Job job;
  final user;
  JobPreviewWidget({@required this.job,@required  this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if(user != null){
              Navigator.of(context).pushNamed('jobDetails', arguments: {'job':job,'user':user});
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            height: 140,
            width: 140,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 232, 232),
                //gradient: Gradients.workiGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3.0,
                      color: Colors.black38,
                      offset: Offset(3.0, 3.0))
                ]),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 140,
                  width: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: job.jobPic == null || job.jobPic == ''
                     ? Image.network('https://image.shutterstock.com/image-vector/picture-vector-icon-no-image-260nw-1350441335.jpg', fit: BoxFit.cover)
                    : Image.network(job.jobPic, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          job.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato'),
        ),
        Row(
          children: <Widget>[
            Icon(Icons.calendar_today, size: 15),
            Text(
              job.getInitialDate(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Lato'),
            ),
          ],
        ),
      ],
    );
  }
}