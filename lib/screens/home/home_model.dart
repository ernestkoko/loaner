import 'package:flutter/foundation.dart';
import 'package:loaner/helpers/stocks.dart';
import 'package:loaner/models/stock_model.dart';
import 'package:loaner/repositories/firebase_repository.dart';

import '../../models/firebase_user_model.dart';

class HomeScreenModel with ChangeNotifier {
  AuthBase? auth;

  HomeScreenModel({this.auth});

  ///private list of stocks
  List<StockModel> _myList = [];

  ///getter for the appBar title
  String get titleLabel => "Loaner";

  String get snapShotErrorLabel => 'Some errors occurred';

  String get dataIsEmptyLabel => 'Nothing to display';

  String get quantityLabel => 'Qty: ';

  String get pricePerShareLabel => "PPS: \$";

  String get equityValueLabel => "Value: \$";

  String get portFolioLabel => "Portfolio Value: \$";

  String get settingsLabel => 'Settings';

  String get activeLoanLabel => "Active loan";

  String get logoutLabel => "Logout";

  String get homeLabel => 'Home';

  ///get the total value of the port folio
  String get portFolioValue {
    //declare a variable of type double and initialise it to 0
    double myVal = 0;
    //loop through the list of Stocks [myList] and add the value of each equity value to the
    //variable [myVal]
    for (int i = 0; i < _myList.length; i++) {
      myVal += double.tryParse(_myList[i].equityValue!)!;
    }
    //return [myVal] after converting it to string
    return myVal.toString();
  }

  ///get the current user
  FirebaseUser? get _user => auth!.currentUser;

  ///get the user email
  String? get userEmail => _user!.email;

  ///get the user id (uid)
  String? get userId => _user!.uid;

  ///log out the user
  Future<void> logout() async {
    try {
      await auth!.logout();
    } catch (error) {
      rethrow;
    }
  }

  ///[getStocks] fetches the available stocks and returns a list of the concrete
  ///[StockModel] class to be used in the home screen.
  ///I am just using [async] and [await] to mock the real world scenario
  Future<List<StockModel>> getStocks() async {
    //set the value of the list to empty
    _myList = [];
    try {
      final _stocks = stocks;
      Map<String, dynamic> map;
      for (map in _stocks) {
        _myList.add(StockModel.fromJson(map));
      }

      return await Future.value(_myList);
    } catch (error) {
      rethrow;
    }
  }

  ///get the active loan and the prorated time to pay back
  Future<bool> getActiveLoan() async {
    try {
     final result = await auth!.getActiveLoans();
     if(result.isEmpty){
       return await Future.value(false);
     }
      return await Future.value(true);
    } catch (error) {
      rethrow;
    }
  }
}
