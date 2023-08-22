class UnverifySeed {

  String? ethAddress;
  String? btcAddress;
  String? address;
  String? pubKey;
  bool? status;

  UnverifySeed();
  UnverifySeed.init({this.address, this.status, required this.ethAddress, required this.btcAddress, required this.pubKey});

  Map<String, dynamic> toMap(){
    return {"address": address, "status": status, "eth_address": ethAddress, "btc_address": btcAddress, "pub_key": pubKey};
  }

  List<UnverifySeed> fromJsonDb(List<Map<String, dynamic>> lst) {
    return lst.map((e) => UnverifySeed.init(address: e['address'], status: e['status'], ethAddress: e['eth_address'], btcAddress: e['btc_address'], pubKey: e['pub_key'])).toList();
  } 

  List<Map<String, dynamic>> unverifyListToJson(List<UnverifySeed> unverifyList){
    return unverifyList.map((e) => {"address": e.address, "status": e.status, "eth_address": e.ethAddress, "btc_address": e.btcAddress, "pub_key": e.pubKey}).toList();
  }

}