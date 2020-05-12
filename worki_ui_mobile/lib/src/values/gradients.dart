
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Gradients {
  static const Gradient shadowGradient =LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Colors.black
    ],
  );
  static const Gradient workiGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      //Color.fromARGB(255, 175, 225, 254),
      Color.fromARGB(255, 147, 214, 254),
      Color.fromARGB(255, 104, 198, 254),
      Color.fromARGB(255, 59, 180, 254),
    ],
  );

  static const Gradient greenGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      //Color.fromARGB(255, 175, 225, 254),
      Color.fromARGB(255, 0, 228, 17),
      Color.fromARGB(255, 0, 200, 15),
      Color.fromARGB(255, 0, 171, 13),
    ],
  );

  static const Gradient redGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      //Color.fromARGB(255, 175, 225, 254),
      Color.fromARGB(255, 255, 120, 120),
      Color.fromARGB(255, 255, 80, 80),
      Color.fromARGB(255, 255, 0, 0),
    ],
  );

  static const Gradient blueGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      //Color.fromARGB(255, 175, 225, 254),
      Color.fromARGB(255, 121, 191, 255),
      Color.fromARGB(255, 77, 171, 255),
      Color.fromARGB(255, 0, 135, 255),
    ],
  );

  static const Gradient darkBlueGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      //Color.fromARGB(255, 175, 225, 254),
      Color.fromARGB(255, 112, 118, 255),
      Color.fromARGB(255, 64, 72, 255),
      Color.fromARGB(255, 0, 12, 255),
    ],
  );

  //linear-gradient(to right, rgb(0, 180, 219), rgb(0, 131, 176))

  
}