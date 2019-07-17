import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fzxing/fzxing.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';

class SeriesPage1 extends StatefulWidget {
  SeriesPage1({Key key, this.score,this.name,this.qColumns,this.subjectCode,this.tcode,this.stdId}) : super (key : key);
  final String score,name,subjectCode,tcode;
  final int qColumns;
  final List<String> stdId;

  @override
  _SeriesPage1State createState() => _SeriesPage1State();
}

class _SeriesPage1State extends State<SeriesPage1> {
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  TextEditingController WirteScoreController = new TextEditingController();
  static final Post_URL = 'https://sutclass.herokuapp.com/AddTime/';
  static final Post_URL2 = 'https://sutclass.herokuapp.com/UpdateScore/';
  String newScores = '';
  Future scan() async {
    String barCode;
    List<String> _barcode;
    try {
      Fzxing.scan(isBeep: true, isContinuous: false).then((barcodeResult) {
        setState(() {
          _barcode = barcodeResult;
          for (int i = 0; i < _barcode.length; i++) {
            barCode = _barcode[i];
            postScore(barCode);
          }
        });
      });
    } on PlatformException {
      _barcode.add('Failed to get barcode.');
    }
  }
  void postScore(String barcode) async {
    int count = 0;
    for(int i =0; i<widget.stdId.length ; i++){
      if(barcode == widget.stdId[i]){
        snackbar("กำลังบันทึกคะแนน ${barcode}");
        Post2 newPost2 = await createPost2(Post_URL2 + widget.subjectCode +'/'+widget.name+'/' +barcode.toString() +'/${widget.qColumns + 1}/' +newScores).whenComplete(scan);
      }else{
        count++;
      }
    }
    if(count == widget.stdId.length){
      createAlertDialog10(barcode);
    }
  }
  createAlertDialog10(String barcode){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("$barcode",style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
        content: Text("ไม่มีในระบบ",style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('ok'),
            onPressed: () {
              scan();
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }
  void postColumn(newScore) async{
    newScores = newScore.toString();
    snackbar("กำลังสร้าง Column ที่ ${widget.qColumns+1}");
    Post newPost = await createPost(Post_URL + widget.subjectCode + '/'+widget.name+'/${widget.qColumns + 1}/' + widget.score).whenComplete(scan);
  }

  void snackbar(String str) {
    scaffoldState.currentState.showSnackBar(new SnackBar(
      content: new Text(str, style: new TextStyle(fontSize: 20.0)),
    ));
  }

  

  @override
  Widget build(BuildContext context) {
    int scanS = int.parse(widget.score);

    var card = new Card(
      margin: EdgeInsets.all(10),
      child: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return ListView.builder(
            itemCount: scanS,
            itemBuilder: (context,int index){
              return Column(
                children:<Widget> [
                  ListTile(
                    title: Text('${scanS-index}',style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
                    dense: true,
                    onTap: (){
                      postColumn('${scanS-index}');
                    },
                  ),
                  new Divider(),
                ],
              );
            }
          );
        }
      ),
    );
    final sizedBox = new SizedBox(
      height: 400.0,
      child: new Container(
        child: card,
      ),
    );
    final wirte = new Card(
      child: Column(
        children: <Widget>[
          new InkWell(
            child: Text('กำหนดคะแนนเอง',style: TextStyle(color: Colors.red,fontSize: 15.0)),
            
          ),
          new Divider(color: Colors.red,),
          new TextField(
           controller: WirteScoreController,
           decoration: InputDecoration(labelText: 'ไม่เกิน ${widget.score}'),
          ),
          new RaisedButton(
            color: Colors.blue,
            child: Text('บันทึก'),
            onPressed: () {
              postColumn(WirteScoreController.text);
            },
          )
        ],
      ),
    );
    final column = new Column(
      children: <Widget>[
        new ListTile(
          title: Text('เลือกคะแนนจาก Score List\nหรือกำหนดคะแนนด้วยตนเอง',textAlign: TextAlign.center,),
        ),
        sizedBox,
        wirte
      ],
    );
    return Scaffold(
      key: scaffoldState,
      appBar: new AppBar(
        title: new Text('${widget.name}',textAlign: TextAlign.center),
        
      ),
      body: column,
    );
  }
}

//POST
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
class Post2 {
  final String newScore;
  Post2({this.newScore});
  factory Post2.fromJson(Map<String, dynamic> json) {
    return Post2(
      newScore: json['newScore'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["newScore"] = newScore;
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