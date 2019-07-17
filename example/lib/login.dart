import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_final/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var ttcode = "";

  @override
  void initState() {
    getTcode();
    super.initState();
  }

  getTcode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ttcode = prefs.getString('tcode');

    if (ttcode == "" || ttcode == null) {
      print("This");
      _getQTeachers();
    } else {
      print("That");
      var homeRounte = new MaterialPageRoute(
        builder: (BuildContext context) => HomePage(
              username: prefs.getString('username'),
              email: prefs.getString('email'),
              tcodes: prefs.getString('tcode'),
            ),
      );
      Navigator.of(context).pushReplacement(homeRounte);
    }
  }

  TextEditingController ctrlUsername = new TextEditingController();
  TextEditingController ctrlPassword = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Future<List<QTeacher>> _getQTeachers() async {
    var data = await http.get("https://sutclass.herokuapp.com/Login/" +
        ctrlUsername.text +
        "/" +
        ctrlPassword.text);
    List<QTeacher> qTeachers = [];
    final prefs = await SharedPreferences.getInstance();

    var jsonData = json.decode(data.body);
    for (var i in jsonData) {
      QTeacher qTeacher = QTeacher(
          i["tid"], i["tcode"], i["tpassword"], i["tusername"], i["temail"]);
      qTeachers.add(qTeacher);

      prefs.setString('tcode', qTeachers[0].tcode);
      prefs.setString('username', ctrlUsername.text);
      prefs.setString('email', qTeachers[0].temail);
      var homeRounte = new MaterialPageRoute(
        builder: (BuildContext context) => HomePage(
              username: prefs.getString('username'),
              email: prefs.getString('email'),
              tcodes: prefs.getString('tcode'),
            ),
      );
      Navigator.of(context).pushReplacement(homeRounte);
    }
    return qTeachers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
                // image: DecorationImage(
                //     fit: BoxFit.cover,
                //     image: AssetImage('assets/Picture/5.jfif')),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/Picture/login.PNG')
                      )
                  )),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) return 'กรุราระบุชื่อผู้ใช้';
                    },
                    controller: ctrlUsername,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 20.0),
                        prefixIcon: Icon(Icons.people),
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.white70,
                        border: InputBorder.none),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) return 'กรุณาระบุรหัสผ่าน';
                    },
                    controller: ctrlPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 20.0),
                        prefixIcon: Icon(Icons.vpn_key),
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white70,
                        border: InputBorder.none),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  RaisedButton(
                    onPressed: () => Teacher(),
                    color: Colors.white,
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.black38),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Teacher() async {
    if (_formKey.currentState.validate()) {
      _getQTeachers();
    }
  }
}

class QTeacher {
  final int tid;
  final String tcode;
  final String tpassword;
  final String temail;
  final String tusername;

  QTeacher(
    this.tid,
    this.tcode,
    this.tusername,
    this.tpassword,
    this.temail,
  );
}
