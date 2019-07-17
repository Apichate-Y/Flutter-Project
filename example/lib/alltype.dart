import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fzxing/fzxing.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:project_final/editscore.dart';
import 'package:project_final/series.dart';
import 'package:project_final/series1.dart';

class AlltypePage extends StatefulWidget {
  AlltypePage(
      {Key key,
      this.subjectName,
      this.subjectId,
      this.subjectCode,
      this.name,
      this.student,
      this.tcode})
      : super(key: key);
  final String subjectName, subjectId, name, subjectCode, tcode;
  final String student;

  @override
  _AlltypePageState createState() => _AlltypePageState();
}

class _AlltypePageState extends State<AlltypePage> {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

  static final Post_URL = 'https://sutclass.herokuapp.com/AddTime/';
  TextEditingController scoreController = new TextEditingController();
  int qColumns;
  List<String> limits = new List<String>();
  List<String> stdId = new List<String>();
  Future<String> _getcolumn() async {
    snackbar("กรุณารอสักครู่");
    var data = await http.get("https://sutclass.herokuapp.com/QColumn/" +
        widget.subjectCode +
        "/" +
        widget.name);
    var jsonData = json.decode(data.body);
    qColumns = int.parse(jsonData.toString());
    print(qColumns);

    var data2 = await http.get("https://sutclass.herokuapp.com/QScoreNoArray/" +
        widget.subjectCode +
        "/" +
        widget.name);
    var jsonSub1 = json.decode(data2.body);
    print(jsonSub1);
    for (int i = 0; i < jsonSub1.length; i++) {
      stdId.add(
          jsonSub1[i].toString().split("student: {stdCode: ")[1].split(",")[0]);
    }
  }

  dialogEdit() async {
    var data = await http.get("https://sutclass.herokuapp.com/QLimitScore/" +
        widget.subjectCode +
        "/" +
        widget.name);

        
    String limit;
    var jsonSub = json.decode(data.body);
    limit = jsonSub.toString().split("[")[1].split("]")[0];
    limits = limit.split(", ");
    print(limits);

    var optionRounte = new MaterialPageRoute(
      builder: (BuildContext context) => EditScorePage(
            name: widget.name,
            qColumns: qColumns,
            subjectCode: widget.subjectCode,
            tcode: widget.tcode,
            limit: limits,
            stdId: stdId,
          ),
    );
    Navigator.of(context).pushReplacement(optionRounte);
  }

  //เป็นชุด
  createAlertDialog1() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("จัดการคะแนน"),
            content: TextField(
              controller: scoreController,
              decoration:
                  new InputDecoration(labelText: 'คะแนนเริ่มต้นเต็ม 10 คะแนน '),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    elevation: 5.0,
                    child: Text('Save'),
                    onPressed: () {
                      String scoress = scoreController.text;
                      if (scoress == '') {
                        scoress = '10';
                      }
                      var optionRounte = new MaterialPageRoute(
                        builder: (BuildContext context) => SeriesPage1(
                              score: scoress,
                              name: widget.name,
                              qColumns: qColumns,
                              subjectCode: widget.subjectCode,
                              tcode: widget.tcode,
                              stdId: stdId,
                            ),
                      );
                      Navigator.of(context).pushReplacement(optionRounte);
                    },
                  ),
                  SizedBox(width: 10),
                  MaterialButton(
                    elevation: 5.0,
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

//รายบุคคล
  createAlertDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text("จัดการคะแนน")),
            content: TextField(
              controller: scoreController,
              decoration:
                  new InputDecoration(labelText: 'คะแนนเริ่มต้นเต็ม 10 คะแนน '),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    elevation: 5.0,
                    child: Text('Save'),
                    onPressed: () {
                      Navigator.pop(context);
                      postColumn();
                    },
                  ),
                  SizedBox(width: 10),
                  MaterialButton(
                    elevation: 5.0,
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  void snackbar(String str) {
    scaffoldState.currentState.showSnackBar(new SnackBar(
      content: new Text(str, style: new TextStyle(fontSize: 20.0)),
    ));
  }

  void sendScore(String barcode) async {
    String scoress = scoreController.text;
    if (scoress == '') {
      scoress = '10';
    }
    int count = 0;
    String barcodes = barcode.toString().split("[")[1].split("]")[0];
    for (int i = 0; i < stdId.length; i++) {
      if (barcodes == stdId[i]) {
        var optionRounte = new MaterialPageRoute(
          builder: (BuildContext context) => SeriesPage(
                score: scoress,
                name: widget.name,
                barcode: barcodes,
                subjectCode: widget.subjectCode,
                qColumns: qColumns + 1,
                tcode: widget.tcode,
                stdId: stdId,
              ),
        );
        Navigator.of(context).pushReplacement(optionRounte);
      } else {
        count++;
      }
    }
    if (count == stdId.length) {
      createAlertDialog10(barcodes.toString());
    }
    //Post2 newPost2 = await createPost2(Post_URL2 +widget.subjectCode +'/'+widget.name +'/' +barcode.toString() +'/${qColumns + 1}/' +scoreController.text);
  }

  createAlertDialog10(String barcode) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("$barcode",
                style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center),
            content: Text("ไม่มีในระบบ",
                style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Ok'),
                onPressed: () {
                  scan();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void postColumn() async {
    String score = scoreController.text;
    if (score == '') {
      score = '10';
    }
    snackbar("กำลังสร้าง Column ที่ ${qColumns + 1}");

    Post newPost = await createPost(Post_URL +
            widget.subjectCode +
            '/' +
            widget.name +
            '/${qColumns + 1}/' +
            scoreController.text)
        .whenComplete(scan);
  }

  Future scan() async {
    String barCode;
    List<String> _barcode;
    try {
      Fzxing.scan(isBeep: true, isContinuous: false).then((barcodeResult) {
        print("flutter size:" + barcodeResult?.toString());
        setState(() {
          _barcode = barcodeResult;
          for (int i = 0; i < _barcode.length; i++) {
            barCode = _barcode.toString();
          }
          sendScore(barCode);
        });
      });
    } on PlatformException {
      _barcode.add('Failed to get barcode.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: new AppBar(
        title: new Text('${widget.name}', textAlign: TextAlign.center),
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
            new SizedBox(
              width: 200.0,
              child: new RaisedButton(
                child: Text('สแกนเป็นชุด',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                onPressed: () {
                  _getcolumn().whenComplete(createAlertDialog1);
                },
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 12),
            new SizedBox(
              width: 200.0,
              child: new RaisedButton(
                child: Text('สแกนรายบุคคล',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                onPressed: () {
                  _getcolumn().whenComplete(createAlertDialog);
                },
                color: Colors.green,
              ),
            ),
            new SizedBox(
              width: 200.0,
              child: new RaisedButton(
                child: Text('แก้ไขคะแนน',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                onPressed: () {
                  _getcolumn().whenComplete(dialogEdit);
                },
                color: Colors.yellow,
              ),
            ),
            new ListTile(
              title: new Text('${widget.name}', textAlign: TextAlign.center),
            ),
            
          ],
        ),
      ),
    );
  }
}

//Post HTTP
class Post {
  final String scoreController;
  Post({this.scoreController});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      scoreController: json['scoreController'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["scoreController"] = scoreController;
    return map;
  }
}

Future<Post> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
}
