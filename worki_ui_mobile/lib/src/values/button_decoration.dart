import 'package:flutter/material.dart';
import 'package:worki_ui/src/values/values.dart';

class ButtonDecoration {
  static BoxDecoration workiButton = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: Gradients.workiGradient,
    boxShadow: [
      BoxShadow(
        color: Colors.black38,
        blurRadius: 3,
        offset: Offset(3,3)
      )
    ]
  );
}