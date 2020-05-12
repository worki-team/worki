import 'package:flutter/material.dart';
import 'package:worki_ui/src/models/company_model.dart';
import 'package:worki_ui/src/models/event_model.dart';
import 'package:worki_ui/src/providers/company_provider.dart';

class EventCardWidget extends StatelessWidget {
  final Event e;
  final user;
  EventCardWidget({this.e, this.user});

  CompanyProvider companyProvider = new CompanyProvider();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('event_details',arguments: {'event':e,'user':user});
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black38,
              offset: Offset(3.0, 3.0)
            )
          ],
          borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: e.eventPic == null || e.eventPic == '' ? 
                  Image.network('https://image.shutterstock.com/image-vector/picture-vector-icon-no-image-260nw-1350441335.jpg', fit: BoxFit.cover)
                  :Image.network(e.eventPic, fit: BoxFit.cover) 
                ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 50,
                width: 50,
                margin: EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FutureBuilder(
                      future: companyProvider.getCompanyById(e.companyId),
                      builder: (BuildContext context,
                          AsyncSnapshot<Company> snapshot) {
                        if (snapshot.hasData) {
                          final company = snapshot.data;

                          return Image.network(company.profilePic,
                              fit: BoxFit.cover);
                        } else {
                          return Image(
                            image: AssetImage('assets/no-image.png'),
                          );
                        }
                      },
                    )),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  e.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}