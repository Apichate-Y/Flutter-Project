import 'package:flutter/material.dart';
import 'package:project_final/attendence2.dart';

class EditAttendencePage extends StatefulWidget {
  EditAttendencePage(
      {Key key, this.qColumns,this.subjectName,
      this.subjectId,
      this.subjectCode,
      this.student,
      this.tcode,
      this.stdId,})
      : super(key: key);
  final String subjectName, subjectId, subjectCode, tcode;
  final int qColumns;
  final student;
  final List<String>stdId;

  @override
  _EditScorePageState createState() => _EditScorePageState();
}

class _EditScorePageState extends State<EditAttendencePage> {
  @override
  Widget build(BuildContext context) {
    var card = new Card(
      margin: EdgeInsets.all(5),
      child: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ListView.builder(
            itemCount: widget.qColumns,
            itemBuilder: (context, int index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text('ครั้งที่ ${1 + index}',
                        style: TextStyle(fontSize: 20.0),
                        textAlign: TextAlign.center),
                    onTap: () {
                      var optionRounte = new MaterialPageRoute(
                        builder: (BuildContext context) => AttendencePage2(
                              subjectId: widget.subjectId,
                              subjectName: widget.subjectName,
                              subjectCode: widget.subjectCode,
                              stdId: widget.stdId,
                              qColumn: '${1 + index}',
                            ),
                      );
                      Navigator.of(context).push(optionRounte);
                    },
                  ),
                  new Divider(),
                ],
              );
            });
      }),
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
          title: Text('เลือกครั้งที่จะแก้ไขคะแนน',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0)),
        ),
        sizedBox
      ],
    );

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Attendance', textAlign: TextAlign.center),
      ),
      body: column,
    );
  }
}
