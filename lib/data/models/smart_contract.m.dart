import 'package:fl_chart/fl_chart.dart';
import '../../index.dart';

class SmartContractModel {

  String? index;
  String? id;
  String? address;
  String? contract;
  String? contractTest;
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
  int? chainDecimal;
  bool? isContain;
  bool? show;
  bool? isAdded;
  String? maxSupply;
  String? description;
  List<TransactionInfo>? listActivity = [];
  List<List<double>>? lineChartList = [];
  List<FlSpot>? chart;
  LineChartModel? lineChartModel = LineChartModel();
  double? money;

  SmartContractModel({
    this.index,
    this.id,
    this.address,
    this.chainDecimal,
    this.symbol,
    this.name,
    this.balance,
    this.logo,
    this.type,
    this.org = '',
    this.orgTest = '',
    this.marketData,
    this.marketPrice = '0',
    this.change24h = '',
    this.isContain, 
    this.show,
    this.maxSupply,
    this.description,
    this.listActivity,
    this.lineChartList,
    this.lineChartModel,
    this.contract,
    this.contractTest,
    this.chart,
    this.isAdded = false
  });

  factory SmartContractModel.fromJson(Map<String, dynamic> json) {
    return SmartContractModel(
      index: json['index'],
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
      marketData: json['market'] != null ? Market.fromJson(json['market']) : null,
      lineChartList: json['lineChartData'] != null
        ? List<List<double>>.from(json["lineChartData"].map((x) => List<double>.from(x.map((x) => x.toDouble()))))
        : null,
      change24h: json['change24h'],
      marketPrice: json['marketPrice'] ?? '0',
      name: json['name'],
      lineChartModel: json['lineChartModel'] == null ? LineChartModel() : LineChartModel.fromJson(json['lineChartModel']),
      show: json['show'],
      maxSupply: json['max_supply'],
      description: json['description'],
      isAdded: json['isAdded'] ?? false
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
    'market': null,//asset.marketData,
    'lineChartData': asset.lineChartList,
    'change24h': asset.change24h,
    'marketPrice': asset.marketPrice,
    'name': asset.name,
    "chainDecimal": asset.chainDecimal,
    "contract": asset.contract,
    "contract_test": asset.contractTest,
    'lineChartModel': LineChartModel.toJson(asset.lineChartModel!),
    'show': asset.show,
    'max_supply': asset.maxSupply,
    'description': asset.description,
    'isAdded': asset.isAdded,
  };

  static List<Map<String, dynamic>> encode(List<SmartContractModel> assets) {
    
    return assets.map<Map<String, dynamic>>((asset) => SmartContractModel.toMap(asset)).toList();
  }

  static Future<List<SmartContractModel>> decode(String asset) async {
    final decode = await json.decode(asset);
    List<SmartContractModel> data = decode.map<SmartContractModel>((item) => SmartContractModel.fromJson(item)).toList();
    // debugPrint('data ${data.runtimeType} ${data[0]}');
    // debugPrint('decode again ${jsonDecode(data)[0]}');
    return data;
  }
}
