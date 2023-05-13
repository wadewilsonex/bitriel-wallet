class CreateKeyModel {

  bool? initial = false;
  String? seed = "";
  String? tmpSeed = "";
  String passCode = "";
  List<String>? lsSeeds = [];
  List<String> missingSeeds = [];
  List<String>? threeNum = [];
  List<String>? tmpThreeNum = [];
  List<UnverifySeed> unverifyList = [];

  void emptyData(){
    initial = false;
    seed = "";
    tmpSeed = "";
    passCode = "";
    lsSeeds = [];
    missingSeeds = [];
    threeNum = [];
    tmpThreeNum = [];
  }

  List<UnverifySeed> fromJsonDb(List<Map<String, dynamic>> lst) {
    return lst.map((e) => UnverifySeed(address: e['address'], status: e['status'], ethAddress: e['eth_address'], btcAddress: e['btc_address'])).toList();
  } 

  List<Map<String, dynamic>> unverifyListToJson(){
    return unverifyList.map((e) => {"address": e.address, "status": e.status, "eth_address": e.ethAddress, "btc_address": e.btcAddress}).toList();
  }
}

class UnverifySeed {

  String? ethAddress;
  String? btcAddress;
  String? address;
  bool? status;

  UnverifySeed({this.address, this.status, required this.ethAddress, required this.btcAddress});

  Map<String, dynamic> toMap(){
    return {"address": address, "status": status, "eth_address": ethAddress, "btc_address": btcAddress};
  }

}