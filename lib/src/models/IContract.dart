import 'dart:async';
import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

abstract class IContractService {
  
  Future<String>? getTokenSymbol();
  Future<BigInt>? getChainDecimal();
  Future<Credentials>? getCredentials(String privateKey);
  Future<BigInt>? getTokenBalance(EthereumAddress from);
  Future<BigInt>? getMaxGas(EthereumAddress sender, TransactionInfo trxInfo);
  Future<bool>? listenTransfer(String hash);
  Future<String>? sendToken(TransactionInfo trxInfo);
  Future<void>? dispose();
}
