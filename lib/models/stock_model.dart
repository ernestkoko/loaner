///A model class for the stock
class StockModel {
  String? symbol;
  String ? totalQuantity;
  String ? equityValue;
  String ? pricePerShare;

//class constructor
  StockModel({
    this.symbol,
    this.totalQuantity,
    this.equityValue,
    this.pricePerShare,
  });

  ///a method the returns [StockModel] when a [json] of Map type is passed to it
  StockModel.fromJson(Map<String, dynamic> json) {

    this.symbol = json['symbol'].toString();
    this.totalQuantity = json['totalQuantity'].toString();
    this.equityValue = json['equityValue'].toString();
    this.pricePerShare = json['pricePerShare'].toString();
    //TODO delete later
    print('FromJson called');
  }
}
