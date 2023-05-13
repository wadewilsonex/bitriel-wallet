import 'package:fl_chart/fl_chart.dart';

class ListMetketCoinModel {
    ListMetketCoinModel({
        this.id,
        this.symbol,
        this.name,
        this.image,
        this.currentPrice,
        this.marketCap,
        this.marketCapRank,
        this.fullyDilutedValuation,
        this.totalVolume,
        this.high24H,
        this.low24H,
        this.priceChange24H,
        this.priceChangePercentage24H,
        this.marketCapChange24H,
        this.marketCapChangePercentage24H,
        this.circulatingSupply,
        this.totalSupply,
        this.maxSupply,
        this.ath,
        this.athChangePercentage,
        this.athDate,
        this.atl,
        this.atlChangePercentage,
        this.atlDate,
        this.lastUpdated,
        this.chart,
    });

    String? id;
    String? symbol;
    String? name;
    String? image;
    dynamic currentPrice;
    dynamic marketCap;
    dynamic marketCapRank;
    dynamic fullyDilutedValuation;
    dynamic totalVolume;
    dynamic high24H;
    dynamic low24H;
    dynamic priceChange24H;
    dynamic priceChangePercentage24H;
    dynamic marketCapChange24H;
    dynamic marketCapChangePercentage24H;
    dynamic circulatingSupply;
    dynamic totalSupply;
    dynamic maxSupply;
    dynamic ath;
    dynamic athChangePercentage;
    dynamic athDate;
    dynamic atl;
    dynamic atlChangePercentage;
    dynamic atlDate;
    dynamic lastUpdated;
    List<FlSpot>? chart;

    ListMetketCoinModel fromJson(Map<String, dynamic> json){
      id = json['id'];
      symbol = json['symbol'];
      name = json['name'];
      image = json['image'];
      currentPrice = json['current_price'];
      marketCap = json['market_cap'];
      marketCapRank = json['market_cap_rank'];
      fullyDilutedValuation = json['fully_diluted_valuation'];
      totalVolume = json['total_volume'];
      high24H = json['high_24h'];
      low24H = json['low_24h'];
      priceChange24H = json['price_change_24h'];
      priceChangePercentage24H = json['price_change_percentage_24h'];
      marketCapChange24H = json['market_cap_change_24h'];
      marketCapChangePercentage24H = json['market_cap_change_percentage_24h'];
      circulatingSupply = json['circulating_supply'];
      totalSupply = json['total_supply'];
      maxSupply = json['max_supply'];
      ath = json['ath'];
      athChangePercentage = json['ath_change_percentage'];
      athDate = json['ath_date'];
      atl = json['atl'];
      atlChangePercentage = json['atl_change_percentage'];
      atlDate = json['atl_date'];
      lastUpdated = json['last_updated'];
      
      return this;
    }   
}


