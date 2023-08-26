import 'package:bitriel_wallet/index.dart';

class AccountManagementImpl extends AccountMangementUC {

  /// Index 0 = json data of seeds with pin and user name.
  /// 
  /// Index 1 = KeyPairData
  List<dynamic>? importData;

  String? _pk;

  // List<UnverifySeed> unverifyList = [];

  List<UnverifySeed> unVerifyAccount = [];

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> addAndImport(BuildContext context, String seed, String pin) async {

    dialogLoading(context);

    try {

      SDKProvider sdkProvider = Provider.of<SDKProvider>(context, listen: false);

      // 1. Import And Add Account
      importData = await sdkProvider.importSeed(seed, pin);

      await sdkProvider.getSdkImpl.getWalletSdk.webView!.evalJavascript("wallets.getPrivateKey('$seed')").then((value) async {
        
        _pk = await sdkProvider.getSdkImpl.encryptPrivateKey(value!, pin);
        
        await SecureStorage.writeData(key: DbKey.private, encodeValue: _pk);

        // Use Seed to query EVM address
        // And Use PrivateKey to extract BTC native address.
        await sdkProvider.getSdkImpl.queryAddress(seed, value!, pin);
        
      });

    } catch (e) {
      
      // Close Dialog Loading
      Navigator.pop(context);
      debugPrint("Error addAndImport $e");
    }
  }

  @override
  Future<void> verifyLaterData(SDKProvider? sdkProvider, bool status) async {

    print("verifyLaterData");
    print("_pk $_pk");

    unVerifyAccount.clear();

    await SecureStorageImpl().readSecure(DbKey.privateList)!.then((value) async {

      if(value.isNotEmpty){
        unVerifyAccount = UnverifySeed().fromJsonDb(List<Map<String, dynamic>>.from(jsonDecode(value)));
      }

    });

    unVerifyAccount.add(UnverifySeed.init(
      address: sdkProvider!.getSdkImpl.getSELAddress,
      status: status, 
      ethAddress: sdkProvider.getSdkImpl.evmAddress,
      btcAddress: sdkProvider.getSdkImpl.btcAddress,// conProvider!.listContract[_apiProvider!.btcIndex].address
      pubKey: _pk
    ));

    await SecureStorageImpl().writeSecureList(DbKey.privateList, jsonEncode(UnverifySeed().unverifyListToJson(unVerifyAccount)));
  
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    sdkProvider.notifyListeners();

    print("unVerifyAccount ${unVerifyAccount.length}");

  }

  Future<void> fetchAccount() async {

    await SecureStorage.readData(key: DbKey.privateList).then((value) {

      print("fetchAccount bart $value");
      unVerifyAccount = UnverifySeed().fromJsonDb( List<Map<String, dynamic>>.from(json.decode(value!)) );

      // Reverse Index Acconts
      // unVerifyAccount = unVerifyAccount.reversed.toList();
    });
    
  }

  Future<void> accNavigation(BuildContext context, bool isMultiAcc) async {

    if (isMultiAcc == true) {

      Navigator.popUntil(context, ModalRoute.withName("/${BitrielRouter.multiAccRoute}"));
    }
    else {
      Navigator.pushNamedAndRemoveUntil(context, "/${BitrielRouter.homeRoute}", (route) => false);
    }
  }
}