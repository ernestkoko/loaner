///concrete class for Loan to ensure type safety
class LoanModel {
  String? amount;
  String? months;
  String? date = DateTime.now().toString();

  ///set the default values to 0(zero)
  LoanModel({this.amount = "0", this.months = '0', this.date});

  ///method that returns [LoanModel] when given a [map]
  LoanModel.fromMap(Map<String, dynamic> map) {
    this.months = map[_months];
    this.amount = map[_amount];
  }

  ///method that converts the fields to map and returns the map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> _map = {};
    _map[_amount] = this.amount!;
    _map[_months] = this.months!;
    _map[_date] = this.date;
    return _map;
  }

  ///use the getters for the keys of the maps to ensure safety in spellings
  String get _months => 'months';

  String get _amount => 'amount';

  String get _date => "date";
}
