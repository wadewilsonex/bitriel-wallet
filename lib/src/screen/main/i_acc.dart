/// Account Interface
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/import_acc_m.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/data_loading.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

abstract class AccountInterface {

  ImportAccModel? accModel;
  ImportAccAnimationModel? animationModel;

  KeyPairData? keyPairData;

  /// InitState
  /// 
  void initAccInterfaceState(ImportAccModel? aModel, ImportAccAnimationModel? pModel){
    accModel = aModel;
    animationModel = pModel;
  }

  /// First Action
  Future<KeyPairData?> importAcc() async {
    debugPrint("importAcc ");

    debugPrint("accModel!.key!.text,    ${accModel!.key!.text  }");
    debugPrint("accModel!.usrName!.text,  ${accModel!.usrName!.text}");
    debugPrint("accModel!.pwCon!.text ${accModel!.pwCon!.text}");

    accModel!.apiProvider = Provider.of<ApiProvider>(accModel!.getBuildCt!, listen: false);
    debugPrint("re-init accModel!.apiProvider");
    final jsn = await accModel!.apiProvider!.getSdk.api.keyring.importAccount(
      accModel!.apiProvider!.getKeyring, 
      keyType: accModel!.keyType!, 
      key: accModel!.key!.text,   
      name: accModel!.usrName!.text, 
      password: accModel!.pwCon!.text
    );

    debugPrint("importAcc json $jsn");

    await accModel!.apiProvider!.getSdk.api.keyring.addAccount(
      accModel!.apiProvider!.getKeyring, 
      keyType: accModel!.keyType!,
      acc: jsn!,
      password: accModel!.pwCon!.text
    ).then((value) {
      debugPrint("addAccount ${value.name}");
      keyPairData = value;
      accModel!.apiProvider!.getKeyring.setCurrent(value);
    
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      accModel!.apiProvider!.notifyListeners();
      
    });

  }
  
  /// Second Action
  Future<void> importProcess() async {
    debugPrint("importProcess");
    try {

      changeStatus("IMPORTING ACCOUNT", avg: "1/3");

      await importAcc();
      // .then( (KeyPairData? value){
      //   debugPrint("Finish import ${value!.name}");
      // });

      changeStatus("CONNECT TO SELENDRA NETWORK", avg: "2/3");
      animationModel!.animationController!.forward(from: 0.2);

      await connectNetwork();

    } catch (e) {
      debugPrint("error importProcess $e");
      await DialogComponents().dialogCustom(context: accModel!.getBuildCt);
    }
  }

  /// Last Action
  Future<void> connectNetwork() async {
    debugPrint("connectNetwork");

    accModel!.apiProvider = Provider.of<ApiProvider>(accModel!.getBuildCt!, listen: false);
    
    accModel!.apiProvider!.getKeyring.setCurrent(keyPairData!);

    String mnemonic = (await accModel!.apiProvider!.getSdk.api.keyring.getDecryptedSeed(accModel!.apiProvider!.getKeyring, accModel!.apiProvider!.getKeyring.current, accModel!.pwCon!.text))!.seed!;
    debugPrint("mnemonic $mnemonic");
    // final resPk = await accModel!.apiProvider!.getPrivateKey(mnemonic);
    
    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network

    await accModel!.apiProvider!.connectSELNode(context: accModel!.getBuildCt, funcName: "account").then((value) async {

      await accModel!.apiProvider!.getAddressIcon();
      // Get From Account js
      // await accModel!.apiProvider!.getCurrentAccount(context: accModel!.getBuildCt);

      // await ContractProvider().extractAddress(resPk);

      // final res = await accModel!.apiProvider!.encryptPrivateKey(resPk, accModel!.pwCon!.text);
      
      // await StorageServices.writeSecure(DbKey.private, res);

      // Store PIN 6 Digit
      await StorageServices.writeSecure(DbKey.pin, accModel!.pwCon!.text);

      changeStatus("GETTING READY", avg: "2/3");
      animationModel!.animationController!.forward(from: 0.5);

      // if(!mounted) return;
      await Provider.of<ContractProvider>(accModel!.getBuildCt!, listen: false).getEtherAddr();

      // if(!mounted) return;
      await accModel!.apiProvider!.queryBtcData(accModel!.getBuildCt!, mnemonic, accModel!.pwCon!.text);

      animationModel!.animationController!.forward(from: 8);
      changeStatus("DONE", avg: "3/3");

      // ContractsBalance().getAllAssetBalance();

      // await Future.delayed(const Duration(milliseconds: 3), (){});

      // if(!mounted) return;
      Navigator.pushAndRemoveUntil(
        accModel!.getBuildCt!, 
        Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
        ModalRoute.withName('/')
      );
    }); 
  }
  
  void onSubmit() async {

    debugPrint('animationModel!.enable ${animationModel!.enable}');
    
    // if (value!.isNotEmpty){
    //   await importProcess(importAcc);
    // }
    if (animationModel!.enable == true){

      if (animationModel!.isAddNew == true){

        dialogLoading(accModel!.getBuildCt!);
        // await addNewAcc().then((value) {
          
        //   // Close Dialog Loading
        //   Navigator.pop(context);

        //   Navigator.pop(context, value);
        // });
      } else {

        Navigator.push(
          accModel!.getBuildCt!, 
          Transition(
            child: DataLoading(initStateData: initStateData, importAnimationAccModel: animationModel,),
            transitionEffect: TransitionEffect.RIGHT_TO_LEFT
          )
        );
      }

    } else {
      await DialogComponents().dialogCustom(
        context: accModel!.getBuildCt!, 
        titles: "Oops", 
        contents: "Your seed is invalid.\nPlease try again!",
        btn2: MyGradientButton(
          textButton: "OK",
          textColor: AppColors.lowWhite,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          action: () async {
            Navigator.pop(accModel!.getBuildCt!);
          },
        )
      );
    }
  }

  void changeStatus(String? status, {String? avg}){
    
    animationModel!.average = avg;
    animationModel!.value = animationModel!.value! + 0.333;
    animationModel!.loadingMgs = status;
  }

  /// For Data Loading Screen 
  void initStateData(TickerProvider tickerProvider, Function mySetState){

    animationModel!.animationController = AnimationController(vsync: tickerProvider, duration: const Duration(seconds: 2));

    animationModel!.loadingMgs = "LOADING...";
    
    animationModel!.animation = Tween(
      begin: 0.0, end: 1.0
    ).animate(animationModel!.animationController!);  

    animationModel!.animationController!.addListener(() {
      if (kDebugMode) {
        debugPrint("animationModel!.animationController!.value ${animationModel!.animationController!.value}");
      }
      if (animationModel!.animationController!.value >= 0.15 && animationModel!.animationController!.value <= 0.19) {
        
        animationModel!.value = animationModel!.animationController!.value;
        animationModel!.animationController!.stop();

      } 

      else if (animationModel!.animationController!.value >= 0.40 && animationModel!.animationController!.value <= 0.49) {
        
        animationModel!.value = animationModel!.animationController!.value;
        animationModel!.animationController!.stop();
      }

      else if (animationModel!.animationController!.value >= 0.75 && animationModel!.animationController!.value <= 0.79) {
        
        animationModel!.value = animationModel!.animationController!.value;
        animationModel!.animationController!.stop();
      }

      mySetState();

    });

    // importAcc();
    importProcess();
    // importJson();
  }
}