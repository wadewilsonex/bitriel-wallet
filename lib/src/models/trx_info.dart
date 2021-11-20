import 'package:web3dart/credentials.dart';

class TransactionInfo {
  //est refer to estimate price
  String? hash;
  String? timeStamp;
  String? coinSymbol;
  String? privateKey;
  bool? status;
  EthereumAddress? receiver;
  String? amount;
  String? gasFee;
  String? gasPrice;
  String? gasPriceUnit;
  String? maxGas;
  String? totalAmt;
  String? estAmountPrice;
  String? estGasFeePrice;
  String? estTotalPrice;
  String? scanUrl;
  String? feeNetworkSymbol;

  TransactionInfo({
    this.hash,
    this.status,
    this.coinSymbol,
    this.privateKey,
    this.receiver,
    this.timeStamp,
    this.amount,
    this.gasFee,
    this.gasPrice,
    this.gasPriceUnit,
    this.maxGas,
    this.totalAmt,
    this.estAmountPrice,
    this.estGasFeePrice,
    this.estTotalPrice,
    this.scanUrl,
    this.feeNetworkSymbol,
  });
}
