class TransactionInfo {
  //est refer to estimate price
  String coinSymbol;
  String to;
  String amount;
  String gasFee;
  String gasPrice;
  String gasPriceUnit;
  String maxGas;
  String totalAmt;
  String estAmountPrice;
  String estGasFeePrice;
  String estTotalPrice;

  TransactionInfo({
    this.coinSymbol,
    this.to,
    this.amount,
    this.gasFee,
    this.gasPrice,
    this.gasPriceUnit,
    this.maxGas,
    this.totalAmt,
    this.estAmountPrice,
    this.estGasFeePrice,
    this.estTotalPrice,
  });
}
