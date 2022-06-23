import 'dart:math';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/atd_pro.dart';
import 'package:web3dart/web3dart.dart';

class ContractsBalance extends ChangeNotifier {
  
  /// The function get all asset information 
  Future<void> getAllAssetBalance({@required BuildContext? context, bool? isRefresh}) async {
    try {

      final contractProvider = Provider.of<ContractProvider>(context!, listen: false);
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      final btcAddr = await StorageServices.fetchData('bech32');

      // if (btcAddr != null) Provider.of<ApiProvider>(context, listen: fals e).setBtcAddr(btcAddr.toString());

      // await contractProvider.setSavedList().then((value) async {

        await contractProvider.selTokenWallet(context);
        print("selTokenWallet");
        await contractProvider.selv2TokenWallet(context);
        print("selv2TokenWallet");
        await contractProvider.ethWallet();
        print("ethWallet");
        await contractProvider.bnbWallet();
        print("bnbWallet");
        await contractProvider.kgoTokenWallet();
        print("kgoTokenWallet");

        //()[0]['current_price'].toString();
        print(await Provider.of<MarketProvider>(context, listen: false).queryCoinFromMarket('ethereum'));
        print(await Provider.of<MarketProvider>(context, listen: false).queryCoinFromMarket('usdt'));
        // if (apiProvider.isMainnet) await contractProvider.getBep20Balance(contractIndex: 8);

        // if(apiProvider.isMainnet == false) await Attendance().getAttBalance(context: context); // Disable For Mainnet
        // This Method Is Also Request Polkadot Contract
        await apiProvider.getBtcBalance(context: context);
        print("getBtcBalance");
  //4
        /// Fetch and Fill Market Price Into Asset
        await Provider.of<MarketProvider>(context, listen: false).fetchTokenMarketPrice(context);
        
        /// Fetch main balance
        await apiProvider.totalBalance(context: context);
        // await isBtcContain(context: context);
        // await apiProvider.connectSELNode(context: context);
        // await apiProvider.connectSELNode(context: context);
        // await apiProvider.getSelNativeChainDecimal(context: context);
        // await apiProvider.subSELNativeBalance(context: context);

        // Sort After MarketPrice Filled Into Asset
        await contractProvider.sortAsset();

        contractProvider.setReady();
        
        /* --------------After Fetch Contract Balance Need To Save To Storage Again-------------- */
        await StorageServices.storeAssetData(context);
        
      // });
    } catch (e) {
      if (ApiProvider().isDebug == true) print("error getAllAssetBalance $e");
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
    print("refetchContractBalance");
    try {

      final conProvider = Provider.of<ContractProvider>(context!, listen: false);
      final api = Provider.of<ApiProvider>(context, listen: false);
      dynamic balance;
      
      api.connectSELNode(context: context).then((value) async {
        
        await api.getSelNativeChainDecimal(context: context);
      });

      print("Start query web3 contract");

      conProvider.ethWallet();
      conProvider.bnbWallet();

      for (int i = 0; i < conProvider.listContract.length; i++){
        if ((api.isMainnet ? conProvider.listContract[i].contract : conProvider.listContract[i].contractTest) != ""){
          print("Symbol ${conProvider.listContract[i].symbol}");
          print("org ${conProvider.listContract[i].org}");
          print("contractTest ${api.isMainnet ? conProvider.listContract[i].contract! : conProvider.listContract[i].contractTest!}");
        
          if (conProvider.listContract[i].org == "ERC-20"){
            balance = await conProvider.queryEther(api.isMainnet ? conProvider.listContract[i].contract! : conProvider.listContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
            print("balance erc $balance");
            conProvider.listContract[i].balance = (balance[0] / BigInt.from(pow(10, 18))).toString();
            // Fmt.bigIntToDouble(
            //   BigInt.parse(balance[0].toString().replaceAll(",", "")),
            //   int.parse(decimal),
            // ).toString();
            print("finish erc-20");
          } else if (conProvider.listContract[i].org == "BEP-20") {
            // decimal = await conProvider.get
            balance = await conProvider.query(api.isMainnet ? conProvider.listContract[i].contract! : conProvider.listContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
            conProvider.listContract[i].balance = (balance[0] / BigInt.from(pow(10, 18))).toString();
            // Fmt.bigIntToDouble(
            //   balance[0].toString().contains(",") ? BigInt.parse(balance[0].toString().replaceAll(",", "")) : balance[0].toString() as BigInt,
            //   int.parse(decimal),
            // ).toString();
            print("finish bep-20");
          }
        }
      }

      print(conProvider.addedContract.length);
      for (int i = 0; i < conProvider.addedContract.length; i++){
        print("hello");
        print((api.isMainnet ? conProvider.addedContract[i].contract : conProvider.addedContract[i].contractTest) != "");
        if ( (api.isMainnet ? conProvider.addedContract[i].contract : conProvider.addedContract[i].contractTest) != ""){
          print("Symbol ${conProvider.addedContract[i].symbol}");
          print("org ${conProvider.addedContract[i].org}");
          print("contractTest ${api.isMainnet ? conProvider.addedContract[i].contract! : conProvider.addedContract[i].contractTest!}");
        
          if (conProvider.addedContract[i].org == "ERC-20"){
            balance = await conProvider.queryEther(api.isMainnet ? conProvider.addedContract[i].contract! : conProvider.addedContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
            print("balance erc $balance");
            conProvider.addedContract[i].balance = (balance[0] / BigInt.from(pow(10, 18))).toString();
            // Fmt.bigIntToDouble(
            //   BigInt.parse(balance[0].toString().replaceAll(",", "")),
            //   int.parse(decimal),
            // ).toString();
            print("finish erc-20");
          } else if (conProvider.addedContract[i].org == "BEP-20") {
            // decimal = await conProvider.get
            balance = await conProvider.query(api.isMainnet ? conProvider.addedContract[i].contract! : conProvider.addedContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
            conProvider.addedContract[i].balance = (balance[0] / BigInt.from(pow(10, 18))).toString();
            // Fmt.bigIntToDouble(
            //   balance[0].toString().contains(",") ? BigInt.parse(balance[0].toString().replaceAll(",", "")) : balance[0].toString() as BigInt,
            //   int.parse(decimal),
            // ).toString();
            print("finish bep-20");
          }
        }
      }

      await Provider.of<ContractProvider>(context, listen: false).sortAsset();

      await StorageServices.storeAssetData(context);
      
    } catch (e) {
      if (ApiProvider().isDebug == true) print("error refetchContractBalance $e ");
    }

  }
}