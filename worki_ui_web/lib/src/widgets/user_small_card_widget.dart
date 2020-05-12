import 'package:flutter/material.dart';

class UserSmallCardWidget extends StatelessWidget {
  var user;
  UserSmallCardWidget({this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black38,
                offset: Offset(0.0, 0.0)
              )
            ],
            color: Colors.white
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(user.profilePic),
          ),
        ),
        Text(user.name),
      ],
    );
  }
}