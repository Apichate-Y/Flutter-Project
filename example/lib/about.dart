import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key, this.username, this.email, this.tcodes})
      : super(key: key);
  final String username, email, tcodes;

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  createAlertDialog(BuildContext context) {
    TextEditingController scoreController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Your Name"),
            content: TextField(
              controller: scoreController,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('OK'),
                onPressed: () {},
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('About Us', textAlign: TextAlign.center),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("${widget.username}"),
              accountEmail: new Text("${widget.email}"),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.red,
                child: new Text(
                  "P",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ),
            new ListTile(
              title: new Text("Home"),
              trailing: new Icon(Icons.home),
              onTap: () {
                var homeRoute = new MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(
                        username: widget.username,
                        email: widget.email,
                        tcodes: widget.tcodes,
                      ),
                );
                Navigator.of(context).pushReplacement(homeRoute);
              },
            ),
            new ListTile(
                title: new Text("About Us"),
                trailing: new Icon(Icons.account_box),
                onTap: () {
                  Navigator.of(context).pop();
                }),
            new Divider(),
            new ListTile(
              title: new Text("Sign Out"),
              trailing: new Icon(Icons.close),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
        ),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          new SizedBox(
            height: 100,
          ),
          new Container(
              width: 150.0,
              height: 150.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/Picture/about.PNG')))),
          new ListTile(
            title: Text('523495', style: TextStyle(fontSize: 25, color: Colors.orange),
                    textAlign: TextAlign.center, ),     
          ),
          new Text('COMPUTER ENGINEERING PROJECT I', style: TextStyle(fontSize: 15, color: Colors.orange), textAlign: TextAlign.center,),
          new Text('SURANAREE UNIVERSITY OF TECHNOLOGY', style: TextStyle(fontSize: 12, color: Colors.black), textAlign: TextAlign.center,),
          
        ],
      )),
    );
  }
}
