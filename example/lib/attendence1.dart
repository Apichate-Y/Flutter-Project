import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_final/editattendence.dart';

import 'package:project_final/attendence.dart';

class Attendence1 extends StatefulWidget {
  Attendence1(
      {Key key,
      this.subjectName,
      this.subjectId,
      this.subjectCode,
      this.student,
      this.tcode})
      : super(key: key);
  final String subjectName, subjectId, subjectCode, tcode;
  final student;

  @override
  _Attendence1State createState() => _Attendence1State();
}

class _Attendence1State extends State<Attendence1> {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  int qColumns;
  List<String>stdId = new List<String>();

   void snackbar(String str) {
    scaffoldState.currentState.showSnackBar(new SnackBar(
      content: new Text(str, style: new TextStyle(fontSize: 20.0)),
    ));
  }

  Future<String> _getcolumn() async {
    snackbar("กรุณารอสักครู่...");
    var data = await http.get("https://sutclass.herokuapp.com/QColumn/" +
        widget.subjectCode +
        "/Attendence");
    var jsonData = json.decode(data.body);

    var data2 = await http.get("https://sutclass.herokuapp.com/QScoreNoArray/"+widget.subjectCode+"/"+'Attendence');
    var jsonSub1 = json.decode(data2.body);
    print(jsonSub1);
    for(int i=0 ; i<jsonSub1.length ; i++){
      stdId.add(jsonSub1[i].toString().split("student: {stdCode: ")[1].split(",")[0]);
    }

    var optionRounte = new MaterialPageRoute(
      builder: (BuildContext context) => AttendencePage(
            subjectId: widget.subjectId,
            subjectName: widget.subjectName,
            subjectCode: widget.subjectCode,
            qColumn: jsonData.toString(),
            stdId: stdId,
          ),
    );
    Navigator.of(context).push(optionRounte);
  }

  dialogEdit() async {
    var optionRounte = new MaterialPageRoute(
      builder: (BuildContext context) => EditAttendencePage(
            qColumns: qColumns,
            subjectCode: widget.subjectCode,
            tcode: widget.tcode,
            stdId: stdId,
          ),
    );
    Navigator.of(context).pushReplacement(optionRounte);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: new AppBar(
        title: new Text('Attendance', textAlign: TextAlign.center),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            new ListTile(
              title: Text('${widget.subjectId}',
                  style: TextStyle(fontSize: 30.0),
                  textAlign: TextAlign.center),
            ),
            new ListTile(
              title: Text('${widget.subjectName}',
                  style: TextStyle(fontSize: 10.0)),
              trailing: Text('จำนวนนักศึกษา ${widget.student} คน',
                  style: TextStyle(fontSize: 10.0)),
            ),
            new Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  width: 200.0,
                  child: new RaisedButton(
                      child: Text('NEW ATTENDANCE',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center),
                      onPressed: () => QColumns(),
                      color: Colors.blue),
                ),
              ],
            ),
            new SizedBox(
              width: 200.0,
              child: new RaisedButton(
                child: Text('แก้ไขเวลา/คะแนนเข้าเรียน',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center),
                onPressed: () {
                  _getcolumn().whenComplete(dialogEdit);
                },
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  QColumns() async {
    _getcolumn();
  }
}
