import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:get_version/get_version.dart';
import 'package:roll_a_dice/models/Session.dart';
import 'package:roll_a_dice/models/firebase_database_util.dart';
import 'package:roll_a_dice/models/user_status.dart';
import 'package:roll_a_dice/screens/leader_board.dart';
import 'package:roll_a_dice/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:toast/toast.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  FirebaseDatabaseUtil databaseUtil;
  String version = "";

  void navigationPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Future<void> initState() async {
    super.initState();
    version = await GetVersion.platformVersion;
    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref.child('user_status').once().then((DataSnapshot snap) async {
      var keys = snap.value.keys;
      var data = snap.value;
      bool userFound = false;
      for (var key in keys) {
        String email = data[key]['email'];
        if(email == Session.email) {
          userFound = true;
          Session.userStatus = new UserStatus(data, email, data[key]['attempts'], data[key]['total']);
        }
      }
      if(!userFound) {
        UserStatus userStatus = new UserStatus("", Session.email, "0", "0");
        databaseUtil.addUserStatus(userStatus);
        Session.userStatus = userStatus;
      }
    });
  }

  @override
  void dispose() {
    databaseUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              color: Colors.green[500],
              textColor: Colors.yellow,
              onPressed: () {
                UserStatus userStatus = Session.userStatus;
                if(int.parse(userStatus.attempts) >=10) {
                  Toast.show("Attempts Over!!", context);
                } else {
                  var random = new Random();
                  var attempts = int.parse(userStatus.attempts) + 1;
                  var total = int.parse(userStatus.total) + random.nextInt(5)+ 1 ;
                  SweetAlert.show(context,
                    confirmButtonColor: Colors.black,
                    subtitle: "AWESOME! Its A "+total.toString());
                  userStatus = new UserStatus(userStatus.id, userStatus.email, attempts.toString(), total.toString());
                  Session.userStatus = userStatus;
                  databaseUtil.updateUserStatus(userStatus);
                }
              },
              child: Text('ROLL THE DICE'),
            ),
            RaisedButton(
              color: Colors.green[500],
              textColor: Colors.yellow,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LeaderBoard()));
              },
              child: Text('GO TO LEADERBOARD'),
            ),
            Text(
              'version : '+version,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
