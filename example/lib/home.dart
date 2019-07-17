import 'package:flutter/material.dart';
import 'package:project_final/about.dart';
import 'package:project_final/attendence1.dart';
import 'package:project_final/login.dart';
import 'package:http/http.dart' as http;
import 'package:project_final/option.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.username, this.email, this.tcodes}) : super (key : key);
  final String username,email,tcodes;
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> student = new List<String>();

  Future<List<Subject>> _getSubjects() async{
    var data = await http.get("https://sutclass.herokuapp.com/QSubjectbyteacher/"+'${widget.tcodes}');
    List<Subject> subjects =[];
    var jsonSub = json.decode(data.body);
    for(var i in jsonSub){ 
      Subject subject = Subject(i["subjectCode"], i["subjectId"], i["subjectName"], i["subjectTerm"], i["modeGrade"]);
      subjects.add(subject);
    }
    for(int i=0 ; i<jsonSub.length ; i++){
      student.add(jsonSub[i].toString().split("stdno: ")[1].split(",")[0]);
    } 
    return subjects;
  }

  
  Future<Null> refreshList() async{
    
    await Future.delayed(Duration(seconds: 2));

    setState(() {
     child:Container(
        child: FutureBuilder(
          future: _getSubjects(),
          builder: (BuildContext context , AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context,int index){
                  return Container(
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 150.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/Picture/1.jfif')
                              )
                            ),
                            child: ListTile( 
                              title: Text(
                                snapshot.data[index].subjectId.toString(),
                                style: new TextStyle(
                                  height: 2.0,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,),
                              subtitle: Text(
                                snapshot.data[index].subjectName,
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                                textAlign: TextAlign.center,),
                            ),
                          ),
                          ButtonTheme.bar(
                            child:ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('Option'),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    var optionRounte = new MaterialPageRoute(
                                      builder: (BuildContext context) => OptionPage(
                                        subjectCode: snapshot.data[index].subjectCode,
                                        subjectName: snapshot.data[index].subjectName,
                                        subjectId: snapshot.data[index].subjectId.toString(),
                                        student: student[index].toString(),
                                        tcode: widget.tcodes,
                                      ),
                                    );
                                    Navigator.of(context).push(optionRounte);
                                  },
                                ),
                                FlatButton(
                                  child: const Text('เช็คชื่อเข้าเรียน'),
                                  textColor: Colors.black,
                                  onPressed: () {
                                    var optionRounte = new MaterialPageRoute(
                                      builder: (BuildContext context) => Attendence1(
                                        subjectName: snapshot.data[index].subjectName,
                                        subjectCode: snapshot.data[index].subjectCode,
                                        subjectId: snapshot.data[index].subjectId.toString(),
                                        student: student[index].toString(),
                                        tcode: widget.tcodes,
                                      ),
                                    );
                                    Navigator.of(context).push(optionRounte);
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );            
                },
              );
            }
          },
        ),
      ); 
    });

    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: new AppBar(
        title: new Text('Home',textAlign: TextAlign.center,style: TextStyle(color: Colors.black)),
        
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("${widget.username}"),
              accountEmail: new Text("${widget.email}"),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.brown[300],
                child: new Text("P" ,style: TextStyle(fontSize: 15.0)),
              ),

            ),
            new ListTile(
              title: new Text("Home"),
              trailing: new Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            new ListTile(
              title: new Text("About us"),
              trailing: new Icon(Icons.account_box),
              onTap: () {
                var aboutRoute = new MaterialPageRoute(
                  builder: (BuildContext context) => AboutPage(
                    username: widget.username,
                    email: widget.email,
                    tcodes: widget.tcodes,
                  ),
                );
                Navigator.of(context).pushReplacement(aboutRoute);
              }
            ),
            new Divider(),
            new ListTile(
              title: new Text("Sign Out"),
              trailing: new Icon(Icons.close),
              onTap: () => Pong()
                          )
                        ],
                      ),
                    ),
                    body: RefreshIndicator(
                    child:Container(
                      child: FutureBuilder(
                        future: _getSubjects(),
                        builder: (BuildContext context , AsyncSnapshot snapshot){
                          if(snapshot.data == null){
                            return Container(
                              child: Center(
                                child: Text("Loading..."),
                              ),
                            );
                          }else{
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context,int index){
                                return Container(
                                  child: Card(
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage('assets/Picture/1.jfif')
                                            )
                                          ),
                                          child: ListTile( 
                                            title: Text(
                                              snapshot.data[index].subjectId.toString(),
                                              style: new TextStyle(
                                                height: 2.0,
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,),
                                            subtitle: Text(
                                              snapshot.data[index].subjectName,
                                              style: new TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                              textAlign: TextAlign.center,),
                                          ),
                                        ),
                                        ButtonTheme.bar(
                                          child:ButtonBar(
                                            children: <Widget>[
                                              FlatButton(
                                                child: const Text('Option'),
                                                textColor: Colors.black,
                                                onPressed: () {
                                                  var optionRounte = new MaterialPageRoute(
                                                    builder: (BuildContext context) => OptionPage(
                                                      subjectCode: snapshot.data[index].subjectCode,
                                                      subjectName: snapshot.data[index].subjectName,
                                                      subjectId: snapshot.data[index].subjectId.toString(),
                                                      student: student[index],
                                                      tcode: widget.tcodes,
                                                    ),
                                                  );
                                                  Navigator.of(context).push(optionRounte);
                                                },
                                              ),
                                              FlatButton(
                                                child: const Text('เช็คชื่อเข้าเรียน'),
                                                textColor: Colors.black,
                                                onPressed: () {
                                                  var optionRounte = new MaterialPageRoute(
                                                    builder: (BuildContext context) => Attendence1(
                                                      subjectName: snapshot.data[index].subjectName,
                                                      subjectCode: snapshot.data[index].subjectCode,
                                                      subjectId: snapshot.data[index].subjectId.toString(),
                                                      student: student[index],
                                                      tcode: widget.tcodes,
                                                    ),
                                                  );
                                                  Navigator.of(context).push(optionRounte);
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );            
                              },
                            );
                          }
                        },
                      ),
                    ),
                    onRefresh: refreshList,
                    ),
                  );
                }
              
                Pong() async{
                  final prefs = await SharedPreferences.getInstance();
                      prefs.remove('tcode');
                      prefs.remove('username');
                      prefs.remove('email');
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => LoginPage()));
                }                   
}


class Subject{
  final String subjectCode;
  final int subjectId;
  final String subjectName;
  final String subjectTerm;
  final String modeGrade;

  Subject(this.subjectCode,this.subjectId,this.subjectName,this.subjectTerm,this.modeGrade);
}