class CreateKeyModel {

  bool? initial = false;
  String? seed = "";
  String? tmpSeed = "";
  String passCode = "";
  List<String>? lsSeeds = [];
  List<String> missingSeeds = [];
  List<String>? threeNum = [];
  List<String>? tmpThreeNum = [];

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
}