import 'package:web3dart/credentials.dart';

class TransactionInfo {
  //est refer to estimate price
  String coinSymbol;
  String privateKey;
  EthereumAddress receiver;
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
    this.privateKey,
    this.receiver,
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
