import 'package:bitriel_wallet/index.dart';

class AccountManagementImpl extends AccountMangementUC {

  /// Index 0 = json data of seeds with pin and user name.
  /// 
  /// Index 1 = KeyPairData
  List<dynamic>? importData;

  String? _pk;

  List<UnverifySeed> unverifyList = [];

  List<UnverifySeed> unVerifyAccount = [];

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> addAndImport(SDKProvider sdkProvider, BuildContext context, String seed, String pin) async {

    dialogLoading(context);

    try {

      // 1. Import And Add Account
      importData = await sdkProvider.importSeed(seed, pin);

      await sdkProvider.getSdkImpl.getWalletSdk.webView!.evalJavascript("wallets.getPrivateKey('$seed')").then((value) async {
        
        _pk = value;
        await SecureStorage.writeData(key: DbKey.private, encodeValue: value);
      });
       
      // Extract private from seed
      // _pk = await sdkProvider.getSdkImpl.getDecrypedSeed(importData![1], pin);

      // print("_pk $_pk");

      // final res = await sdkProvider.getSdkImpl.encryptPrivateKey(_pk!.seed!, pin);

      // await SecureStorage.writeData(key: DbKey.private, encodeValue: res);

      // Use Seed to query EVM address
      // And Use PrivateKey to extract BTC native address.
      await sdkProvider.getSdkImpl.queryAddress(seed, _pk!, pin);

    }catch (e) {
      
      // Close Dialog Loading
      Navigator.pop(context);
      debugPrint("Error addAndImport $e");
    }
  }

  @override
  Future<void> verifyLaterData(SDKProvider? sdkProvider, bool status) async {

    await SecureStorageImpl().readSecure(DbKey.privateList)!.then((value) async {

      if(value.isNotEmpty){
        unverifyList = UnverifySeed().fromJsonDb(List<Map<String, dynamic>>.from(jsonDecode(value)));
      }

    });

    unverifyList.add(UnverifySeed.init(
      address: sdkProvider!.getSdkImpl.getSELAddress,
      status: status, 
      ethAddress: sdkProvider.getSdkImpl.evmAddress,
      btcAddress: sdkProvider.getSdkImpl.btcAddress// conProvider!.listContract[_apiProvider!.btcIndex].address
    ));

    await SecureStorageImpl().writeSecureList(DbKey.privateList, jsonEncode(UnverifySeed().unverifyListToJson(unverifyList)));
  }

  Future<void> fetchAccount() async {

    await SecureStorage.readData(key: DbKey.privateList).then((value) {
      unVerifyAccount = UnverifySeed().fromJsonDb( List<Map<String, dynamic>>.from(json.decode(value!)) );

      // Reverse Index Acconts
      unVerifyAccount = unVerifyAccount.reversed.toList();
    });
    
  }

  Future<void> accNavigation(BuildContext context, bool isMultiAcc) async {

    if (isMultiAcc == true) {
      Navigator.popUntil(context, ModalRoute.withName("/${BitrielRouter.multiAccRoute}"));

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      Provider.of<SDKProvider>(context, listen: false).notifyListeners();
    }
    else {
      Navigator.pushNamedAndRemoveUntil(context, "/${BitrielRouter.homeRoute}", (route) => false);
    }
  }
}