import 'package:bitriel_wallet/index.dart';

abstract class LetsExchangeUseCases {
  Future<void> getLetsExchangeCoin();
  void onDeleteTxt();
  void formatDouble(String value);
  Future<void> swap();
  Future<void> confirmSwap(SwapResModel swapResModel);
  Future<void> swapping(SwapResModel swapResModel);
}