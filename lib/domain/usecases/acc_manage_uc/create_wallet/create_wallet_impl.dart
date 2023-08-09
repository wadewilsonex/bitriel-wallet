import 'dart:math';
import 'package:bitriel_wallet/index.dart';

class Verify {

  String? seedWord;
  String? threeSeed = "";

  List<int>? threeSeedIndex = [];

  List<int>? tmpThreeSeedIndex = [];
  List<String>? verifySeeds = [];

}

class CreateWalletImpl implements CreateWalletUsecase {
  
  SDKProvider? _sdkProvier;
  BuildContext? _context;

  String? pin;

  /// For Create And Import
  ValueNotifier<bool>? isVerifying = ValueNotifier(false);
  List getPrivateList = [];
  Map<String, dynamic>? unverifyAcc;
  ValueNotifier<String> seed = ValueNotifier('');

  /// For Verify Seed
  // ValueNotifier<String> threeSeed = ValueNotifier('');;
  ValueNotifier<List<int>> tmpThreeSeedIndex = ValueNotifier([]);
  ValueNotifier<List<String>> verifySeeds = ValueNotifier([]);

  ValueNotifier<bool> isReset = ValueNotifier(false);

  NewAccount? newAcc;

  final AccountManagementImpl _accountManagementImpl = AccountManagementImpl();

  List<UnverifySeed> unverifyList = [];

  bool? isMultiAcc = false;
  bool? isVerifyLater = false;

  ValueNotifier<bool> isMatch = ValueNotifier(false);
  // if (isMultiAcc == true) {
  //     Navigator.pushNamedAndRemoveUntil(_context!, "/${BitrielRouter.multiAccRoute.toString()}", (route) => false);
  //   }

  final Verify verify = Verify();

  @override
  set setBuildContext(BuildContext ctx){
    _context = ctx;
    _sdkProvier = Provider.of<SDKProvider>(ctx, listen: false);
  }
  
  @override
  void remove3Seeds({bool isReset = false}) {

    // miss3Seed.value = [];
    // tmpThreeSeed.value = [];
    verify.verifySeeds!.clear();
    verifySeeds.value.clear();

    verify.tmpThreeSeedIndex!.clear();
    tmpThreeSeedIndex.value.clear();

    if (isReset == false) verify.threeSeedIndex = randomThreeEachNumber();

    /// Add Origin lsSeeds To missThreeSeed
    /// We use loop, because we want to prevent value at defautl seed
    for (var element in seed.value.split(" ")) {
      verify.verifySeeds!.add(element);
    }
    verifySeeds.value = verify.verifySeeds!;

    for (var element in verify.threeSeedIndex!) {
      verify.tmpThreeSeedIndex!.add(element);
    }
    tmpThreeSeedIndex.value = verify.tmpThreeSeedIndex!;

    // Replace match index with Empty
    verify.verifySeeds![verify.tmpThreeSeedIndex![0]] = "";
    verify.verifySeeds![verify.tmpThreeSeedIndex![1]] = "";
    verify.verifySeeds![verify.tmpThreeSeedIndex![2]] = "";

    verifySeeds.value[tmpThreeSeedIndex.value[0]] = "";
    verifySeeds.value[tmpThreeSeedIndex.value[1]] = "";
    verifySeeds.value[tmpThreeSeedIndex.value[2]] = "";

    if (isReset == true) {
      isMatch.value = false;
      resetNotify();
    }
  
  }

  void resetNotify(){
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    isReset.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    isMatch.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    tmpThreeSeedIndex.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    verifySeeds.notifyListeners();
  }

  @override
  void onTapThreeSeeds(int index, int rmIndex){
    
    // for(int i = 0; i < tmpVerifySeeds.length; i++){
    //   if (tmpVerifySeeds[i] == ""){
    //     tmpVerifySeeds[i] = widget.createKeyModel!.lsSeeds![index];
    //     break;
    //   }
    // }
    
    verify.seedWord = (seed.value.split(" ")[verify.tmpThreeSeedIndex![rmIndex]]);
    
    for (var element in verify.verifySeeds!) {
      if (element.isEmpty){
        verify.verifySeeds![verify.verifySeeds!.indexOf(element)] = verify.seedWord!;
        break;
      }
    }
    
    verifySeeds.value = verify.verifySeeds!;

    verify.tmpThreeSeedIndex!.removeAt(rmIndex);
    tmpThreeSeedIndex.value = verify.tmpThreeSeedIndex!;

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    verifySeeds.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    tmpThreeSeedIndex.notifyListeners();

    isFilledSeedMatch();

    // verify.verifySeeds = verify.threeSeedIndex![index];

    // verify.threeSeedIndex!.remove(rmIndex);

    // verifySeeds.value[index] = verify. ;
    
    // verify.tmpThreeSeedIndex!.remove(rmIndex);
    
    // // Enable Reset Three Seed Back
    if (isReset.value == false) isReset.value = true;

    // widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    // threeSeed.value.split(" ").removeAt(rmIndex);

  }
  
  void isFilledSeedMatch(){
    
    if (tmpThreeSeedIndex.value.isEmpty){
      if (verifySeeds.value.join(" ") == seed.value){
        isMatch.value = true;
      }
    }
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
    seed.value = await _sdkProvier!.getSdkImpl.generateSeed();
  }

  @override
  Future<void> verifyLater() async {

    isVerifyLater = true;

    await addAndImport();
    // await verifyLaterData();

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
  Future<void> addAndImport() async {

    await _accountManagementImpl.addAndImport(_sdkProvier!, _context!, seed.value, pin!);

    // If Verify Later Chosen then Param will pass to false, Else Param will pass to true
    await _accountManagementImpl.verifyLaterData(_sdkProvier!, isVerifyLater == true ? false : true);

    if (isMultiAcc == true) {
      Navigator.pushNamedAndRemoveUntil(_context!, "/${BitrielRouter.multiAccRoute}", (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(_context!, "/${BitrielRouter.homeRoute}", (route) => false);
    }
    
  }

}