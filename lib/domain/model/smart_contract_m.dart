import 'package:bitriel_wallet/domain/model/tx_history_m.dart';
import 'package:bitriel_wallet/index.dart';

class SmartContractModel {

  String? index;
  String? id;
  String? address;
  String? contract;
  String? symbol;
  String? name;
  String? balance;
  String? logo;
  String? type;
  String? org;

  bool? isEther;
  bool? isBSC;
  bool? isNative;
  bool? isBep20;
  bool? isErc20;
  
  // Market? marketData;
  String? marketPrice;
  String? change24h;
  int? chainDecimal;
  bool? show;
  bool? addedCoin;
  String? maxSupply;
  String? description;
  // List<TransactionInfo>? listActivity = [];
  List<List<double>>? lineChartList = [];
  List<FlSpot>? chart;
  LineChartModel? lineChartModel = LineChartModel();
  double? money;
  List<Map<String, dynamic>>? platform;
  Market? marketData;
  List<TxHistoryModel>? trxHistory;

  SmartContractModel({
    this.index,
    this.id,
    this.address,
    this.chainDecimal,
    this.symbol,
    this.name,
    this.balance = "0",
    this.logo,
    this.type,
    this.org = '',
    // this.marketData,
    this.marketPrice = '0',
    this.change24h = '',
    this.show,
    this.maxSupply,
    this.description,
    // this.listActivity,
    this.lineChartList,
    // this.lineChartModel,
    this.contract,
    // this.chart,
    this.addedCoin = false,
    this.isEther = false,
    this.isBSC = false,
    this.isNative = false,
    this.isBep20 = false,
    this.isErc20 = false,
    this.platform,
    this.marketData,
    this.trxHistory
  });

  factory SmartContractModel.fromJson(Map<String, dynamic> json) {
    return SmartContractModel(
      index: json['index'],
      id: json['id'],
      address: json['address'],
      symbol: json['symbol'],
      type: json['type'],
      logo: json['logo'],
      org: json['org'],
      isEther: json["is_ether"] ?? false,
      isBSC: json["is_bsc"] ?? false,
      isNative: json["is_native"] ?? false,
      isBep20: json["is_bep20"] ?? false,
      isErc20: json["is_erc20"] ?? false,
      contract: json['contract'],
      chainDecimal: json['chainDecimal'],
      // marketData: json['market'] != null ? Market.fromJson(json['market']) : null,
      // lineChartList: json['lineChartData'] != null
      //   ? List<List<double>>.from(json["lineChartData"].map((x) => List<double>.from(x.map((x) => x.toDouble()))))
      //   : null,
      change24h: json['change24h'],
      marketPrice: json['marketPrice'] ?? '0',
      name: json['name'],
      // lineChartModel: json['lineChartModel'] == null ? LineChartModel() : LineChartModel.fromJson(json['lineChartModel']),
      show: json['show'],
      maxSupply: json['max_supply'],
      description: json['description'],
      addedCoin: json['added_coin'],
      platform: json['platform'] != null ? List<Map<String, dynamic>>.from(json['platform']) : null,
      balance: "0",
      marketData: json['market'] != null ? Market.fromJson(json['market']) : null,
      trxHistory: (json['trx_history'] == null || json['trx_history'] == []) ? [] : TxHistoryModel.decode(json['trx_history'])
    );
  }

  static Map<String, dynamic> toMap(SmartContractModel asset) => {
    'index': asset.index,
    'id': asset.id,
    'address': asset.address,
    'symbol': asset.symbol,
    'type': asset.type,
    'logo': asset.logo,
    'org': asset.org,
    'market': asset.marketData,
    'lineChartData': asset.lineChartList,
    'change24h': asset.change24h,
    'marketPrice': asset.marketPrice,
    'name': asset.name,
    "chainDecimal": asset.chainDecimal,
    "contract": asset.contract,
    // 'lineChartModel': LineChartModel.toJson(asset.lineChartModel!),
    'show': asset.show,
    'max_supply': asset.maxSupply,
    'description': asset.description,
    'added_coin': asset.addedCoin,
    'is_bsc': asset.isEther,
    'is_ether': asset.isBSC,
    'is_native': asset.isNative,
    'is_bep20': asset.isBep20,
    'is_erc20': asset.isErc20,
    'platform': asset.platform,
    'trx_history': TxHistoryModel.encode(asset.trxHistory!)
  };

  static List<Map<String, dynamic>> encode(List<SmartContractModel> assets) {
    return assets.map<Map<String, dynamic>>((asset) => SmartContractModel.toMap(asset)).toList();
  }

  static Future<List<SmartContractModel>> decode(String asset) async {
    return json.decode(asset).map<SmartContractModel>((item) => SmartContractModel.fromJson(item)).toList();
  }
}
