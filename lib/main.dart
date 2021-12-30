// models
import 'package:chatting_app/models/firebase_provider.dart';
// screens
import 'package:chatting_app/screens/home.dart';
import 'package:chatting_app/screens/signin.dart';
// packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyCSJ7dHEZRtX4vsc-Rv4qLfdcG4OVG4Xv8',
        appId: '1:699318556246:android:0fe5cd54d95417a27c8df7',
        messagingSenderId: '699318556246',
        projectId: 'flutter-my-chatting-app',
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseProvider())
      ],
      child: MaterialApp(
        title: 'Chatting App',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/signin': (context) => SignIn(),
        },
        // home: SignIn()
      ),
    );
  }
}
