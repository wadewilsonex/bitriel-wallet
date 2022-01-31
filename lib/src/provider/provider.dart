import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

class ContractsBalance {
  
  /// The function get all asset information 
  Future<void> getAllAssetBalance({@required BuildContext? context, bool? isRefresh}) async {

    final contractProvider = Provider.of<ContractProvider>(context!, listen: false);
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    // final btcAddr = await StorageServices.fetchData('bech32');

    // if (btcAddr != null) Provider.of<ApiProvider>(context, listen: false).setBtcAddr(btcAddr.toString());

    // await contractProvider.setSavedList().then((value) async {

    //   print("setSavedList $value");

      // await getSavedContractToken();
      // await getEtherSavedContractToken();
//1
      // await contractProvider.kgoTokenWallet();
      await contractProvider.selTokenWallet();
      await contractProvider.selv2TokenWallet();

      await contractProvider.ethWallet();
      await contractProvider.bnbWallet();

      // await Attendance().getAttBalance(context: context); // Disable For Mainnet
//2
      // This Method Is Also Request Polkadot Contract
      await apiProvider.getBtcBalance(context: context);
//4
      /// Fetch and Fill Market Price Into Asset
      await Provider.of<MarketProvider>(context, listen: false).fetchTokenMarketPrice(context);

      // await isBtcContain(context: context);

      // Sort After MarketPrice Filled Into Asset
      await contractProvider.sortAsset();

      contractProvider.setReady();
      
      /* --------------After Fetch Contract Balance Need To Save To Storage Again-------------- */
      await StorageServices.storeAssetData(context);
      
    // });
  }


  Future<void> isBtcContain({@required BuildContext? context}) async {
    final res = await StorageServices.fetchData('bech32');

    if (res != null) {
      Provider.of<ApiProvider>(context!, listen: false).isBtcAvailable('contain', context: context);

      Provider.of<ApiProvider>(context, listen: false).setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      // await Provider.of<ApiProvider>(context, listen: false).getBtcBalance(res.toString(), context: context);
    }
  }

  Future<void> refetchContractBalance({@required BuildContext? context}) async {

    final conProvider = Provider.of<ContractProvider>(context!, listen: false);
    dynamic balance;
    
    // for (int i = 0; i< conProvider.sortListContract.length; i++){
    //   balance = 0;
    //   print("conProvider.sortListContract[i] ${conProvider.sortListContract[i].symbol} ${conProvider.sortListContract[i].org}");
    //   if (conProvider.sortListContract[i].org == "ERC-20"){
    //     balance = await conProvider.queryEther(conProvider.sortListContract[i].address!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
    //   } else if (conProvider.sortListContract[i].org == "BEP-20") {
    //     print("BEP-20 ${conProvider.sortListContract[i].address.toString()}");
    //     if (conProvider.sortListContract[i].symbol == "KGO"){
    //       // balance = await conProvider.getKgo.getTokenBalance(EthereumAddress.fromHex(conProvider.ethAdd));;
    //     } else {
    //       balance = await conProvider.query(conProvider.sortListContract[i].address!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
    //     }
    //   } else if (conProvider.sortListContract[i].symbol == 'BNB') {
    //     await conProvider.bnbWallet();
    //   } else if (conProvider.sortListContract[i].symbol == 'DOT'){
    //     await apiProvider.subscribeDotBalance(context: context);
    //   } else if (conProvider.sortListContract[i].symbol == 'BTC') {
    //     await apiProvider.getBtcBalance(context: context);
    //   }
    //   print("Balance ${balance.toString()}");
    // }
    conProvider.addedContract.forEach((element) async {
      if (element.org == "ERC-20"){
        balance = await conProvider.queryEther(element.address!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
      } else {
        balance = await conProvider.query(element.address!, 'balanceOf', [EthereumAddress.fromHex(conProvider.ethAdd)]);
      }
      element.balance = Fmt.bigIntToDouble(
        balance[0] as BigInt,
        int.parse(element.chainDecimal.toString()),
      ).toString();
    });

    await Provider.of<ContractProvider>(context, listen: false).sortAsset();

    await StorageServices.storeAssetData(context);

    // if (network == 'Ethereum'){
      
    //   symbol = await queryEther(contractAddr, 'symbol', []);
    //   name = await queryEther(contractAddr, 'name', []);
    //   decimal = await queryEther(contractAddr, 'decimals', []);

    //   tmpBalance = Fmt.bigIntToDouble(
    //     balance[0] as BigInt,
    //     int.parse(decimal[0].toString()),
    //   ).toString(); 

    // } else if (network == 'Binance Smart Chain'){

    //   symbol = await query(contractAddr, 'symbol', []);
    //   name = await query(contractAddr, 'name', []);
    //   decimal = await query(contractAddr, 'decimals', []);
    //   balance = await query(contractAddr, 'balanceOf', [EthereumAddress.fromHex(ethAdd)]);

    //   tmpBalance = Fmt.bigIntToDouble(
    //     balance[0] as BigInt,
    //     int.parse(decimal[0].toString()),
    //   ).toString();
      
    // }
    return null;
  }
}