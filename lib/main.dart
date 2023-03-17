import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:startup_name/api/firestore.dart';
import 'package:startup_name/views/AccountPage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:startup_name/views/MenuPage.dart';
import 'api/firebase_options.dart';

import 'views/ClothesListPage.dart';
import 'views/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var page = await Firestore.isLoggedIn() ? 'home' : 'login';
  runApp(MyApp(page: 'login'));
}

class MyApp extends StatelessWidget {
  String page;
  MyApp({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIAGED',
      home: page == 'login' ? LoginPage() : MenuPage(),
    );
  }
}


