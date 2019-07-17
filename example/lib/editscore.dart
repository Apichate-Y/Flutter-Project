import 'package:flutter/material.dart';
import 'package:fzxing/fzxing.dart';
import 'package:project_final/series.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_final/series2.dart';
class EditScorePage extends StatefulWidget {
  EditScorePage({Key key,this.name,this.qColumns,this.subjectCode,this.tcode,this.limit,this.stdId}) : super (key : key);
  final String name,subjectCode,tcode;
  final int qColumns;
  final List<String> limit,stdId;
  

  @override
  _EditScorePageState createState() => _EditScorePageState();
}

class _EditScorePageState extends State<EditScorePage> {
  TextEditingController WirteScoreController = new TextEditingController();
  
  createAlertDialog1(int columns,String limit){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("เลือกรูปแบบสแกน"),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('สแกนเป็นชุด'),
                onPressed: () {
                  var optionRounte = new MaterialPageRoute(
                    builder: (BuildContext context) => SeriesPage2(
                      score: limit,
                      name: widget.name,
                      qColumns: columns,
                      subjectCode: widget.subjectCode,
                      stdId: widget.stdId,
                    ),
                  );
                  Navigator.of(context).pushReplacement(optionRounte);
                },
              ),
              SizedBox(width: 10),
              MaterialButton(
                elevation: 5.0,
                child: Text('สแกนรายบุคคล'),
                onPressed: () {
                  Navigator.pop(context);
                  scan(columns,limit);
                },
              ),
            ],
          )
        ],
      );
    });
  }
  void sendScore(String barcode,int columns, String limit) async {
    int count = 0;
    String barcodes = barcode.toString().split("[")[1].split("]")[0];
    for(int i =0; i<widget.stdId.length ; i++){
      if(barcodes == widget.stdId[i]){
        var optionRounte = new MaterialPageRoute(
          builder: (BuildContext context) => SeriesPage(
            score: limit,
            name: widget.name,
            barcode: barcodes.toString(),
            subjectCode: widget.subjectCode,
            qColumns: columns,
            stdId: widget.stdId, 
          ),
        );
        Navigator.of(context).pushReplacement(optionRounte);
      }else{
        count++;
      }
    }
    if(count == widget.stdId.length){
      createAlertDialog10(barcodes.toString(),columns,limit);
    }
  }
  List<int> temp = new List<int>();
  Future scan(columns,limit) async {
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
          sendScore(barCode,columns,limit);  
        });
      });

    } on PlatformException {
      _barcode.add('Failed to get barcode.');
    }
  }
  createAlertDialog10(String barcode,int columns, String limit){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("$barcode",style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
        content: Text("ไม่มีในระบบ",style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Ok'),
            onPressed: () {
              scan(columns,limit);
            },
          )
        ],
      );
    });
  }
  createAlertDialog(String barcode,int columns,String limit){
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("$barcode",style: TextStyle(fontSize: 13.0),textAlign: TextAlign.center),
        content: Text("มีคะแนนอยู่แล้ว",style: TextStyle(fontSize: 13.0),textAlign: TextAlign.center),
        actions: <Widget>[
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('อัพเดต'),
                onPressed: () {
                  var optionRounte = new MaterialPageRoute(
                    builder: (BuildContext context) => SeriesPage(
                      score: limit,
                      name: widget.name,
                      barcode: barcode.toString(),
                      subjectCode: widget.subjectCode,
                      qColumns: columns,
                      stdId: widget.stdId,
                    ),
                  );
                  Navigator.of(context).pushReplacement(optionRounte);
                },
              ),
              SizedBox(width: 10),
              MaterialButton(
                elevation: 5.0,
                child: Text('ยกเลิก'),
                onPressed: () {
                  scan(columns, limit);
                },
              ),
            ],
          )
        ],
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    var card = new Card(
      margin: EdgeInsets.all(5),
          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return ListView.builder(
                itemCount: widget.qColumns,
                itemBuilder: (context,int index){
                  return Column(
                    children:<Widget> [
                      ListTile(
                        title: Text('ครั้งที่ ${1+index}',style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center),
                        onTap: (){
                          createAlertDialog1(1+index,widget.limit[index]);            
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
    final column = new Column(
      children: <Widget>[
        new ListTile(
          title: Text('เลือกครั้งที่จะแก้ไขคะแนน',textAlign: TextAlign.center,style: TextStyle(fontSize: 20.0)),
        ),
        sizedBox
        
      ],
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text('${widget.name}',textAlign: TextAlign.center),
        
      ),
      body: column,
    );
  }
}