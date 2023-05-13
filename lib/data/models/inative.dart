import 'package:wallet_apps/index.dart';

abstract class INativeService {
  Future<Credentials>? getCredentials(String privateKey);
  Future<num>? getBalance(EthereumAddress from);
  Future<BigInt>? getMaxGas(EthereumAddress sender, TransactionInfo trxInfo);
  Future<bool>? listenTransfer(String hash);
  Future<String>? sendTx(TransactionInfo trxInfo);
  Future<void>? dispose();
}
