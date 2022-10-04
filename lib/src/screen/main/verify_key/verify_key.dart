import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/createkey_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/verify_key/body_verify_key.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';

class VerifyPassphrase extends StatefulWidget {

  final CreateKeyModel? createKeyModel;
  
  const VerifyPassphrase({Key? key, this.createKeyModel}) : super(key: key);

  @override
  State<VerifyPassphrase> createState() => VerifyPassphraseState();
}

class VerifyPassphraseState extends State<VerifyPassphrase> {

  void remove3Seeds() {

    widget.createKeyModel!.missingSeeds = [];
    widget.createKeyModel!.tmpThreeNum = [];

    // Add Origin Three Number To tmpThreeNum
    for (var element in widget.createKeyModel!.threeNum!) {
      widget.createKeyModel!.tmpThreeNum!.addAll({element});
    }

    // Add Origin lsSeeds To tmpThreeNum
    for (var element in widget.createKeyModel!.lsSeeds!) {
      widget.createKeyModel!.missingSeeds.add(element);
    }

    // Replace match index with Empty
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![0])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![1])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![2])] = "";

    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    setState(() { });
  }

  @override
  void initState() {
    AppServices.noInternetConnection(context: context);
    remove3Seeds();
    super.initState();
  }

  @override
  void dispose() {
    
    widget.createKeyModel!.missingSeeds = [];
    widget.createKeyModel!.tmpThreeNum = [];
    // widget.createKeyModel!.empty();

    super.dispose();
  }

  void onTap(index, rmIndex){
    for(int i = 0; i < widget.createKeyModel!.missingSeeds.length; i++){
      if (widget.createKeyModel!.missingSeeds[i] == ""){
        widget.createKeyModel!.missingSeeds[i] = widget.createKeyModel!.lsSeeds![index];
        break;
      }
    }
    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    widget.createKeyModel!.tmpThreeNum!.removeAt(rmIndex);
    setState(() { });
  }
  
  Future<void> verifySeeds() async {
    dynamic res;
    ApiProvider api = Provider.of<ApiProvider>(context, listen: false);
    try {
      res = await api.validateMnemonic(widget.createKeyModel!.missingSeeds.join(" "));
      if (res == true){ 

        if(!mounted) return;

        dialogLoading(context, content: "Fetching and adding asset\n\nThis processing may take a bit longer\nPlease wait a moment");

        dynamic json = await api.apiKeyring.importAccount(
          api.getKeyring,
          keyType: KeyType.mnemonic,
          key: widget.createKeyModel!.lsSeeds!.join(" "),
          name: "User",
          password: widget.createKeyModel!.passCode, 
        );
        
        await api.apiKeyring.addAccount(
          api.getKeyring,
          keyType: KeyType.mnemonic,
          acc: json,
          password: widget.createKeyModel!.passCode,
        );

        await importAccountNAsset(api);
        
        await DialogComponents().dialogCustom(
          context: context,
          contents: "You have successfully create your account.",
          textButton: "Complete",
          image: Image.asset("assets/icons/success.png", width: 20.w, height: 10.h),
          btn2: MyGradientButton(
            edgeMargin: const EdgeInsets.only(left: 20, right: 20),
            textButton: "Complete",
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            action: () async {  
              Navigator.pop(context);
            },
          )
        );

        if(!mounted) return;
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
      }
      else{
        await DialogComponents().dialogCustom(
          context: context,
          titles: "Opps",
          contents: "Invalid seeds spot. Please try again!",
          textButton: "Close",
          btn2: MyGradientButton(
            edgeMargin: const EdgeInsets.only(left: 20, right: 20),
            textButton: "Close",
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            action: () async {  
              Navigator.pop(context);
            },
          )
        );
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error validateMnemonic $e");
        }
      }
    }
    return res;
  }
  
  Future<void> importAccountNAsset(ApiProvider api) async {

    final resPk = await api.getPrivateKey(widget.createKeyModel!.lsSeeds!.join(" "));

    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network
    await api.connectSELNode(context: context).then((value) async {

      await api.getAddressIcon();
      // Get From Account js
      await api.getCurrentAccount(context: context);

      await ContractProvider().extractAddress(resPk);

      final res = await api.encryptPrivateKey(resPk, widget.createKeyModel!.passCode);
      
      // Store Private Key with Encrypt With PassCode Or PIN.
      await StorageServices().writeSecure(DbKey.private, res);

      // Store PIN 6 Digit
      await StorageServices().writeSecure(DbKey.passcode, widget.createKeyModel!.passCode);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await api.queryBtcData(context, widget.createKeyModel!.lsSeeds!.join(" "), widget.createKeyModel!.passCode);

      await ContractsBalance().getAllAssetBalance(context: context);
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return VerifyPassphraseBody(
      createKeyModel: widget.createKeyModel,
      verify: verifySeeds,
      onTap: onTap,
      remove3Seeds: remove3Seeds
    );
  }
}
