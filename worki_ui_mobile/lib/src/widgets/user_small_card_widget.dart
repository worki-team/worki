import 'package:flutter/material.dart';

class UserSmallCardWidget extends StatelessWidget {
  var user;
  var companyId;
  UserSmallCardWidget({this.user, this.companyId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.symmetric(horizontal: 10),
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
              child: user.profilePic != '' ? 
                Image.network(user.profilePic, fit: BoxFit.cover):
                Image.asset('assets/noprofilepic.png', fit: BoxFit.cover)
            ),
          ),
          onTap: (){
            if(user.roles[0] == 'WORKER'){
 Navigator.of(context)
                .pushNamed('profile_page', arguments: {'worker': user,'user':user,'companyId':companyId});            }
          },
        ),
        SizedBox(height: 10,),
        Text(user.name),
      ],
    );
  }
}