import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:loaner/models/monnify_transaction_response_model.dart';
import 'package:loaner/models/repayment_mdel.dart';
import 'package:loaner/repositories/firebase_repository.dart';

class ActiveLoanScreenModel extends ChangeNotifier {
  AuthBase? auth;
  bool isLoading = false;

  ActiveLoanScreenModel({this.auth, this.isLoading = false});

  ///get the email of the current user
  String? get email => auth!.currentUser.email;

  Future<List<RepaymentModel>> getActiveLoan() async {
    try {
      final result = await auth!.getActiveLoans();

      return result;
    } catch (error) {
      rethrow;
    }
  }

  ///a method that makes payment
  Future<MonnifyTransactionResponseDetails> pay(
      {String? amount,
      String? paymentReference,
      String? paymentDescription}) async {

    try {
      ///parse the String to double
      final _amount = double.tryParse(amount!)!.roundToDouble();
      //get the reference string
      final _reference = getRandomString(12);
      //get the name from firestore
      final _name =  auth!.currentUser.displayName;
      return await auth!.makePayment(
          amount: _amount!,
          customerName: _name,
          email: email,
          paymentReference: _reference,
          paymentDescription: 'Loan');
    } catch (error) {
      rethrow;
    } finally {

    }
  }

  ///generate random strings of a given [length]
  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  _copyWith({bool? isLoading}) {
    this.isLoading = isLoading ?? this.isLoading;

    notifyListeners();
  }
}
