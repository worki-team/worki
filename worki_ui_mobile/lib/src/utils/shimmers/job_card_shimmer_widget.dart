import 'package:flutter/material.dart';

class JobCardShimmer extends StatelessWidget {
  const JobCardShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      width: MediaQuery.of(context).size.width,
      margin:  EdgeInsets.only(top:5, right: 5, left: 5),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(width: 10,),
              Container(
                height: 20,
                width: 100,
                  decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(100),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 20,
                  width: 200,
                    decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  height: 15,
                  width: 100,
                    decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(100),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}