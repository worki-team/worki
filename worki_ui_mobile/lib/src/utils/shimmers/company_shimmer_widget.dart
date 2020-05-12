import 'package:flutter/material.dart';

class CompanyShimmer extends StatelessWidget {
  const CompanyShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
          SizedBox(height: 5,),
          Container(
            height: 10,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ],
      ),
    );
  }
}