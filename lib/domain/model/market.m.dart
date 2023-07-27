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


class ListMetketCoinGecko {
    final String id;
    final String symbol;
    final String name;
    final String image;
    final dynamic currentPrice;
    final dynamic marketCap;
    final dynamic marketCapRank;
    final dynamic totalVolume;
    final dynamic priceChange24H;
    final dynamic priceChangePercentage24H;
    final dynamic marketCapChange24H;
    final dynamic marketCapChangePercentage24H;
    final dynamic circulatingSupply;
    final dynamic totalSupply;
    final dynamic maxSupply;

    ListMetketCoinGecko({
        required this.id,
        required this.symbol,
        required this.name,
        required this.image,
        required this.currentPrice,
        required this.marketCap,
        required this.marketCapRank,
        required this.totalVolume,
        required this.priceChange24H,
        required this.priceChangePercentage24H,
        required this.marketCapChange24H,
        required this.marketCapChangePercentage24H,
        required this.circulatingSupply,
        required this.totalSupply,
        required this.maxSupply,
    });

    factory ListMetketCoinGecko.fromRawJson(String str) => ListMetketCoinGecko.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ListMetketCoinGecko.fromJson(Map<String, dynamic> json) => ListMetketCoinGecko(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        image: json["image"],
        currentPrice: json["current_price"],
        marketCap: json["market_cap"],
        marketCapRank: json["market_cap_rank"],
        totalVolume: json["total_volume"],
        priceChange24H: json["price_change_24h"],
        priceChangePercentage24H: json["price_change_percentage_24h"],
        marketCapChange24H: json["market_cap_change_24h"],
        marketCapChangePercentage24H: json["market_cap_change_percentage_24h"],
        circulatingSupply: json["circulating_supply"],
        totalSupply: json["total_supply"],
        maxSupply: json["max_supply"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "current_price": currentPrice,
        "market_cap": marketCap,
        "market_cap_rank": marketCapRank,
        "total_volume": totalVolume,
        "price_change_24h": priceChange24H,
        "price_change_percentage_24h": priceChangePercentage24H,
        "market_cap_change_24h": marketCapChange24H,
        "market_cap_change_percentage_24h": marketCapChangePercentage24H,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "max_supply": maxSupply,
    };
}



