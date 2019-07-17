import 'package:flutter/material.dart';
import 'package:project_final/login.dart';
void main() => runApp(MainApp(
));
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login app',
      home: LoginPage(),
      theme: ThemeData(
        primaryColor: Colors.blue[200]
      ),
    );
  }
}