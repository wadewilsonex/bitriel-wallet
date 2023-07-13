import 'dart:convert';
import 'package:bitriel_wallet/index.dart';
// ignore: depend_on_referenced_packages
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_bitcoin/flutter_bitcoin.dart';

class BitrielSDKImpl implements BitrielSDKUseCase{
  
  final SdkRepoImpl _sdkRepoImpl = SdkRepoImpl();

  final Web3RepoImpl _web3repoImpl = Web3RepoImpl();

  final HttpRequestImpl _httpRequestImpl = HttpRequestImpl();

  String get getSELAddress => _sdkRepoImpl.getKeyring.current.address!;

  Keyring get getKeyring => _sdkRepoImpl.getKeyring;
  WalletSDK get getWalletSdk => _sdkRepoImpl.getWalletSdk;

  Web3Client get getBscClient => _web3repoImpl.getBscClient;
  Web3Client get getEthClient => _web3repoImpl.getEthClient;

  //
  //
  // ///////////////////////////////////////////////////////////////////////////
  /* ---------------------------------- Substrate ------------------------------ */
  // ///////////////////////////////////////////////////////////////////////////
  //
  //
  
  //  = 'assets/js/main.js'
  /// 2 
  @override
  Future<void> initBitrielSDK({required String jsFilePath, int nodeIndex = 0}) async {
    await rootBundle.loadString(jsFilePath).then((js) async {
      // 2.1. Init Keyring
      await _sdkRepoImpl.initBitrielSDK(jsCode: js);
    });
    
    await _web3repoImpl.web3Init();
  }

  @override
  void dynamicNetwork() async {
    // Asign Network
    // await StorageServices.fetchData(DbKey.sldNetwork).then((nw) async {
    //   /// Get Endpoint form Local DB
    //   /// 
    //   if (nw != null){

    //     selNetwork = nw;
    //   } else {
    //     selNetwork = isMainnet ? AppConfig.networkList[0].wsUrlMN : AppConfig.networkList[0].wsUrlTN;

    //   }

    //   await StorageServices.storeData(selNetwork, DbKey.sldNetwork);
      
    // });
  }

  @override
  Future<bool> validateMnemonic(String seed) async { 
    return await _sdkRepoImpl.getWalletSdk.api.keyring.checkMnemonicValid(seed);
  }

  /// 3. Import and Add Account
  /// 
  /// Return Type Of List<dynamic> will return value
  /// 
  /// Index 0 = json data of seeds with pin and user name.
  /// 
  /// Index 1 = KeyPairData
  @override
  Future<List<dynamic>> importSeed(String seed, {KeyType keyType = KeyType.mnemonic, String? name = "Username", required String? pin}) async {

    // 3.1
    final jsn = await _sdkRepoImpl.getWalletSdk.api.keyring.importAccount(
      _sdkRepoImpl.getKeyring, 
      keyType: keyType, 
      key: seed, 
      name: name!, 
      password: pin!
    );

    // 3.2
    final keyPair = await _sdkRepoImpl.getWalletSdk.api.keyring.addAccount(
      _sdkRepoImpl.getKeyring, 
      keyType: keyType, 
      acc: jsn!, 
      password: pin
    );

    return [jsn, keyPair];

  }
  
  @override
  /// 4. Get Private Key
  /// 
  /// 4.1 We use private to backup seeds.
  Future<SeedBackupData?> getPrivateKeyFromSeeds(KeyPairData keyPair, String pin) async {
    return await _sdkRepoImpl.getWalletSdk.api.keyring.getDecryptedSeed(
      _sdkRepoImpl.getKeyring, 
      _sdkRepoImpl.getKeyring.current, 
      pin
    );
  }

  /// 5. Query Address from
  /// 5.1 BSC, BTC
  Future<void> queryAddress(String seed, String pk, String pin) async {
    // ignore: use_build_context_synchronously
    // await Provider.of<ContractProvider>(context, listen: false).extractAddress(_pk!);
    await extractEvmAddress(pk);
    await queryBtcData(seed, pin);

  }
  
  @override
  Future<String> generateSeed() async {
    return ( await _sdkRepoImpl.getWalletSdk.api.keyring.generateMnemonic(_sdkRepoImpl.getKeyring.ss58!) ).mnemonic!;
  }
  
  // 
  // 
  // ///////////////////////////////////////////////////////////////////////////
  /* ------------------------------------ Web3 ------------------------------ */
  // ///////////////////////////////////////////////////////////////////////////
  // 
  // 
  
  String? evmAddress;
  String? btcAddress;

  /// Extract Evm Address 0xa..
  @override
  Future<void> extractEvmAddress(String pk) async {
    final EthPrivateKey privateKey = EthPrivateKey(Uint8List.fromList(pk.codeUnits));
    evmAddress = privateKey.address.toString();
  }
  

  // Extract BTC Address 13..
  Future<void> queryBtcData(String seeds, String pin) async {
    
    try {
      final seed = bip39.mnemonicToSeed(seeds);
      final hdWallet = HDWallet.fromSeed(seed);
      
      btcAddress = hdWallet.address!;
      
      final keyPair = ECPair.fromWIF(hdWallet.wif!);

      final bech32Address = P2WPKH(data: PaymentData(pubkey: keyPair.publicKey), network: bitcoin).data.address;
      await SecureStorage.writeData(key: DbKey.bech32, encodeValue: bech32Address);
      await SecureStorage.writeData(key: DbKey.hdWallet, encodeValue: hdWallet.address);

      final res = await _encryptPrivateKey(hdWallet.wif!, pin);

      await SecureStorage.writeData(key: DbKey.btcwif, encodeValue: res);

    //   // Provider.of<ApiProvider>(context, listen: false).isBtcAvailable('contain', context: context);

    //   // setBtcAddr(bech32Address!);
    //   // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
    //   // await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(context: context);

    //   contractPro.notifyListeners();

    } catch (e) {
      debugPrint("error queryBtcData $e");
      // await customDialog(context, 'Oops', e.toString());
    }
  }

  Future<void> getBtcBalance() async {

    int totalSatoshi = 0;
    Response res = await _httpRequestImpl.fetchAddrUxtoBTC(btcAddress!);
    
    List<dynamic> decode = json.decode(res.body);

    if (decode.isEmpty) {
        // contract.listContract[btcIndex].balance = '0';
    } else {
      for (final i in decode) {
        if (i['status']['confirmed'] == true) {
          totalSatoshi += int.parse(i['value'].toString());
        }
      }

      // contract.listContract[btcIndex].balance = (totalSatoshi / bitcoinSatFmt).toString();
    }
  }
  
  Future<String?> _encryptPrivateKey(String privateKey, String pin) async {
    final key = Encrypt.passwordToEncryptKey(pin);
    return await FlutterAesEcbPkcs5.encryptString(privateKey, key);
  }

  Future<EtherAmount> getWeb3Balance(Web3Client client, EthereumAddress addr) async {
    print("addr ${addr.hex}");
    // return await client.getBalance(addr);
    return EtherAmount.zero();
  }
  
}