import 'package:roll_a_dice/models/firebase_database_util.dart';
import 'package:roll_a_dice/models/user_status.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:roll_a_dice/screens/play_screen.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => new _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  bool _anchorToBottom = false;
  FirebaseDatabaseUtil databaseUtil;

  @override
  void initState() {
    super.initState();
    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
  }

  @override
  void dispose() {
    databaseUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return PlayScreen();
                    }));
              },
            ),
            backgroundColor: Colors.orangeAccent,
            title: Text("ROLL-A-DICE Leaderboard")),
        body: new FirebaseAnimatedList(
          key: new ValueKey<bool>(_anchorToBottom),
          query: databaseUtil.getUserStatus(),
          reverse: _anchorToBottom,
          sort: _anchorToBottom
              ? (DataSnapshot a, DataSnapshot b) => b.value.compareTo(a.value)
              : null,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return new SizeTransition(
              sizeFactor: animation,
              child: showUsers(snapshot),
            );
          },
        ));
  }

  Widget showUsers(DataSnapshot res) {
    UserStatus userStatus = UserStatus.fromSnapshot(res);

    new Card(
      child: new Container(
          child: new Center(
            child: new Row(
              children: <Widget>[
                new CircleAvatar(
                  radius: 30.0,
                  child: new Text(userStatus.email),
                  backgroundColor: const Color(0xFF20283e),
                ),
                new Expanded(
                  child: new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Score : [ " + userStatus.total + " ]\n",
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.lightGreen),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
    );
  }
}
