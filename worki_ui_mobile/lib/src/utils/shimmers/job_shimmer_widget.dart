import 'package:flutter/material.dart';

class JobShimmerWidget extends StatelessWidget {
  const JobShimmerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 3,),
        Container(
          height: 10,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ],
    );
  }
}