import 'package:flutter/foundation.dart';

///a custom firebase user class model
class FirebaseUser {
  //the nullable user id
  String? uid;
  String? email;


  FirebaseUser({@required this.uid, this.email});
}
