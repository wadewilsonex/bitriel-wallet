import 'package:wallet_apps/index.dart';

class VerifySeedsProvider with ChangeNotifier {
  
  String? mnemonic;

  bool? isVerifying = false;

  List getPrivateList = [];

  Map<String, dynamic>? unverifyAcc;
  
}