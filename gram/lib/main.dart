import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gram/Homepage/homepage.dart';
import 'package:gram/Sign/signin.dart';
import 'package:gram/Sign/signup.dart';
import 'package:gram/email/email.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        title: 'UI Design',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SignInPage(),
          '/signup': (context) => SignUpPage(),
          '/signin': (context) => SignInPage()
        });
  }
}
