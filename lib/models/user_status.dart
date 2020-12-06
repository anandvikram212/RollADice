import 'package:firebase_database/firebase_database.dart';

class UserStatus {

  String _id;
  String _email;
  String _attempts;
  String _total;

  UserStatus(this._id,this._email, this._attempts, this._total);

  String get id => _id;

  String get email => _email;

  String get attempts => _attempts;

  String get total => _total;

  UserStatus.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _email = snapshot.value['email'];
    _attempts = snapshot.value['attempts'];
    _total = snapshot.value['total'];
  }

}