import 'dart:math';
import 'package:bitriel_wallet/index.dart';

class CreateWalletImpl implements CreateWalletUsecase {

  BuildContext? context;

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
  
  // ValueNotifier<List<String>> miss3Seed = ValueNotifier(List.empty(growable: true));

  @override
  set setBuildContext(BuildContext ctx){
    context = ctx;
  }
  
  @override
  Future<void> verifyLater() async {

    // _importAccountModel.status = false;

    // /// From Multi Account
    // if (widget.newAcc != null){

    //   dialogLoading(context);

    //   await addAndImport();
      
    //   Provider.of<ApiProvider>(context, listen: false).notifyListeners();
          
    //   Navigator.popUntil(context, ModalRoute.withName('/multipleWallets'));
    // }

    // /// From Onboading Page Create New
    // else {
      
      Navigator.push(
        context!, 
        MaterialPageRoute(builder: (context) => const HomeScreen())
        // Transition(
        //   child: DataLoading(initStateData: initStateData, importAnimationAccModel: _importAccountModel,),
        //   transitionEffect: TransitionEffect.RIGHT_TO_LEFT
        // )
      );
    // }

  }
  
  @override
  void remove3Seeds() {

    // miss3Seed.value = [];
    // tmpThreeSeed.value = [];
    tmpVerifySeeds = [];

    threeSeedIndex = randomThreeEachNumber();

    print("seed.value.split(,) ${seed.value.split(" ")}");

    /// Add Origin lsSeeds To missThreeSeed
    /// We use loop, because we want to prevent value at defautl seed
    for (var element in seed.value.split(" ")) {
      tmpVerifySeeds.add(element);
    }

    print("threeSeedIndex $threeSeedIndex");
    print("tmpVerifySeeds $tmpVerifySeeds");
    
    print("threeSeedIndex[0] ${threeSeedIndex[0]}");

    print(tmpVerifySeeds[0]);

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

}