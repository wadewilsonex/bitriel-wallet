class CreateKeyModel {

  bool? initial = false;
  String? seed = "";
  String? tmpSeed = "";
  String passCode = "";
  List<String>? lsSeeds = [];
  List<String> missingSeeds = [];
  List<String>? threeNum = [];
  List<String>? tmpThreeNum = [];
  List<SeedStore> seedList = [];

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

  List<SeedStore> fromJsonDb(List<Map<String, dynamic>> lst) {
    return lst.map((e) => SeedStore(seed: e['seed'], status: e['status'])).toList();
  } 

  List<Map<String, dynamic>> seedListToJson(){
    return seedList.map((e) => {"seed": e.seed, "status": e.status}).toList();
  }
}

class SeedStore {

  String? seed;
  bool? status;

  SeedStore({this.seed, this.status});

}