import 'package:bitriel_wallet/index.dart';

abstract class MultiAccountUsecases {

  Future<void> createWallet();
  Future<void> importWallet();
  Future<void> switchAccount(KeyPairData acc, int index);
  Future<void> changeWalletName(int index, String newName);
  
}