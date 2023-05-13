import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/list_coin_market_c.dart';
import 'package:wallet_apps/data/models/list_market_coin_m.dart';

Widget coinMarket(BuildContext context, List<ListMetketCoinModel>? lsMarketCoin) {

  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: paddingSize),
    shrinkWrap: true,
    children: lsMarketCoin!.map( (e) {
      return CoinMarketList(listCoinMarket: lsMarketCoin, index: lsMarketCoin.indexOf(e));
    }).toList(),
  );
}
