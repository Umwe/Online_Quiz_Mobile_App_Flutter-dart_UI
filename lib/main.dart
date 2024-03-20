import 'package:flutter/material.dart';
import 'admin_landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AdminLandingScreen(), // Set the landing screen for the admin
    );
  }
}
