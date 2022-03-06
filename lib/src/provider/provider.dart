import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/atd_pro.dart';
import 'package:web3dart/web3dart.dart';

class ContractsBalance {
  
  /// The function get all asset information 
  Future<void> getAllAssetBalance({@required BuildContext? context, bool? isRefresh}) async {

    final contractProvider = Provider.of<ContractProvider>(context!, listen: false);
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    // final btcAddr = await StorageServices.fetchData('bech32');

    // if (btcAddr != null) Provider.of<ApiProvider>(context, listen: false).setBtcAddr(btcAddr.toString());

    // await contractProvider.setSavedList().then((value) async {

      await contractProvider.selTokenWallet(context);
      await contractProvider.selv2TokenWallet(context);
      await contractProvider.ethWallet();
      await contractProvider.bnbWallet();
      await contractProvider.kgoTokenWallet();

      if(apiProvider.isMainnet == false) await Attendance().getAttBalance(context: context); // Disable For Mainnet
      // This Method Is Also Request Polkadot Contract
      await apiProvider.getBtcBalance(context: context);
//4
      /// Fetch and Fill Market Price Into Asset
      await Provider.of<MarketProvider>(context, listen: false).fetchTokenMarketPrice(context);
      
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
      
      for (int i = 0; i < conProvider.listContract.length; i++){
        if ((api.isMainnet ? conProvider.listContract[i].contract : conProvider.listContract[i].contractTest) != ""){
          if (conProvider.listContract[i].org == "ERC-20"){
            balance = await conProvider.queryEther(api.isMainnet ? conProvider.listContract[i].contract! : conProvider.listContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);

            conProvider.listContract[i].balance = Fmt.bigIntToDouble(
              balance[0] as BigInt,
              int.parse(conProvider.listContract[i].chainDecimal.toString()),
            ).toString();
          } else if (conProvider.listContract[i].org == "BEP-20") {
            balance = await conProvider.query(api.isMainnet ? conProvider.listContract[i].contract! : conProvider.listContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
            conProvider.listContract[i].balance = Fmt.bigIntToDouble(
              balance[0] as BigInt,
              int.parse(conProvider.listContract[i].chainDecimal.toString()),
            ).toString();
          }
        }
      }
      
      for (int i = 0; i < conProvider.addedContract.length; i++){
        if ( (api.isMainnet ? conProvider.addedContract[i].contract : conProvider.addedContract[i].contractTest) != "" ){//i != api.selNativeIndex && i != api.dotIndex && conProvider.listContract[i].symbol != "KGO"){
          if (conProvider.addedContract[i].org == "ERC-20"){
            balance = await conProvider.queryEther(api.isMainnet ? conProvider.addedContract[i].contract! : conProvider.addedContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);

            conProvider.addedContract[i].balance = Fmt.bigIntToDouble(
              balance[0] as BigInt,
              int.parse(conProvider.addedContract[i].chainDecimal.toString()),
            ).toString();

          } else if (conProvider.addedContract[i].org == "BEP-20") {
            
            balance = await conProvider.query(api.isMainnet ? conProvider.addedContract[i].contract! : conProvider.addedContract[i].contractTest!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
            conProvider.addedContract[i].balance = Fmt.bigIntToDouble(
              balance[0] as BigInt,
              int.parse(conProvider.addedContract[i].chainDecimal.toString()),
            ).toString();
          }
        }
      }

      // conProvider.addedContract.forEach((element) async {
      //   if (element.org == "ERC-20"){
      //     balance = await conProvider.queryEther(element.address!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
      //   } else {
      //     balance = await conProvider.query(element.address!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
      //   }
      //   element.balance = Fmt.bigIntToDouble(
      //     balance[0] as BigInt,
      //     int.parse(element.chainDecimal.toString()),
      //   ).toString();
      // });

      await Provider.of<ContractProvider>(context, listen: false).sortAsset();

      await StorageServices.storeAssetData(context);
      
    } catch (e) {
      if (ApiProvider().isDebug == false) print("error refetchContractBalance $e ");
    }

  }
}