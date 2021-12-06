import 'package:authentification/Start.dart';
import 'package:authentification/todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:authentification/Start.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'create_task.dart';
import 'widget/button_widget.dart';
import 'widget/date_picker_widget.dart';
import 'widget/date_range_picker_widget.dart';
import 'widget/datetime_picker_widget.dart';
import 'widget/time_picker_widget.dart';



import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';
//import 'package:syncfusion_flutter_calendar/calendar.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(

      child: !isloggedin
          ? CircularProgressIndicator()
          : Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  height: 400,
                  child: Image(
                    image: AssetImage("images/login.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),

                Container(
                  child: Text(
                    "Hello ${user!.displayName} ",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30.0),



                SizedBox(height: 30.0),
                RaisedButton(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  onPressed:() {
                    Navigator.push(
                      context,
                        MaterialPageRoute(builder: (context)=>MyApp1()),
                    );
                  },
                  child: Text('Tasks',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),


                RaisedButton(
                  padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  onPressed: signOut,
                  child: Text('Signout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                )
              ],
            ),
    ));
  }
}
