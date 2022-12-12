import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ImportJson extends StatefulWidget {

  final String? password;
  final Map<String, dynamic>? json;
  final InAppWebViewController? webViewController;

  const ImportJson({Key? key, this.json, this.password, this.webViewController}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImportJsonState();
  }
}

class ImportJsonState extends State<ImportJson> {

  final ImportAccModel _importAccModel = ImportAccModel();

  String? loadingMgs;

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;
  ApiProvider? _api;

  Timer? _timer;

  @override
  void initState() {
    
    loadingMgs = "Importing wallet";
    _api = Provider.of<ApiProvider>(context, listen: false);
    importAccFromJson();
    AppServices.noInternetConnection(context: context);
    
    super.initState();
  }

  Future<bool>? validateJson(String mnemonic) async {
    dynamic res;
    try {
      
      res = Provider.of<ApiProvider>(context, listen: false).apiKeyring;
      enable = res;
      
      setState((){});
    } catch (e) {

      if (kDebugMode) {
        print("Error validateMnemonic $e");
      }
    }
    return res;
  }

  /// EVM JSON
  Future<void> importAccFromJson() async {

    // Execute JS
    await widget.webViewController!.callAsyncJavaScript(functionBody: "return await decrypt.decrypt(${widget.json!['user']['encrypted']}, '${widget.password}')").then((value) async {
      
      if (value!.value != null){

        changeStatus("Importing account");
        final jsn = await _api!.apiKeyring.importAccount(
          _api!.getKeyring, 
          keyType: KeyType.mnemonic, 
          key: value.value, 
          name: 'User', 
          password: widget.password!
        );

        await _api!.apiKeyring.addAccount(
          _api!.getKeyring, 
          keyType: KeyType.mnemonic, 
          acc: jsn!,
          password: widget.password!
        );

        changeStatus("Fetching Assets");
        await importAccountNAsset(_api!, value.value);

        if(!mounted) return;
        Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: const HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), 
          ModalRoute.withName('/')
        );
        
      }

    });
    
  }
  
  Future<void> importAccountNAsset(ApiProvider api, String mnemonic) async {
    
    final resPk = await api.getPrivateKey(mnemonic);
    
    /// Cannot connect Both Network On the Same time
    /// 
    /// It will be wrong data of that each connection. 
    /// 
    /// This Function Connect Polkadot Network And then Connect Selendra Network
    await api.connectSELNode(context: context, funcName: "account").then((value) async {

      await api.getAddressIcon();
      // Get From Account js
      await api.getCurrentAccount(context: context);

      await ContractProvider().extractAddress(resPk);

      final res = await api.encryptPrivateKey(resPk, _importAccModel.pwCon.text);
      
      await StorageServices().writeSecure(DbKey.private, res);

      // Store PIN 6 Digit
      // await StorageServices().writeSecure(DbKey.passcode, _importAccModel.pwCon.text);

      if(!mounted) return;
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

      if(!mounted) return;
      await api.queryBtcData(context, _importAccModel.mnemonicCon.text, _importAccModel.pwCon.text);

      await ContractsBalance().getAllAssetBalance(context: context);
    }); 
  }

  void changeStatus(String? status){
    setState(() {
      loadingMgs = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loading(),

            MyText(
              top: 10,
              text: loadingMgs,
            )
          ],
        ),
      )
    );
  }
}
