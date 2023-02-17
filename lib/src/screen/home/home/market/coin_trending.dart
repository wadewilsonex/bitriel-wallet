import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/trending_market_list_c.dart';
import 'package:wallet_apps/src/models/trendingcoin_m.dart';

class CoinTrending extends StatelessWidget {

  final List<CoinsModel>? trendingCoin;

  const CoinTrending({Key? key, this.trendingCoin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      itemCount: trendingCoin!.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trendingCoin == null) const CircularProgressIndicator()

            else if (trendingCoin!.isNotEmpty)
            TrendMarketList(trendingCoin: trendingCoin, index: index)

            else Center(
              child: Column(
              children: [

                SizedBox(height: 7.h),

                Lottie.asset(
                "assets/animation/search_empty.json",
                repeat: true,
                reverse: true,
                width: 70.w,
                ),

                const MyText(text: "Opps, Something went wrong!", fontSize: 17, fontWeight: FontWeight.w600,)

                ],
              ),
            )


          ],
        );
      }
    );
  }
}