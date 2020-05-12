import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worki_ui/src/pages/Shared/register_user1_page.dart';
import 'package:worki_ui/src/providers/firebase_provider.dart';

class CreateCoordinatorPage extends StatefulWidget {
  CreateCoordinatorPage({Key key}) : super(key: key);

  @override
  _CreateCoordinatorPageState createState() => _CreateCoordinatorPageState();
}

class _CreateCoordinatorPageState extends State<CreateCoordinatorPage> {
  FirebaseProvider firebaseProvider = FirebaseProvider();

  @override
  Widget build(BuildContext context) {
    return RegisterUser1Page();
  }
}
