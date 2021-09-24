import 'package:wallet_apps/src/models/asset_m.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';

class SmartContractModel {

  String id;
  String address;
  String chainDecimal;
  String symbol;
  String name;
  String balance;
  String logo;
  String type;
  String org;
  Market marketData;
  String marketPrice;
  String change24h;
  bool isContain;
  List<List<double>> lineChartData = [];
  LineChartModel lineChartModel;

  SmartContractModel({
    this.id,
    this.address,
    this.chainDecimal,
    this.symbol,
    this.name,
    this.balance = '0.0',
    this.logo,
    this.type,
    this.org = '',
    this.marketData,
    this.marketPrice,
    this.change24h,
    this.isContain,
    this.lineChartData,
    this.lineChartModel}
  );

}
