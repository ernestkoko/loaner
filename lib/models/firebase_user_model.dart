import 'package:flutter/foundation.dart';

///a custom firebase user class model
class FirebaseUser {
  //the nullable user id
  String? uid;
  String? email;
  String? name;
  String? displayName;

  FirebaseUser({@required this.uid, this.email, this.name, this.displayName});

  FirebaseUser.fromMap(Map<String, dynamic> map) {
    try {
      this.uid = map[_uid] ?? "";
      this.email = map[_email] ?? '';
      this.name = map[_name] ?? "";
      this.displayName=map[_displayName]??"";
    } catch (error) {
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      _uid: this.uid,
      _name: this.name,
      _email: this.email,
      this._displayName: this.displayName
    };
  }

  String get _uid => "uidKey";

  String get _name => "userNameKey";

  String get _email => "userEmailKey";

  String get _displayName => "displayNameKey";
}
