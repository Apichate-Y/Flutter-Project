import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:fzxing/fzxing.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  debugPaintSizeEnabled = false;
}

class AttendencePage extends StatefulWidget {
  final Future<Post> post;

  AttendencePage(
      {Key key,
      this.subjectName,
      this.subjectId,
      this.subjectCode,
      this.qColumn,
      this.post,
      this.stdId})

      : super(key: key);
  final String subjectName, subjectId, subjectCode, qColumn;
  final List<String>stdId;

  @override
  _AttendencePageState createState() => _AttendencePageState();
}

class _AttendencePageState extends State<AttendencePage> {

  Future<String> _getcolumn() async {
    var data = await http.get("https://sutclass.herokuapp.com/QColumn/" + widget.subjectCode +"/Attendence");
    var jsonData = json.decode(data.body);
    print(jsonData.hashCode);
  }

  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();


  static final Post_URL = 'https://sutclass.herokuapp.com/AddTime/';
  static final Post_URL2 = 'https://sutclass.herokuapp.com/UpdateScore/';


  TextEditingController limitScoreController = new TextEditingController();
  TextEditingController realScoreController = new TextEditingController();
  TextEditingController missScoreController = new TextEditingController();

  TimeOfDay _times = new TimeOfDay.now();
  String stdCode = '';
  String time = '';
  String times = '';
  int times1, times2, time1, time2, stimes, stime;
  String score = '';

  Future<Null> _onTimeScore(BuildContext context) async {
    TimeOfDay _time = new TimeOfDay.now();

    String limit = limitScoreController.text;
    String real = realScoreController.text;
    if(real == ''){
      real = '1';
    }
    if(limit == ''){
      limit = '0.5';
    }


    time = '${_time.hour}:${_time.minute}';
    time1 = _time.hour * 60;
    time2 = _time.minute;
    stime = time1 + time2;
    print('Time OnDate: ' + time);

    if (stime > stimes) {
      score = limit;
      print(score);
    } else if (stime < stimes) {
      score = real;
      print(score);
    } else {
      score = real;
      print(score);
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _times,
    );
    if (picked != null && picked != _times) {
      setState(() {
        _times = picked;
      });
    }

    times = '${_times.hour}:${_times.minute}';
    times1 = _times.hour * 60;
    times2 = _times.minute;
    stimes = times1 + times2;
    print('Time Select: ' + times);
  }

  Future scan() async {
    String barcode;
    List<String> _barcode;
    try {
      Fzxing.scan(isBeep: true, isContinuous: false).then((barcodeResult) {
        //print("flutter size:" + barcodeResult?.toString());
        setState(() {
          _barcode = barcodeResult;
          for (int i = 0; i < _barcode.length; i++) {
            barcode = _barcode[i];
            _onTimeScore(context);
            postScore(barcode);
          }
          //snackbar("บันทึกแล้ว");
        });
      });
    } on PlatformException {
      _barcode.add('Failed to get barcode.');
    }
    //print('Post NewSring'+ widget.subjectCode+'/Attendence/'+stdCode+'/${qColumns+1}/'+score);
  }

  void snackbar(String str) {
    scaffoldState.currentState.showSnackBar(new SnackBar(
      content: new Text(str, style: new TextStyle(fontSize: 20.0)),
    ));
  }

 createAlertDialog10(String barcode){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("$barcode",style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
        content: Text("ไม่มีในระบบ",style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
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

  void postScore(String barcode) async {
    int qColumns = int.parse(widget.qColumn);
     int count = 0;

    for(int i =0; i<widget.stdId.length ; i++){
      if(barcode == widget.stdId[i]){
        snackbar("กำลังบันทึกคะแนน ${barcode}");
    Post2 newPost2 = await createPost2(Post_URL2 +
            widget.subjectCode +
            '/Attendence/' +
            barcode.toString() +
            '/${qColumns + 1}/' +
            score)
        .whenComplete(scan);
    print("object : " + barcode.toString());
      }else{
        count++;
      }
    }
    if(count == widget.stdId.length){
      createAlertDialog10(barcode);
    }

    
  }

  void postColumn() async {
    String real = realScoreController.text;
    if(real == ''){
      real = '1';
    }
    int qColumns = int.parse(widget.qColumn);
    snackbar("กำลังสร้าง Column ที่ ${qColumns + 1}");
    Post newPost = await createPost(Post_URL + widget.subjectCode + '/Attendence/${qColumns + 1}/' + real).whenComplete(scan);
  }

  @override
  Widget build(BuildContext context) {
    int qColumns = int.parse(widget.qColumn);

    return Scaffold(
      key: scaffoldState,
      appBar: new AppBar(
        title: new Text('Attendance', textAlign: TextAlign.center)
      ),
      body: Column(
        children: <Widget>[
          new Container(
            height: 25,
          ),
          new Text(
            'จัดการเวลา-คะแนน',
            style: TextStyle(
                fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          new Text(
            'กำหนดเวลาเข้าเรียนสายและคะแนน',
            style: TextStyle(),
          ),
          new Container(
            height: 17,
          ),
          new Align(
            alignment: Alignment(-0.9, 1),
            child: new Text(
              'ค่าเริ่มต้น',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          new Align(
            alignment: Alignment(-0.65, 1),
            child: new Text(
              "- สาย : 0.5 | ตรงเวลา : 1 | ลา/ป่วย : 1",
              style: TextStyle(),
            ),
          ),
          new Align(
            alignment: Alignment(-0.67, 1),
            child: new Text(
              "- เวลาสาย +10 นาทีจากเวลาปัจจุบัน",
              style: TextStyle(),
            ),
          ),
          new Container(
            height: 25,
          ),

          new Align(
            alignment: Alignment(-0.9, 1),
            child: new Text(
              'เวลาเข้าเรียนสาย',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),

          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(
                  'เวลา',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                new FlatButton(
                  child: new Text(
                    _times.toString().split('')[10].toString() +
                        _times.toString().split('')[11].toString() +
                        _times.toString().split('')[12].toString() +
                        _times.toString().split('')[13].toString() +
                        _times.toString().split('')[14].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _selectTime(context);
                  },
                ),
              ],
            ),
          ),

          new Container(
            height: 20,
          ),

          new Align(
            alignment: Alignment(-0.9, 1),
            child: new Text(
              'คะแนน',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),

          new Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: limitScoreController,
                  decoration: InputDecoration(labelText: 'สาย'),
                ),
                new TextField(
                  controller: realScoreController,
                  decoration: InputDecoration(labelText: 'ตรง'),
                ),
                new TextField(
                  controller: missScoreController,
                  decoration: InputDecoration(labelText: 'ลาป่วย'),
                ),
                new Container(
                  height: 25,
                ),
              ],
            ),
          ),
          //new Text(newPost2,)

          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () async {
                    Scans();
                  },
                  child: Text(
                    'บันทึก',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void Scans() async {
    postColumn();
  }
}

//Post HTTP
class Post {
  //final String limitScore;
  final String realScore;
  //final String missScore;
  Post({this.realScore});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      //limitScore: json['limitScore'],
      realScore: json['realScore'],
      // missScore: json['missScore'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    //map["limitScore"] = limitScore;
    map["realScore"] = realScore;
    //map["missScore"] = missScore;
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

class Post2 {
  final String score;
  Post2({this.score});
  factory Post2.fromJson(Map<String, dynamic> json) {
    return Post2(
      score: json['realScore'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["realScore"] = score;
    return map;
  }
}

Future<Post2> createPost2(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post2.fromJson(json.decode(response.body));
  });
}
