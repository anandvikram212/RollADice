import 'dart:async';

import 'package:roll_a_dice/models/user_status.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseUtil {
  DatabaseReference _counterRef;
  DatabaseReference _userStatusRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  FirebaseDatabase database = new FirebaseDatabase();
  int _counter;
  DatabaseError error;

  static final FirebaseDatabaseUtil _instance =
      new FirebaseDatabaseUtil.internal();

  FirebaseDatabaseUtil.internal();

  factory FirebaseDatabaseUtil() {
    return _instance;
  }

  void initState() {
    // Demonstrates configuring to the database using a file
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly

    _userStatusRef = database.reference().child('user_status');
    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(int.parse("1000000"));
    _counterRef.keepSynced(true);

    _counterSubscription = _counterRef.onValue.listen((Event event) {
      error = null;
      _counter = event.snapshot.value ?? 0;
    }, onError: (Object o) {
      error = o;
    });
  }

  DatabaseError getError() {
    return error;
  }

  int getCounter() {
    return _counter;
  }

  DatabaseReference getUserStatus() {
    return _userStatusRef;
  }

  addUserStatus(UserStatus userStatus) async {
    final TransactionResult transactionResult =
        await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });

    if (transactionResult.committed) {
      _userStatusRef.push().set(<String, String>{
        "email": "" + userStatus.email,
        "attempts": "" + userStatus.attempts,
        "total": "" + userStatus.total
      }).then((_) {
        print('Transaction  committed.');
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
  }

  void updateUserStatus(UserStatus userStatus) async {
    await _userStatusRef.child(userStatus.id).update({
      "email": "" + userStatus.email,
      "attempts": "" + userStatus.attempts,
      "total": "" + userStatus.total,
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void dispose() {
    if(_messagesSubscription != null) _messagesSubscription.cancel();
    if(_counterSubscription != null) _counterSubscription.cancel();
  }
}