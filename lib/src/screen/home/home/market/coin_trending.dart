import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/trending_market_list_c.dart';
import 'package:wallet_apps/src/models/trendingcoin_m.dart';

class CoinTrending extends StatelessWidget {

  final List<CoinsModel>? trendingCoin;

  const CoinTrending({Key? key, this.trendingCoin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        if (trendingCoin == null) const CircularProgressIndicator()

        else if (trendingCoin!.isNotEmpty) 
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
          itemCount: trendingCoin!.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return TrendMarketList(trendingCoin: trendingCoin, index: index);
          }
        )

        else const Center(
          child: MyText(
            text: "No Trending",
          ),
        )

      ],
    );
  }
}