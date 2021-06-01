import 'package:flutter/foundation.dart';
import 'package:loaner/repositories/firebase_repository.dart';

///a model class for the loan screen
class LoanScreenModel with ChangeNotifier {
  final AuthBase? auth;
  double? portFolioValue;
  String? amountToBorrow;
  bool isLoading = false;

  String? numberOfMonths;

  LoanScreenModel(
      {this.auth,
      this.amountToBorrow,
      this.numberOfMonths,
      this.isLoading = false,
      this.portFolioValue = 100000.0});

  String get appBarTitle => "Loan";

  String get numberOfMonthsLabel => "Months to pay back";

  String get takeButtonLabel => "Take";

  String get amountLabel => "Amount";

  ///get the list of the display strings
  List<String> get dropDownLabels =>
      ["Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve"];

  List<String> get _paymentsLabel => [
        "First",
        "Second",
        "Third",
        "Fourth",
        "Fifth",
        "Sixth",
        "Seventh",
        "Eighth",
        "Ninth",
        "Tenth",
        "Eleventh",
        "Twelfth"
      ];

  ///set the selected value
  set selectedMonth(String value) {
    //update the month
    _copyWith(month: value);
  }

  String? get amountErrorMessage {
    if (amountToBorrow != null) {
      if (double.tryParse(amountToBorrow!)! > 0.6 * portFolioValue!) {
        return "You can't borrow more than \$${0.6 * portFolioValue!} which "
            "is 60% of your PortFolio value";
      } else {
        return null;
      }
    } else
      return null;
  }

  ///set amount
  set setAmount(String value) {
    try {
      double? _amount = double.parse(value);
      //update the amount
      _copyWith(amount: _amount.toString());
    } catch (error) {}
  }

  ///borrow
  Future<void> borrow() async {
    //if there is error in amount, stop execution of this method
    if (amountErrorMessage != null || numberOfMonths == null) {
      throw FormatException("The form should be filled properly");
    }

    _copyWith(isLoading: true);
    try {
      ///save the loan amount and number of months it will take to repay
      await auth!.takeLoan(amountToBorrow, numberOfMonths);

      ///get a map of the list of dropdown menu label
      final map = dropDownLabels.asMap();
      double? _numberOfMonths;
      double? _amount;

      ///loop through the map to get the keys and values respectively
      map.forEach((key, value) {
        //check if the value matches the selected number of months
        if (value == numberOfMonths) {
          //add 6 to the number of month and save it to [_numberOfMonths]
          _numberOfMonths = key + 6;
          //divide the amount to borrow by the number of months to get exact amount
          //to be paid monthly and save it to [_amount]
          _amount = double.tryParse(amountToBorrow!)! / _numberOfMonths!;
        }
      });

      //get the present date and time
      final date = DateTime.now();

      ///use a for loop to save each payment details
      for (int i = 0; i < _numberOfMonths!; i++) {
        await auth!.setRepaymentRecords(
            amount: _amount.toString(),
            paymentPosition: _paymentsLabel[i],
            dueDate:
                DateTime(date.year, date.month + i + 1, date.day).toString());
      }
    } catch (error) {
      rethrow;
    } finally {
      _copyWith(isLoading: false);
    }
  }

  ///a private method that can change the values of the fields of this class
  void _copyWith(
      {String? amount,
      String? month,
      bool? isLoading,
      double? portFolioValue = 10000}) {
    this.amountToBorrow = amount ?? this.amountToBorrow;
    this.numberOfMonths = month ?? this.numberOfMonths;
    this.isLoading = isLoading ?? this.isLoading;
    this.portFolioValue = portFolioValue ?? this.portFolioValue;

    ///notify listeners
    notifyListeners();
  }
}
