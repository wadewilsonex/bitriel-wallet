import 'package:bitriel_wallet/index.dart';

abstract class AccountMangementUC {

  Future<void> addAndImport(BuildContext context, String seed, String pin);
  Future<void> verifyLaterData(SDKProvider? sdkProvider, bool status);
}