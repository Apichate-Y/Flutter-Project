import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fzxing/fzxing.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';
//รายบุคคล
class SeriesPage extends StatefulWidget {
  SeriesPage({Key key, this.score,this.name,this.qColumns,this.subjectCode,this.barcode,this.tcode,this.stdId}) : super (key : key);
  final String score,name,barcode,subjectCode,tcode;
  final int qColumns;
  final List<String> stdId;
  
  @override
  _SeriesPageState createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  TextEditingController WirteScoreController = new TextEditingController();
  static final Post_URL2 = 'https://sutclass.herokuapp.com/UpdateScore/';
  final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();
  String barCode = '';

  void postScore(newScore) async{
    String barcode = widget.barcode;
    if(barCode == ''){
      print(barcode);
    }else{
      barcode = barCode.toString();
    }
    snackbar("กำลังบันทึกคะแนน ${barcode.toString()}");
    Post2 newPost = await createPost2(Post_URL2 +widget.subjectCode +'/'+widget.name +'/'+barcode.toString()+'/${widget.qColumns}/' + newScore.toString()).whenComplete(scan);
    //Post2 newPost2 = await createPost2(Post_URL2 + widget.subjectCode +'/Attendence/' +barcode.toString() +'/${qColumns + 1}/' +score);

  }
  checkScore(){
    String barcd ;
    for(int i =0; i<widget.stdId.length ; i++){
      if(barCode == widget.stdId[i]){
        barcd = barCode;
        break;
      }
    }
      if(barcd != barCode){
        createAlertDialog10(barCode);
      }
  }
  Future scan() async {
    List<String> _barcode;
    
    try {
      Fzxing.scan(isBeep: true, isContinuous: false).then((barcodeResult) {
        setState(() {
          _barcode = barcodeResult;
          for (int i = 0; i < _barcode.length; i++) {
            barCode = _barcode[i];
            checkScore();
          }
          
        });
      });
    } on PlatformException {
      _barcode.add('Failed to get barcode.');
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
  // createAlertDialog(String barcode){
  //   return showDialog(context: context,builder: (context){
  //     return AlertDialog(
  //       title: Text("$barcode",style: TextStyle(fontSize: 13.0),textAlign: TextAlign.center),
  //       content: Text("มีคะแนนอยู่แล้ว",style: TextStyle(fontSize: 13.0),textAlign: TextAlign.center),
  //       actions: <Widget>[
          
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             MaterialButton(
  //               elevation: 5.0,
  //               child: Text('อัพเดต'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             SizedBox(width: 10),
  //             MaterialButton(
  //               elevation: 5.0,
  //               child: Text('ยกเลิก'),
  //               onPressed: () {
  //                 scan();
  //               },
  //             ),
  //           ],
  //         )
  //       ],
  //     );
  //   });
  // }
  void snackbar(String str) {
    scaffoldState.currentState.showSnackBar(new SnackBar(
      content: new Text(str, style: new TextStyle(fontSize: 20.0)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    int scanS = int.parse(widget.score);

    var card = new Card(
      margin: EdgeInsets.all(5),
          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return ListView.builder(
                itemCount: scanS,
                itemBuilder: (context,int index){
                  return Column(
                    children:<Widget> [
                      ListTile(
                        title: Text('${scanS-index}',style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
                        onTap: (){
                          postScore('${scanS-index}');
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
              
              postScore(WirteScoreController.text);
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