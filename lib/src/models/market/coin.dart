import 'package:json_annotation/json_annotation.dart';

part 'coin.g.dart';

@JsonSerializable()
class Coin{

  String? id;
  String? symbol;
  String? name;
  String? image;
  double? current_price;
  double? market_cap;
  double? market_cap_rank;
  double? fully_diluted_valuation;
  double? total_volume;
  double? high_24h;
  double? low_24h;
  double? price_change_24h;
  double? price_change_percentage_24h;
  double? market_cap_change_24h;
  double? market_cap_change_percentage_24h;
  double? circulating_supply;
  double? total_supply;
  double? max_supply;
  double? ath;
  double? ath_change_percentage;
  String? ath_date;
  double? atl;
  double? atl_change_percentage;
  String? atl_date;
  dynamic roi;
  String? last_updated;
  double? price_change_percentage_1h_in_currency;

  Coin({
    this.id,
    this.symbol,
    this.name,
    this.image,
    this.current_price,
    this.market_cap,
    this.market_cap_rank,
    this.fully_diluted_valuation,
    this.total_volume,
    this.high_24h,
    this.low_24h,
    this.price_change_24h,
    this.price_change_percentage_24h,
    this.market_cap_change_24h,
    this.market_cap_change_percentage_24h,
    this.circulating_supply,
    this.total_supply,
    this.max_supply,
    this.ath,
    this.ath_change_percentage,
    this.ath_date,
    this.atl,
    this.atl_change_percentage,
    this.atl_date,
    this.roi,
    this.last_updated,
    this.price_change_percentage_1h_in_currency
  });

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
  Map<String, dynamic> toJson() => _$CoinToJson(this);

}