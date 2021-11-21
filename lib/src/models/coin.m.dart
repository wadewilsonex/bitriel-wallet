import 'package:wallet_apps/src/models/asset_m.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';

class CoinModel {
  String? id;
  String? chainDecimal;
  String? symbol;
  String? balance;
  String? logo;
  String? type;
  String? org;
  Market? marketData;
  String? marketPrice;
  String? change24h;
  bool? isContain;
  List<List<double>>? lineChartData = [];

  LineChartModel? lineChartModel;

  CoinModel({
    this.id,
    this.chainDecimal,
    this.symbol,
    this.balance,
    this.logo,
    this.type,
    this.org,
    this.marketData,
    this.marketPrice,
    this.change24h,
    this.isContain,
    this.lineChartData,
    this.lineChartModel
  });

  void init() {}
}
