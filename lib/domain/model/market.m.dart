import 'package:bitriel_wallet/index.dart';

class Market {
  final String name;
  final double price;
  final String logo;
  final String symbol;
  final String fullName;
  final dynamic marketCap;
  final dynamic volume24h;
  final dynamic circulatingSupply;
  final dynamic totalSupply;
  final dynamic maxSupply;
  List<FlSpot>? chart;

  Market(
    this.name,
    this.price,
    this.logo,
    this.symbol,
    this.fullName,
    this.marketCap,
    this.volume24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
  );

  factory Market.fromJson(Map<String,dynamic> json){
    return Market(
      json['name'],
      json['quote']["USD"]['price'],
      "https://s2.coinmarketcap.com/static/img/coins/64x64/${json['id']}.png",
      json['symbol'],
      "${json['name']} - ${json['symbol']}",
      json['quote']["USD"]['market_cap'],
      json['quote']["USD"]['volume_24h'],
      json['circulating_supply'],
      json['total_supply'],
      json['max_supply'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name
    };
  }

  @override
  String toString() {
    return "{name: $name}";
  }
}
