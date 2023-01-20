class CoinsModel {
  
  late Item item;
  
  CoinsModel.fromJson(Map<String, dynamic> json){
    item = Item().fromJson(json);
  }
}

class Item {
  
    Item({
      this.id,
      this.coinId,
      this.name,
      this.symbol,
      this.marketCapRank,
      this.thumb,
      this.small,
      this.large,
      this.slug,
      this.priceBtc,
      this.score,
    });

    String? id;
    int? coinId;
    String? name;
    String? symbol;
    int? marketCapRank;
    String? thumb;
    String? small;
    String? large;
    String? slug;
    double? priceBtc;
    int? score;
    
    Item fromJson(Map<String, dynamic> json){
      id = json['item']['id'];
      coinId = json['item']['coin_id'];
      name = json['item']['name'];
      symbol = json['item']['symbol'];
      marketCapRank = json['item']['market_cap_rank'];
      thumb = json['item']['thumb'];
      small = json['item']['small'];
      large = json['item']['large'];
      slug = json['item']['slug'];
      priceBtc = json['item']['price_btc'];
      score = json['item']['score'];
      
      return this;
    }
}