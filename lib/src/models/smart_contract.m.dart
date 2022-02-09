import 'package:wallet_apps/src/models/asset_m.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';

import '../../index.dart';

class SmartContractModel {

  String? id;
  String? address;
  String? contract;
  String? contractTest;
  String? chainDecimal;
  String? symbol;
  String? name;
  String? balance;
  String? logo;
  String? type;
  String? org;
  String? orgTest;
  Market? marketData;
  String? marketPrice;
  String? change24h;
  bool? isContain;
  List<TransactionInfo>? listActivity = [];
  List<List<double>>? lineChartList = [];
  LineChartModel? lineChartModel = LineChartModel();

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
    this.orgTest = '',
    this.marketData,
    this.marketPrice = '',
    this.change24h = '',
    this.isContain, 
    this.listActivity,
    this.lineChartList,
    this.lineChartModel,
    this.contract,
    this.contractTest
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
      orgTest: json['org_test'],
      contract: json['contract'],
      contractTest: json['contract_test'],
      chainDecimal: json['chainDecimal'],
      // marketData: Market.fromJson(json['market'] as Map<String, dynamic>),
      marketData: json['market'] != null ? Market.fromJson(json['market']) : null,
      lineChartList: json['lineChartData'] != null
        ? List<List<double>>.from(json["lineChartData"].map((x) => List<double>.from(x.map((x) => x.toDouble()))))
        : null,
      change24h: json['change24h'],
      marketPrice: json['marketPrice'],
      name: json['name'],
      lineChartModel: json['lineChartModel'] == null ? LineChartModel() : LineChartModel.fromJson(json['lineChartModel'])
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
    'org_test': asset.orgTest,
    'market': asset.marketData,
    'lineChartData': asset.lineChartList,
    'change24h': asset.change24h,
    'marketPrice': asset.marketPrice,
    'name': asset.name,
    "chainDecimal": asset.chainDecimal,
    "contract": asset.contract,
    "contract_test": asset.contractTest,
    
    // 'listActivity': asset.listActivity,

    'lineChartModel': LineChartModel.toJson(asset.lineChartModel!)
  };

  static String encode(List<SmartContractModel> assets) => json.encode(
    assets.map<Map<String, dynamic>>((asset) => SmartContractModel.toMap(asset)).toList(),
  );

  static List<SmartContractModel> decode(String asset) => (json.decode(asset) as List<dynamic>).map<SmartContractModel>((item) => SmartContractModel.fromJson(item)).toList();
}
