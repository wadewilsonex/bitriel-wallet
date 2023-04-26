import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/trending_market_list_c.dart';
import 'package:wallet_apps/src/models/trendingcoin_m.dart';

class CoinTrending extends StatelessWidget {

  final List<CoinsModel>? trendingCoin;

  const CoinTrending({Key? key, this.trendingCoin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      itemCount: trendingCoin!.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TrendMarketList(trendingCoin: trendingCoin, index: index)
          ],
        );
      }
    );
  }

  
}
