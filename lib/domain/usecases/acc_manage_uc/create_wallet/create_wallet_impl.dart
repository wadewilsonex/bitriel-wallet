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
    seed.value = await _sdkProvier!.getSdkProvider.generateSeed();
  }

  @override
  Future<void> showWarning() async{
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      isDismissible: false,
      enableDrag: false,
      context: context!,
      builder: (setBuildContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: MyTextConstant(
                  text: "Please, read carefully!",
                  fontSize: 18,
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                  fontWeight: FontWeight.w600,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: hexaCodeToColor(AppColors.red).withOpacity(0.25),
                ),
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: <Widget>[

                    const SizedBox(width: 5),

                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Lottie.asset(
                        "assets/animation/loading-block.json",
                        repeat: true,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: MyTextConstant(
                        text: "The information below is important to guarantee your account security.",
                        color2: hexaCodeToColor(AppColors.red),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ]
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: MyTextConstant(
                  text:
                    "Please write down your wallet's mnemonic seed and keep it in a safe place. The mnemonic can be used to restore your wallet. If you lose it, all your assets that link to it will be lost.",
                  textAlign: TextAlign.start,
                  color2: hexaCodeToColor(AppColors.midNightBlue),
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: MyGradientButton(
                  textButton: "I Agree",
                  action: () async{
                    Navigator.of(context!).pop();
                  },
                ),
              ),

            ],
          ),
        );
      }
    );
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