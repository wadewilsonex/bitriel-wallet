import 'package:bitriel_wallet/index.dart';

abstract class AccountMangementUC {

  Future<void> addAndImport(SDKProvier sdkProvider, BuildContext context, String seed, String pin);
}