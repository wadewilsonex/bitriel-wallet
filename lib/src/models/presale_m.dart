import 'package:wallet_apps/index.dart';

class PresaleModel {
  FlareControls flareController = FlareControls();
  final GlobalKey<FormState> presaleKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  bool success = false, enableBtn = false;

  int rate = 10;
  int rateIndex = 1;

  bool canSubmit = false;

  String symbol = "BNB";
  TextEditingController amountController = TextEditingController();
  List<Map<String, dynamic>>? listSupportToken;
  int tokenIndex = 0;
  double? totalInvestment;
  double? balance;

  // This Property For Get Price After Divid with 10pow8

  PresaleModel() {
    initSupportTokenList();
  }

  void initSupportTokenList() {
    PresaleConfig _preSaleConfig = PresaleConfig();
    listSupportToken = [];

    // Add BNB
    listSupportToken!.addAll({
      {
        "symbol": _preSaleConfig.baseMain['symbol'],
        "logo": _preSaleConfig.baseMain['logo'],
        "tokenAddress": _preSaleConfig.baseMain['tokenAddress']
      }
    });
    // Add Another Supported Token
    _preSaleConfig.main56Support.forEach((element) {
      listSupportToken!.addAll({
        {
          "symbol": element['symbol'],
          "logo": element['logo'],
          "tokenAddress": element['tokenAddress'],
        }
      });
    });

  }
}
