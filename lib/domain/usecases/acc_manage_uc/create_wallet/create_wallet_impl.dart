import 'dart:convert';
import 'dart:math';
import 'package:bitriel_wallet/index.dart';

class CreateWalletImpl implements CreateWalletUsecase {
  
  SDKProvier? _sdkProvier;
  BuildContext? context;

  String? pin;

  /// For Create And Import
  ValueNotifier<bool>? isVerifying = ValueNotifier(false);
  List getPrivateList = [];
  Map<String, dynamic>? unverifyAcc;
  ValueNotifier<String> seed = ValueNotifier('');

  /// For Verify Seed
  ValueNotifier<String> threeSeed = ValueNotifier('');
  List<int> threeSeedIndex = [];
  ValueNotifier<List<String>> verifySeeds = ValueNotifier([]);
  List<String> tmpVerifySeeds = [];

  NewAccount? newAcc;

  final AccountManagementImpl _accountManagementImpl = AccountManagementImpl();

  List<UnverifySeed> unverifyList = [];

  @override
  set setBuildContext(BuildContext ctx){
    context = ctx;
    _sdkProvier = Provider.of<SDKProvier>(ctx, listen: false);
  }
  
  @override
  Future<void> verifyLater() async {

    print("verifyLater PIN $pin");

    dialogLoading(context!);

    await addAndImport();

    await verifyLaterData();

    // // _importAccountModel.status = false;

    // /// From Multi Account
    // if (newAcc != null){

    //   dialogLoading(context!);

    //   // await addAndImport();
      
    //   // Provider.of<ApiProvider>(context!, listen: false).notifyListeners();
          
    //   Navigator.popUntil(context!, ModalRoute.withName('/multipleWallets'));
    // }

    // // /// From Onboading Page Create New
    // // else {

    //   Navigator.push(
    //     context!, 
    //     MaterialPageRoute(builder: (context) => const HomeScreen())
    //     // Transition(
    //     //   child: DataLoading(initStateData: initStateData, importAnimationAccModel: _importAccountModel,),
    //     //   transitionEffect: TransitionEffect.RIGHT_TO_LEFT
    //     // )
    //   );
    // }

  }
  
  @override
  Future<void> verifyLaterData() async {

    unverifyList.add(UnverifySeed.init(
      address: _sdkProvier!.getSdkProvider.getSELAddress,
      status: false, 
      ethAddress: _sdkProvier!.getSdkProvider.evmAddress,
      btcAddress: _sdkProvier!.getSdkProvider.btcAddress// conProvider!.listContract[_apiProvider!.btcIndex].address
    ));

    print("UnverifySeed.unverifyListToJson(unverifyList) ${UnverifySeed().unverifyListToJson(unverifyList)}");

    await SecureStorageImpl().writeSecureList(DbKey.privateList, jsonEncode(UnverifySeed().unverifyListToJson(unverifyList)));

    await SecureStorageImpl().readSecure(DbKey.privateList)!.then((value) {
      print("readSecure ${value}");
    });
  }
  
  @override
  void remove3Seeds() {

    // miss3Seed.value = [];
    // tmpThreeSeed.value = [];
    tmpVerifySeeds = [];

    threeSeedIndex = randomThreeEachNumber();

    /// Add Origin lsSeeds To missThreeSeed
    /// We use loop, because we want to prevent value at defautl seed
    for (var element in seed.value.split(" ")) {
      tmpVerifySeeds.add(element);
    }

    // Replace match index with Empty
    tmpVerifySeeds[threeSeedIndex[0]] = "";
    tmpVerifySeeds[threeSeedIndex[1]] = "";
    tmpVerifySeeds[threeSeedIndex[2]] = "";

    verifySeeds.value = tmpVerifySeeds;

    // widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
  
  }

  @override
  List<int> randomThreeEachNumber(){
    // First Number
    int rd1 = Random().nextInt(12);
    while(rd1 == 0){
      rd1 = Random().nextInt(12);
    }

    // Second Number
    int rd2 = Random().nextInt(12);
    while(rd2 == rd1 || rd2 == 0){
      rd2 = Random().nextInt(12);
      if (rd2 != rd1) break;
    }

    // Third Number
    int rd3 = Random().nextInt(12);
    while(rd3 == rd1 || rd3 == rd2 || rd3 == 0){
      rd3 = Random().nextInt(12);
      if (rd3 != rd1 && rd3 != rd2) break;
    }

    return [rd1, rd2, rd3];
  }

  @override
  Future<void> generateSeed() async {
    seed.value = await Provider.of<SDKProvier>(context!, listen: false).getSdkProvider.generateSeed();
  }

  @override
  Future<void> addAndImport() async {

    await _accountManagementImpl.addAndImport(_sdkProvier!, context!, seed.value, pin!);

    // await _sdkProvier!.importSeed(verifySeeds.value.join(","), pin!).then((value) {
      
    //   Navigator.pop(context!);

    //   print("Success");
    //   // Navigator.push(
    //   //   context, route
    //   // );
    // });
  }

}