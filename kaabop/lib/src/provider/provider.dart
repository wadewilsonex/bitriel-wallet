import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/atd_pro.dart';

class ContractsBalance {
  
  /// The function get all asset information 
  Future<void> getAllAssetBalance({@required BuildContext context, bool isRefresh}) async {
    final contractProvider = Provider.of<ContractProvider>(context, listen: false);
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    final btcAddr = await StorageServices.fetchData('bech32');
    if (btcAddr != null) Provider.of<ApiProvider>(context, listen: false).setBtcAddr(btcAddr.toString());

    await contractProvider.setSavedList().then((value) async {

      // If Data Already Exist
      if (value){

        // Add BTC, DOT, SEL testnet Into listContract of Contract Provider's Property
        contractProvider.addApiProviderProperty(apiProvider);

        // Sort After MarketPrice Filled Into Asset
        await Provider.of<ContractProvider>(context, listen: false).sortAsset();

        contractProvider.setReady();
      }
      
      // await contractProvider.setupNetwork();

      await apiProvider.connectNode();

      // await getSavedContractToken();
      // await getEtherSavedContractToken();

      await contractProvider.kgoTokenWallet();
      await contractProvider.selTokenWallet();
      await contractProvider.selv2TokenWallet();

      await contractProvider.ethWallet();
      await contractProvider.bnbWallet();

      await Attendance().checkBalanceAdd(context: context);

      // This Method Is Also Request Polkadot Contract
      await apiProvider.getBtcBalance(btcAddr, context: context);
      // await apiProvider.getDotChainDecimal(context: context);

      // await isBtcContain(context: context);
      
      /// Fetch and Fill Market Into Asset and Also Short Market Data By Price
      await Provider.of<MarketProvider>(context, listen: false).fetchTokenMarketPrice(context);

      // Add BTC, DOT, SEL testnet Into listContract of Contract Provider's Property
      // contractProvider.addApiProviderProperty(apiProvider);
      // await Provider.of<MarketProvider>(context, listen: false).fetchTokenMarketPrice(context);

      // Sort After MarketPrice Filled Into Asset
      await Provider.of<ContractProvider>(context, listen: false).sortAsset();

      contractProvider.setReady();
      
      /* --------------After Fetch Contract Balance Need To Save To Storage Again-------------- */
      await StorageServices.storeAssetData(context);
      
    });
  }


  Future<void> isBtcContain({@required BuildContext context}) async {
    final res = await StorageServices.fetchData('bech32');

    if (res != null) {
      Provider.of<ApiProvider>(context, listen: false)
          .isBtcAvailable('contain');

      Provider.of<ApiProvider>(context, listen: false)
          .setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      await Provider.of<ApiProvider>(context, listen: false)
          .getBtcBalance(res.toString(), context: context);
    }
  }
}