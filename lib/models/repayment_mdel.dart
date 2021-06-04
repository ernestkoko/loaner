import 'package:loaner/helpers/write_read_firestore.dart';

///A concrete model class for the repayment plan
class RepaymentModel  {
  String? dueDate;
  String? amount;
  String? paymentPosition;
  String? captureTime;

  RepaymentModel(
      {this.dueDate, this.amount, this.paymentPosition, this.captureTime});

  ///method that returns [RepaymentModel] from a map

  RepaymentModel.fromMap(Map<String, dynamic> map) {
    this.amount = map[_amount] ?? "";
    this.dueDate = map[_dueDate] ?? "";
    this.paymentPosition = map[_paymentPosition] ?? "";
    this.captureTime = map[dataCaptureTime] ?? "";

  }

  ///return a map of the fields
  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[_dueDate] = this.dueDate;
    map[_amount] = this.amount;
    map[_paymentPosition] = this.paymentPosition;
    map[dataCaptureTime] = this.captureTime;
    return map;
  }

  ///getters for the key of the map to ensure safety
  String get _dueDate => "dueDate";

  String get _amount => "amount";

  String get _paymentPosition => "paymentPosition";

  static String get dataCaptureTime => "captureTime";
}
