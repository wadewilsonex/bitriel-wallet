import 'package:wallet_apps/index.dart';

class AssetInfoModel {
  
  PageController controller = PageController();
  String totalUsd = '';

  int tabIndex = 0;

  // From Widget Index
  int? index;

  double logoSize = 8;

  GlobalKey<ScaffoldState>? globalKey;

  SmartContractModel? smartContractModel;
  
  List<TransactionInfo>? lsTxInfo;

  Color bg = Colors.white.withOpacity(0.06);
}