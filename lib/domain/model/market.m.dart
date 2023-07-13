class Market {
  final String name;
  final double price;
  final String exchange;
  final String logo;
  final String symbol;
  final String fullName;
  final dynamic marketCap;
  final dynamic volume24h;
  final dynamic circulatingSupply;
  final dynamic totalSupply;

  Market(
    this.name,
    this.price,
    this.exchange,
    this.logo,
    this.symbol,
    this.fullName,
    this.marketCap,
    this.volume24h,
    this.circulatingSupply,
    this.totalSupply,
  );

  factory Market.fromJson(Map<String,dynamic> json){
    return Market(
      json['name'],
      json['quotes'][0]['price'],
      json['quotes'][0]['name'],
      "https://s2.coinmarketcap.com/static/img/coins/64x64/${json['id']}.png",
      json['symbol'],
      "${json['name']} - ${json['symbol']}",
      json['quotes'][0]['marketCap'],
      json['quotes'][0]['volume24h'],
      json['circulatingSupply'],
      json['totalSupply'],
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
