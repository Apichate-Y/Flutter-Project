import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/alltype.dart';
import 'dart:convert';

import 'package:project_final/attendence1.dart';

class OptionPage extends StatefulWidget {
  final String subjectCode,subjectId,subjectName,tcode;
  final String student;
  OptionPage({Key key,this.subjectCode,this.subjectId,this.subjectName,this.student,this.tcode}) : super(key: key);

  
  @override
  _OptionPageState createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {

  Future<List<String>> _getQTypename() async{
    var data = await http.get('https://sutclass.herokuapp.com/QTypename/'+'${widget.subjectCode}');
    var jsonData = json.decode(data.body);
    List<String> qTypename = [];
    for(int i=0 ; i< jsonData.length ; i++){
      qTypename.add(jsonData[i]);
    }
    return qTypename;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Option',textAlign: TextAlign.center),
        
      ),
      body: Container(
        child: FutureBuilder(
          future: _getQTypename(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(snapshot.data[index].toString()),
                    onTap: () {
                      if(snapshot.data[index].toString() == "Attendence" || snapshot.data[index].toString() == "attendence"){
                        Navigator.push(
                          context, new MaterialPageRoute(
                            builder: (context) => Attendence1(
                              subjectId: widget.subjectId,
                              subjectName: widget.subjectName,
                              subjectCode: widget.subjectCode,
                              student: widget.student,
                              tcode: widget.tcode,
                            )
                          )
                        );
                      }else{
                        Navigator.push(
                          context, new MaterialPageRoute(
                            builder: (context) => AlltypePage(
                              subjectId: widget.subjectId,
                              subjectName: widget.subjectName,
                              name: snapshot.data[index].toString(),
                              subjectCode:widget.subjectCode,
                              student: widget.student,
                              tcode: widget.tcode,
                            )
                          )
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}