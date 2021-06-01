import 'package:flutter/foundation.dart';
import 'package:loaner/models/repayment_mdel.dart';
import 'package:loaner/repositories/firebase_repository.dart';

class ActiveLoanScreenModel extends ChangeNotifier {
  AuthBase? auth;

  ActiveLoanScreenModel({this.auth});

  Future<List<RepaymentModel>?> getActiveLoan() async {
    try {
      final result = await auth!.getActiveLoans();

      return result;
    } catch (error) {}
  }
}
