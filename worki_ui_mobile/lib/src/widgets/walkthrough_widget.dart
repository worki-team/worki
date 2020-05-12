import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:worki_ui/src/values/values.dart';

class WalkThroughWidget extends StatefulWidget {
  WalkThroughWidget({Key key}) : super(key: key);

  @override
  _WalkThroughWidgetState createState() => _WalkThroughWidgetState();
}

class _WalkThroughWidgetState extends State<WalkThroughWidget> {
  bool walkthrough = true;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 0;
  int home = 0;


  @override
  Widget build(BuildContext context) {
    return walkthrough == true 
      ? Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          /*Image.asset('assets/Walkthrough/walk6.jpeg'),
          Image.asset('assets/Walkthrough/walk4.jpeg'),
          Image.asset('assets/Walkthrough/walk2.jpeg'),
          Image.asset('assets/Walkthrough/walk3.jpeg'),*/                  
          _page == 0 ? _homePage() : Container(),
          _page == 1 ? _jobsPage() : Container(),
          _page == 2 ? _profilePage() :  Container(),

          _page != 2 ?Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 30,
              width: 140,
              margin: EdgeInsets.all(20),
              decoration: ButtonDecoration.workiButton,
              child: FlatButton(
                onPressed: (){
                  setState(() {
                    walkthrough = false;
                  });
                }, 
                child:  Text('Saltar Tutorial', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
              )
            ),
          ): Container(),
        ],
      ),
    )
    :Container();
  }

  Widget _homePage(){
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              /*SizedBox(
                height: 30,
              ),
              _welcomeHeader(),
              SizedBox(
                height: 40,
              ),*/
              Expanded(child: Image.asset('assets/Walkthrough/walk6.jpeg'))
            ],
          ),
          home == 0 ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black38,
          ) : Container(),
          home == 0 ? Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              padding: EdgeInsets.all(10),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('A continuación verás un ejemplo de los componentes del sistema.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height:10),
                  Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: ButtonDecoration.workiButton,
                    child: FlatButton(
                      onPressed: (){
                        setState(() {
                          home++;
                        });
                      }, 
                      child:  Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    )
                  ),
                ],
              ),
            )
          ) : Container(),
          home == 1 ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 80, left: 20, right:20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow:[
                  BoxShadow(
                    blurRadius: 40,
                    color: Colors.black38
                  )
                ]
              ),
              constraints: BoxConstraints(maxHeight: 200, minHeight: 150),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Acá encontrarás la información de tus próximos trabajos y en los que aún no has sido aceptado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height:10),
                  Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: ButtonDecoration.workiButton,
                    child: FlatButton(
                      onPressed: (){
                        setState(() {
                          _page++;
                        });
                      }, 
                      child:  Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    )
                  )
                ],
              )
            ),
          ):Container(),
        ],
      ),
    );
  }

  Widget _jobsPage(){
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset('assets/Walkthrough/walk4.jpeg', fit: BoxFit.cover)
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 80, left: 20, right:20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow:[
                BoxShadow(
                  blurRadius: 40,
                  color: Colors.black38
                )
              ]
            ),
            constraints: BoxConstraints(maxHeight: 200, minHeight: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('En esta pestaña podrás buscar los trabajos que se adaptan a lo que buscas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20)
                ),
                SizedBox(height:20),
                Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: ButtonDecoration.workiButton,
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        _page++;
                      });
                    }, 
                    child:  Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  )
                )
              ],
            )
          ),
        )

      ],
    );
  }

  Widget _profilePage(){
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //margin: EdgeInsets.only(top:60),
          child: Image.asset('assets/Walkthrough/walk2.jpg', fit: BoxFit.cover)
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 80, left:20, right:20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow:[
                BoxShadow(
                  blurRadius: 40,
                  color: Colors.black38
                )
              ]
            ),
            constraints: BoxConstraints(maxHeight: 150, minHeight: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Finalmente, acá encontraras tu perfil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20)
                ),
                SizedBox(height:20),
                Container(
                  height: 50,
                  width: 120,
                  alignment: Alignment.center,
                  decoration: ButtonDecoration.workiButton,
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        walkthrough = false;
                      });
                    }, 
                    child:  Text('Empecemos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  )
                )
              ],
            )
          ),
        )
      ],
    );
  }

  Widget _welcomeHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              'Hola ',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'Lato'),
            ),
          ),
        ],
      ),
    );
  }


   Widget _navigationBar() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 2,
      height: 60.0,
      items: <Widget>[
        Icon(FontAwesome.comments, size: 30, color: AppColors.workiColor),
        Icon(FontAwesome.search, size: 30, color: AppColors.workiColor),
        Icon(Icons.home, size: 30, color: AppColors.workiColor),
        Icon(Icons.person, size: 30, color: AppColors.workiColor),
        Icon(Icons.settings, size: 30, color: AppColors.workiColor),
      ],
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.white10.withOpacity(0.001),
      animationCurve: Curves.easeInCubic,
      animationDuration: Duration(milliseconds: 600),
      onTap: (index) {
        setState(() {
          _page = index;
        });
      },
    );
  }
   Widget _blackShadow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.02),
              Colors.black.withOpacity(0)
            ],
          ),
        ),
      ),
    );
  }
}