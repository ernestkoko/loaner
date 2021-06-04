import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loaner/models/monnify_transaction_response_model.dart';
import 'package:monnify_flutter_sdk/monnify_flutter_sdk.dart' as monnify;

import '../models/firebase_user_model.dart';
import '../models/loan_model.dart';
import '../models/repayment_mdel.dart';

///abstract class for authentication
abstract class AuthBase {
  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password);

  Future<FirebaseUser?> signinUserWithEmailAndPassword(
      String email, String password);

  FirebaseUser get currentUser;

  Future<void> updateUserName(String displayName);

  Future<void> takeLoan(String? amountToBorrow, String? numberOfMonths);

  // Future<FirebaseUser> signInWithGoogle();
  Future<void> setRepaymentRecords(
      {String? amount, String? dueDate, String? paymentPosition});

  Future<String?> getName();

  Future<void> setName(String name);

  Future<List<RepaymentModel>> getActiveLoans();

  Future<void> updatePassword({String? oldPassword, String? newPassword});

  Future<MonnifyTransactionResponseDetails> makePayment(
      {double? amount,
      String? customerName,
      String? email,
      String? paymentReference,
      String? paymentDescription});

  Future<void> logout();
}

class FirebaseAuthentication extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  ///[_user] is a private method that returns the present user
  FirebaseUser _user(User? user) {
    return FirebaseUser(
        uid: user!.uid, email: user.email, displayName: user.displayName);
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
  Future<FirebaseUser?> signinUserWithEmailAndPassword(
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

  @override
  Future<void> setName(String name) async {
    try {
      await _userNameReference("name").add(FirebaseUser(name: name));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String?> getName() async {
    try {
      final result = await _userNameReference('name').get();
      final name = result.docs.map((e) => e.data().name!).toList().first;
      return name;
    } catch (error) {
      rethrow;
    }
  }

  /// a private method for writing into and reading from firestore db
  CollectionReference<FirebaseUser> _userNameReference(String collection) {
    try {
      return _firestore
          .collection("loans")
          .doc(this.currentUser.uid)
          .collection(collection)
          .withConverter<FirebaseUser>(
              fromFirestore: (snapshot, _) =>
                  FirebaseUser.fromMap(snapshot.data()!),
              toFirestore: (model, _) => model.toMap());
    } catch (error) {
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
      await _loanCollectionReference("loan").add(LoanModel(
          amount: amountToBorrow!,
          months: numberOfMonths!,
          date: DateTime.now().toIso8601String()));
    } catch (error) {
      rethrow;
    }
  }

  /// a private method for writing into and reading from firestore db
  CollectionReference<LoanModel> _loanCollectionReference(String collection) {
    return _firestore
        .collection("loans")
        .doc(this.currentUser.uid)
        .collection(collection)
        .withConverter<LoanModel>(
            fromFirestore: (snapshot, _) => LoanModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap());
  }

  /// a private method for writing into and reading from firestore db
  CollectionReference<RepaymentModel> _collectionReference(String collection) {
    return _firestore
        .collection("loans")
        .doc(this.currentUser.uid)
        .collection(collection)
        .withConverter<RepaymentModel>(
            fromFirestore: (snapshot, _) =>
                RepaymentModel.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap());
  }

  ///[setRepaymentRecords] is a method that saves the new loan's monthly repayment
  ///details
  @override
  Future<void> setRepaymentRecords(
      {String? amount, String? dueDate, String? paymentPosition}) async {
    try {
      await _collectionReference("repayments").add(RepaymentModel(
          amount: amount!,
          dueDate: dueDate!,
          paymentPosition: paymentPosition!,
          captureTime: DateTime.now().toString()));
    } catch (error) {
      rethrow;
    }
  }

  ///reads the active loans from the data
  @override
  Future<List<RepaymentModel>> getActiveLoans() async {
    try {
      final repayment = await _collectionReference("repayments")
          .orderBy(RepaymentModel.dataCaptureTime)
          .get();
      List<RepaymentModel> _list =
          repayment.docs.map((snapshot) => snapshot.data()).toList();
      //todo
      print("List: ${_list.map((e) => e.captureTime)}");
      return _list;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<MonnifyTransactionResponseDetails> makePayment(
      {double? amount,
      String? customerName,
      String? email,
      String? paymentReference,
      String? paymentDescription}) async {
    try {
      final result = await monnify.MonnifyFlutterSdk.initializePayment(
          monnify.Transaction(amount!, "NGN", customerName!, email!,
              paymentReference!, paymentDescription!));

      ///return a concrete class that models that result
      return MonnifyTransactionResponseDetails(
          paymentReference: result.transactionReference,
          amountPaid: result.amountPaid,
          amountPayable: result.amountPayable,
          paymentDate: result.paymentDate,
          paymentMethod: result.paymentMethod,
          transactionReference: result.transactionReference,
          transactionStatus: result.transactionStatus);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(
      {String? oldPassword, String? newPassword}) async {
    final _user = this.currentUser;
    try {
      final result =
          await signinUserWithEmailAndPassword(_user.email!, oldPassword!);

      ///change the password only iff the user sign-in is successful
      if (result != null) {
        await _firebaseAuth.currentUser!.updatePassword(newPassword!);
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserName(String displayName) async {
    try {
      _firebaseAuth.currentUser!.updateProfile(displayName: displayName);
    } catch (error) {
      rethrow;
    }
  }
}
