class CoinInfo {

  String? id = "";
  String? symbol = "";
  String? name = "";
  String? asset_platform_id = "";
  Map<String, dynamic>? platforms = {};

  CoinInfo();

  CoinInfo.fromJson(Map<String, dynamic> jsn){
    id = jsn['id'];
    symbol = jsn['symbol'];
    name = jsn['name'];
    asset_platform_id = jsn['asset_platform_id'];
    for (var element in Map<String, dynamic>.from(jsn['platforms']).entries) {

      if (element.key.contains('ethereum') || element.key.contains('binance-smart-chain')) {
        // return MapEntry(key, value);

        platforms!.addAll({element.key: element.value});
        
      }
    }}

  // {
  //   "id": "tether",
  //   "symbol": "usdt",
  //   "name": "Tether",
  //   "asset_platform_id": "ethereum",
  //   "platforms": {
  //     "ethereum": "0xdac17f958d2ee523a2206206994597c13d831ec7",
  //     "binance-smart-chain": "0x55d398326f99059ff775485246999027b3197955"
  //   }
  // }
}