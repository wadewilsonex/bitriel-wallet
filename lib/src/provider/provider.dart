import 'dart:math';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:web3dart/web3dart.dart';

class ContractsBalance extends ChangeNotifier {
  
  /// The function get all asset information 
  Future<void> getAllAssetBalance({@required BuildContext? context, bool? isRefresh}) async {
    try {

      final contractProvider = Provider.of<ContractProvider>(context!, listen: false);
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      final btcAddr = await StorageServices.fetchData(DbKey.bech32);
      if (btcAddr != null) Provider.of<ApiProvider>(context, listen: false).setBtcAddr(btcAddr.toString());

      // await contractProvider.setSavedList().then((value) async {

        // await contractProvider.selTokenWallet(context);
        // await contractProvider.selv2TokenWallet(context);
        await contractProvider.ethWallet();
        await contractProvider.bnbWallet();
        await contractProvider.kgoTokenWallet();

        // Attendance Token
        // if (apiProvider.isMainnet) await contractProvider.getBep20Balance(contractIndex: 8);

        // if(apiProvider.isMainnet == false) await Attendance().getAttBalance(context: context); // Disable For Mainnet
        // This Method Is Also Requeste Polkadot Contract
        await apiProvider.getBtcBalance(context: context);

        await apiProvider.connectPolNon(context: context);
        
        /// Fetch and Fill Market Price Into Asset
        await Provider.of<MarketProvider>(context, listen: false).fetchTokenMarketPrice(context);
        
        /// Fetch main balance
        await apiProvider.totalBalance(context: context);

        // Sort After MarketPrice Filled Into Asset
        await contractProvider.sortAsset();

        contractProvider.setReady();
        
        /* --------------After Fetch Contract Balance Need To Save To Storage Again-------------- */
        await StorageServices.storeAssetData(context);
        
      // });
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("error getAllAssetBalance $e");
        }
      }
    }
  }


  Future<void> isBtcContain({@required BuildContext? context}) async {
    final res = await StorageServices.fetchData(DbKey.bech32);

    if (res != null) {
      Provider.of<ApiProvider>(context!, listen: false).isBtcAvailable('contain', context: context);

      Provider.of<ApiProvider>(context, listen: false).setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      // await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(res.toString(), context: context);
    }
  }

  Future<void> refetchContractBalance({@required BuildContext? context}) async {
    try {

      final conProvider = Provider.of<ContractProvider>(context!, listen: false);
      final api = Provider.of<ApiProvider>(context, listen: false);
      dynamic balance;
      
      await api.connectSELNode(context: context).then((value) async {
        
        await api.getSelNativeChainDecimal(context: context);
      });

      if (api.isMainnet) await conProvider.getBep20Balance(contractIndex: 8);

      for (int i = 0; i < conProvider.listContract.length; i++){
        if ((api.isMainnet ? conProvider.listContract[i].contract : conProvider.listContract[i].contractTest) != ""){
          if (conProvider.listContract[i].symbol != "ATT" && conProvider.listContract[i].symbol != "SEL (v1)" && conProvider.listContract[i].symbol != "SEL (v2)"){
            // if (conProvider.listContract[i].symbol == "KGO") {
              
            // }
            if (kDebugMode) {
              print("conProvider.listContract[i].symbol ${conProvider.listContract[i].symbol}");
              print("conProvider.listContract[i].org ${conProvider.listContract[i].org}");
              print("conProvider.listContract[i].chainDecimal ${conProvider.listContract[i].chainDecimal}");
            }
            
            if (conProvider.listContract[i].org == "ERC-20"){
              balance = await conProvider.queryEther(api.isMainnet ? conProvider.listContract[i].contract! : conProvider.listContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
              conProvider.listContract[i].balance = (balance[0] / BigInt.from(pow(10, conProvider.listContract[i].chainDecimal! ))).toString();
              // Fmt.bigIntToDouble(
              //   BigInt.parse(balance[0].toString().replaceAll(",", "")),
              //   int.parse(decimal),
              // ).toString();
            } else if (conProvider.listContract[i].org == "BEP-20") {
              // decimal = await conProvider.get
              balance = await conProvider.query(api.isMainnet ? conProvider.listContract[i].contract! : conProvider.listContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
              if (kDebugMode) {
                print("balance $balance");
              }
              
              conProvider.listContract[i].balance = (balance[0] / BigInt.from(pow(10, conProvider.listContract[i].chainDecimal! ))).toString();
              // Fmt.bigIntToDouble(
              //   balance[0].toString().contains(",") ? BigInt.parse(balance[0].toString().replaceAll(",", "")) : balance[0].toString() as BigInt,
              //   int.parse(decimal),
              // ).toString();
            }
          }
          balance = [];
        }
      }

      for (int i = 0; i < conProvider.addedContract.length; i++){
        if ( (api.isMainnet ? conProvider.addedContract[i].contract : conProvider.addedContract[i].contractTest) != ""){
          if (conProvider.addedContract[i].org == "ERC-20"){
            balance = await conProvider.queryEther(api.isMainnet ? conProvider.addedContract[i].contract! : conProvider.addedContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
            conProvider.addedContract[i].balance = (balance[0] / BigInt.from(pow(10, conProvider.addedContract[i].chainDecimal! ))).toString();
            // Fmt.bigIntToDouble(
            //   BigInt.parse(balance[0].toString().replaceAll(",", "")),
            //   int.parse(decimal),
            // ).toString();
          } else if (conProvider.addedContract[i].org == "BEP-20") {
            // decimal = await conProvider.get
            balance = await conProvider.query(api.isMainnet ? conProvider.addedContract[i].contract! : conProvider.addedContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
            conProvider.addedContract[i].balance = (balance[0] / BigInt.from(pow(10, conProvider.addedContract[i].chainDecimal! ))).toString();
            // Fmt.bigIntToDouble(
            //   balance[0].toString().contains(",") ? BigInt.parse(balance[0].toString().replaceAll(",", "")) : balance[0].toString() as BigInt,
            //   int.parse(decimal),
            // ).toString();
          }
        }
      }

      await conProvider.kgoTokenWallet();
      await conProvider.ethWallet();
      await conProvider.bnbWallet();

      await Provider.of<ContractProvider>(context, listen: false).sortAsset();

      await StorageServices.storeAssetData(context);
      
    } catch (e) {
      if (ApiProvider().isDebug == true){
        if (kDebugMode) {
          print("error refetchContractBalance $e ");
        }
      }
    }

  }
  
}