class MonnifyTransactionResponseDetails {
  String? paymentDate;
  double? amountPayable;
  double? amountPaid;
  String? paymentMethod;
  String? transactionStatus;
  String? transactionReference;
  String? paymentReference;

  MonnifyTransactionResponseDetails(
      {this.paymentReference,
      this.amountPaid,
      this.amountPayable,
      this.paymentDate,
      this.paymentMethod,
      this.transactionReference,
      this.transactionStatus});
}
