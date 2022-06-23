import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class PortfolioServices {
  
  Future<void> setPortfolio(BuildContext context) async {

    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    walletProvider.clearPortfolio();
    // await marketProvider.fetchTokenMarketPrice(context);

    // if (marketProvider.sortDataMarket.isEmpty){

    // if (api.nativeM.balance == null) {
    //   walletProvider.addAvaibleToken({
    //     'symbol': api.nativeM.symbol!,
    //     'balance': '0',
    //   });
    // } else {
    //   walletProvider.addAvaibleToken({
    //     'symbol': api.nativeM.symbol!,
    //     'balance': api.nativeM.balance!.replaceAll(RegExp(','), ''),
    //   });
    // }

    // if (contract.kmpi.isContain) {
    //   walletProvider.addAvaibleToken({
    //     'symbol': contract.kmpi.symbol,
    //     'balance': contract.kmpi.balance ?? '0',
    //   });
    // }

    // if (contract.atd.isContain) {
    //   walletProvider.addAvaibleToken({
    //     'symbol': contract.atd.symbol,
    //     'balance': contract.atd.balance ?? '0',
    //   });
    // }

    // walletProvider.addAvaibleToken({
    //   'symbol': contract.bnbNative.symbol,
    //   'balance': contract.bnbNative.balance ?? '0',
    // });

    // if (api.btc.isContain) {
    //   walletProvider.addAvaibleToken({
    //     'symbol': api.btc.symbol,
    //     'balance': api.btc.balance ?? '0',
    //   });
    // }

    // if (api.dot.balance == null) {
    //   walletProvider.addAvaibleToken({
    //     'symbol': api.dot.symbol,
    //     'balance': '0',
    //   });
    // } else {
    //   walletProvider.addAvaibleToken({
    //     'symbol': api.dot.symbol,
    //     'balance': api.dot.balance.replaceAll(RegExp(','), '') ?? '0',
    //   });
    // }
    // }
    // else {
    //   marketProvider.sortDataMarket.forEach((element) {
    //     walletProvider.addAvaibleToken({
    //       'symbol': '${element['symbol'].toUpperCase()}',
    //       'balance': '${element['market_cap_rank']}',
    //     });
    //   });
    // }

    // walletProvider.addAvaibleToken({
    //   'symbol': '${contract.bscNative.symbol} (BEP-20)',
    //   'balance': contract.bscNative.balance ?? '0',
    // });

    // walletProvider.addAvaibleToken({
    //   'symbol': '${contract.kgoNative.symbol} (BEP-20)',
    //   'balance': contract.kgoNative.balance ?? '0',
    // });

    // walletProvider.addAvaibleToken({
    //   'symbol': '${contract.etherNative.symbol} (BEP-20)',
    //   'balance': contract.etherNative.balance ?? '0',
    // });

    // if (contract.token.isNotEmpty) {
    //   for (int i = 0; i < contract.token.length; i++) {
    //     walletProvider.addAvaibleToken({
    //       'symbol': '${contract.token[i].symbol} (BEP-20)',
    //       'balance': contract.token[i].balance ?? '0',
    //     });
    //   }
    // }

    // walletProvider.getPortfolio();
  }
}
