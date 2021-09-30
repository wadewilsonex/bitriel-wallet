import 'package:wallet_apps/src/models/asset_m.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';

import '../../index.dart';

class SmartContractModel {
  String id;
  String address;
  String chainDecimal;
  String symbol;
  String balance;
  String logo;
  String type;
  String org;
  Market marketData;
  String marketPrice;
  String change24h;
  bool isContain;
  List<TransactionInfo> listActivity = [];
  List<List<double>> lineChartData = [];

  LineChartModel lineChartModel;

  SmartContractModel({
    this.id,
    this.address,
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
    this.listActivity,
    this.lineChartData,
    this.lineChartModel,
  });

  factory SmartContractModel.fromJson(Map<String, dynamic> json) {
    return SmartContractModel(
      id: json['id'],
      address: json['address'],
      symbol: json['symbol'],
      balance: json['balance'],
      type: json['type'],
      logo: json['logo'],
      org: json['org'],
      // marketData: Market.fromJson(json['market'] as Map<String, dynamic>),
      marketData:
          json['market'] != null ? Market.fromJson(json['market']) : null,

      lineChartData: json['lineChartData'] != null
          ? List<List<double>>.from(json["lineChartData"]
              .map((x) => List<double>.from(x.map((x) => x.toDouble()))))
          : null,
    );
  }

  static Map<String, dynamic> toMap(SmartContractModel asset) => {
        'id': asset.id,
        'address': asset.address,
        'symbol': asset.symbol,
        'balance': asset.balance,
        'type': asset.type,
        'logo': asset.logo,
        'org': asset.org,
        'market': asset.marketData,
        'lineChartData': asset.lineChartData,
        // 'listActivity': asset.listActivity,

        // 'lineChartModel': asset.lineChartModel
      };

  static String encode(List<SmartContractModel> assets) => json.encode(
        assets
            .map<Map<String, dynamic>>(
                (asset) => SmartContractModel.toMap(asset))
            .toList(),
      );

  static List<SmartContractModel> decode(String asset) =>
      (json.decode(asset) as List<dynamic>)
          .map<SmartContractModel>((item) => SmartContractModel.fromJson(item))
          .toList();
}
