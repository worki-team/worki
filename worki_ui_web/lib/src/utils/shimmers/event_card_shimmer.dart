import 'package:flutter/material.dart';

class EventCardShimmer extends StatelessWidget {
  const EventCardShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20)
      ),
     
    );
  }
}