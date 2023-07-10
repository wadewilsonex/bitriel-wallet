abstract class ImportWalletUsecases {

  void changeState(String seed);
  void resetState();
  Future<void> addAndImport(String pin);
}