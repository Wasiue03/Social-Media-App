import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gram/Chathub/chat.dart';
import 'package:gram/Homepage/homepage.dart';
import 'package:gram/Sign/signin.dart';
import 'package:gram/Sign/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          '/': (context) => const SignInPage(),
          '/signup': (context) => const SignUpPage(),
          '/signin': (context) => const SignInPage()
        });
  }
}
