import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/createKey_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/main/verify_key/body_verify_key.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:bip39/bip39.dart' as bip39;

class VerifyPassphrase extends StatefulWidget {

  final CreateKeyModel? createKeyModel;
  
  VerifyPassphrase({this.createKeyModel});

  @override
  State<VerifyPassphrase> createState() => _VerifyPassphraseState();
}

class _VerifyPassphraseState extends State<VerifyPassphrase> {

  void remove3Seeds() {

    widget.createKeyModel!.missingSeeds = [];
    widget.createKeyModel!.tmpThreeNum = [];

    // Add Origin Three Number To tmpThreeNum
    widget.createKeyModel!.threeNum!.forEach((element) {
      widget.createKeyModel!.tmpThreeNum!.addAll({element});
    });


    // Add Origin lsSeeds To tmpThreeNum
    widget.createKeyModel!.lsSeeds!.forEach((element) {
      widget.createKeyModel!.missingSeeds.add(element);
    });

    print("widget.createKeyModel!.lsSeeds! ${widget.createKeyModel!.lsSeeds!}");

    // Replace match index with Empty
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![0])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![1])] = "";
    widget.createKeyModel!.missingSeeds[int.parse(widget.createKeyModel!.tmpThreeNum![2])] = "";

    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    setState(() { });
  }

  @override
  void initState() {
    remove3Seeds();
    super.initState();
  }

  void onTap(index, rmIndex){
    print("index $index");
    for(int i = 0; i < widget.createKeyModel!.missingSeeds.length; i++){
      if (widget.createKeyModel!.missingSeeds[i] == ""){
        widget.createKeyModel!.missingSeeds[i] = widget.createKeyModel!.lsSeeds![index];
        break;
      }
    }
    print("widget.createKeyModel!.missingSeeds[index] ${widget.createKeyModel!.missingSeeds[index]}");
    widget.createKeyModel!.tmpSeed = widget.createKeyModel!.missingSeeds.join(" ");
    widget.createKeyModel!.tmpThreeNum!.removeAt(rmIndex);
    setState(() { });
  }
  
  Future<void> verifySeeds() async {
    print("verifySeeds");
    dynamic res;
    ApiProvider api = await Provider.of<ApiProvider>(context, listen: false);
    try {
      res = await api.validateMnemonic(widget.createKeyModel!.missingSeeds.join(" "));
      print("res $res");
      if (res == true){

        dialogLoading(context);

        dynamic _json = await api.apiKeyring.importAccount(
          api.getKeyring,
          keyType: KeyType.mnemonic,
          key: widget.createKeyModel!.lsSeeds!.join(" "),
          name: "User",
          password: widget.createKeyModel!.passCode, 
        );
        
        await api.apiKeyring.addAccount(
          api.getKeyring,
          keyType: KeyType.mnemonic,
          acc: _json,
          password: widget.createKeyModel!.passCode,
        );

        await importAccountNAsset(api);

        await DialogComponents().dialogCustom(
          context: context,
          contents: "You have successfully create your account.",
          textButton: "Complete",
          image: Image.asset("assets/icons/success.png")
        );

        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/'));
      }
    } catch (e) {
      if (ApiProvider().isDebug == false) print("Error validateMnemonic $e");
    }
    return res;
  }
  
  Future<void> importAccountNAsset(ApiProvider _api) async {

    final _resPk = await _api.getPrivateKey(widget.createKeyModel!.lsSeeds!.join(" "));

    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network
    await _api.connectPolNon(context: context).then((value) async {

      await _api.getAddressIcon();
      // Get From Account js
      await _api.getCurrentAccount();

      await ContractProvider().extractAddress(_resPk);

      final _res = await _api.encryptPrivateKey(_resPk, widget.createKeyModel!.passCode);
      
      await StorageServices().writeSecure(DbKey.private, _res);

      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      await _api.queryBtcData(context, widget.createKeyModel!.lsSeeds!.join(" "), widget.createKeyModel!.passCode);

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
