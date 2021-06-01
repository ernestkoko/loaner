import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loaner/models/loan_model.dart';
import 'package:loaner/models/repayment_mdel.dart';

import '../models/firebase_user_model.dart';

///abstract class for authentication
abstract class AuthBase {
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password);

  Future<FirebaseUser> signinUserWithEmailAndPassword(
      String email, String password);

  FirebaseUser get currentUser;

  Future<void> takeLoan(String? amountToBorrow, String? numberOfMonths);

  // Future<FirebaseUser> signInWithGoogle();
  Future<void> setRepaymentRecords(
      {String? amount, String? dueDate, String? paymentPosition});

  Future<List<RepaymentModel>> getActiveLoans();

  Future<void> logout();
}

class FirebaseAuthentication extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  ///[_user] is a private method that returns the present user
  FirebaseUser _user(User? user) {
    return FirebaseUser(uid: user!.uid, email: user.email);
  }

  ///[createUserWithEmailAndPassword] is a method that creates a new  user with email and password
  ///and returns the customer user type [FirebaseUser], [email] is the email
  ///while [password] is the password of the user.
  @override
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      //create  user account with the [email] and [password]

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      //TODO
      ///save the name of the user to firestore

      return _user(credential.user);
    } catch (error) {
      //rethrow any error caught to the calling method
      rethrow;
    }
  }

  ///[signinUserWithEmailAndPassword] is a method that signs in the user with email and password
  ///and returns the customer user type [FirebaseUser], [email] is the email
  ///while [password] is the password of the user.
  @override
  Future<FirebaseUser> signinUserWithEmailAndPassword(
      String email, String password) async {
    try {
      //sign in the user with the email and password and return the custom user
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return _user(credentials.user);
    } catch (error) {
      //rethrow any error caught to the calling method
      rethrow;
    }
  }

  ///currentUser fetches the current user
  @override
  FirebaseUser get currentUser => _user(_firebaseAuth.currentUser);

  ///log the user out
  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      rethrow;
    }
  }

  ///[takeLoan] sends the records [amountToBorrow] and [numberOfMonths] to
  ///firestore
  @override
  Future<void> takeLoan(String? amountToBorrow, String? numberOfMonths) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection("loans").doc(this.currentUser.uid).set(
          LoanModel(amount: amountToBorrow!, months: numberOfMonths!).toMap());
    } catch (error) {
      rethrow;
    }
  }

  ///[setRepaymentRecords] is a method that saves the new loan's monthly repayment
  ///details
  @override
  Future<void> setRepaymentRecords(
      {String? amount, String? dueDate, String? paymentPosition}) async {
    try {
      final fireStore = FirebaseFirestore.instance;

      await fireStore
          .collection("repayments")
          .doc(this.currentUser.uid)
          .collection('repay')
          .doc(paymentPosition!)
          .set(RepaymentModel(
                  dueDate: dueDate,
                  amount: amount,
                  paymentPosition: paymentPosition,
                  captureTime: DateTime.now().toIso8601String())
              .toMap());
    } catch (error) {
      rethrow;
    }
  }

  ///reads the active loans from the data
  @override
  Future<List<RepaymentModel>> getActiveLoans() async {
    try {
      final fireStore = FirebaseFirestore.instance;
      final result = await fireStore
          .collection("repayments")
          .doc(this.currentUser.uid)
          .collection('repay')
          //order the data by the capture time
          .orderBy(RepaymentModel.dataCaptureTime)
          .get();
      List<RepaymentModel> repayment = result.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
              RepaymentModel.fromMap(snapshot.data()))
          .toList();
      return repayment;
    } catch (error) {
      rethrow;
    }
  }

  ///[signInWithGoogle] signs a new user in with their existing google account
  ///and returns a future of the custom [FirebaseUser]
// @override
// Future<FirebaseUser> signInWithGoogle() async {
//   try {
//     //get the google sign-in object
//     final _google = GoogleSignIn();
//     //sign the user in
//     final _googleSignedInAccount = await _google.signIn();
//     //check if the singin account is null. If not null proceed to getting
//     // the authentication, else throw error that the user aborted the process
//     if (_googleSignedInAccount != null) {
//       final _signInAuth = await _googleSignedInAccount.authentication;
//       //check if the auth credentials are not null. if any is null throw an error
//       //else proceed to signing the user in with the credentials
//       if (_signInAuth.accessToken != null && _signInAuth.idToken != null) {
//         final _authResult = await _firebaseAuth.signInWithCredential(
//             GoogleAuthProvider.credential(
//                 idToken: _signInAuth.idToken,
//                 accessToken: _signInAuth.accessToken));
//         return _user(_authResult.user);
//       } else {
//         throw PlatformException(
//           code: "ERROR_MISSING_GOOGLE_AUTH_TOKEN",
//           message: "Missing Google Auth Token",
//         );
//       }
//     } else {
//       throw PlatformException(
//         code: "ERROR_ABORTED_BY_USER",
//         message: "Sign in aborted by user",
//       );
//     }
//   } catch (error) {
//     //rethrow any error caught to the calling method
//     rethrow;
//   }
// }

}
