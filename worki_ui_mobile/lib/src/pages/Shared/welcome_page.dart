
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:worki_ui/src/values/values.dart';
import 'package:worki_ui/src/providers/user_provider.dart';

import '../../values/button_decoration.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselWithIndicator(),
    );
  }
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  //int _current = 0;
  //var quotes = ['¿Te atreves a cambiar la forma de trabajar?','Potencializa tus talentos.','Consigue trabajo donde quieras y cuando quieras.','¿Te le mides a esta nueva experiencia?'];
  Map <String,String> quotes = {
    'welcome1.jpeg':'¿Te atreves a cambiar la forma de trabajar?',
    'welcome2.jpeg':'Potencia tus talentos.',
    'welcome3.jpeg':'Consigue trabajo donde quieras y cuando quieras.',
    'welcome4.jpeg':'¿Te le mides a esta nueva experiencia?'
  };
  UserProvider userProvider = new UserProvider();

  int position = 0;
  var _images =  ['welcome1.jpeg','welcome2.jpeg','welcome3.jpeg','welcome4.jpeg'];
  
  @override
  Widget build(BuildContext context) {
    CarouselSlider _carousel =  CarouselSlider(
      height: MediaQuery.of(context).size.height*1.3,
      autoPlay: false,
      autoPlayInterval: Duration(seconds: 5),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.decelerate,
      viewportFraction: 1.0,
      initialPage: 0,
      enableInfiniteScroll: false,
      aspectRatio: MediaQuery.of(context).size.aspectRatio,
      onPageChanged: (pos){
        setState(() {
          position = pos;
        });
      },
      items:_images.map((i) {
        return Stack(
          children: [
            _backgroundImage(i),
            _blackShadow(),
            _quoteButtons(i),
           
          ]
        );
      }).toList(),
    );
    return Stack(

      children: [
        _carousel,
        _nextButton(position, _carousel),
        _workiImage(),
        _bottomIndicator(position)
      ]
    );
  }

  Widget _backgroundImage(String i){
    return Image.asset(
      'assets/$i',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,   
    );
  }

  Widget _blackShadow(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 500,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(1),
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.025),
              Colors.black.withOpacity(0.0)
            ],
          ),
        ),
      ),
    );
  }

  Widget _quoteButtons(String i){
    
    if(i == 'welcome4.jpeg'){
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                quotes[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                  fontSize: 30,
                  decoration: TextDecoration.none
                ),
              ),
              SizedBox(height: 30.0,),
              Container(
                height: 50,
                width: 233,
                decoration: ButtonDecoration.workiButton,
                child: FlatButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/');
                  }, 
                  textColor: Color.fromARGB(255, 255, 255, 255),
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Iniciar sesión",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
               Container(
                height: 50,
                width: 233,
                decoration: ButtonDecoration.workiButton,
                child: FlatButton(
                  onPressed: (){
                    Navigator.pushNamed(context, 'register_main');
                  }, 
                  textColor: Color.fromARGB(255, 255, 255, 255),
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Registrarme",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      );
    }
    return  Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 200),
        child: Text(
          quotes[i],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: 'Lato',
            decoration: TextDecoration.none
          ),
        )
      ),
    );
  }

  Widget _nextButton(int i, CarouselSlider _car){
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            i != 0 ? GestureDetector(
              child:  Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ), 
              onTap: (){
                _car.previousPage(duration: Duration(milliseconds: 200), curve: Curves.decelerate);
              },
            ) : Container(),
            i != 3 ? GestureDetector(
              child:  Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ), 
              onTap: (){
                _car.nextPage(duration: Duration(milliseconds: 200), curve: Curves.decelerate);
              },
            ) : Container(),
          ],
        
        ),
      ),
    );
  
  }

  Widget _workiImage(){
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height*0.5,
      child: Image.asset('assets/w.png',fit:BoxFit.cover),
    );
  }

  Widget _bottomIndicator(int pos){
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        //color:Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i<4; i++) 
              Container(width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == pos ? Color.fromRGBO(255, 255, 255, 1) : Color.fromRGBO(255, 255, 255, 0.3)
                ),),
          ],
        ),
      ) 
    );
  }

}
