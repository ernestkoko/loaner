import 'package:flutter/material.dart';

class CustomCardView extends StatelessWidget {
  String? symbol;
  String? quantity;
  String? pricePerShare;
  String? equityValue;

  CustomCardView(
      {this.symbol = '',
      this.quantity = '',
      this.pricePerShare = '',
      this.equityValue = ''})
      : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Text(symbol!),
        title: Text(quantity!),
        subtitle: Text(pricePerShare!),
        trailing: Text(equityValue!),

      ),
    );
  }
}
