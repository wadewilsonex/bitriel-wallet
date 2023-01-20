import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/list_coin_market_c.dart';
import 'package:wallet_apps/src/models/list_market_coin_m.dart';

class CoinMarket extends StatelessWidget {

  final List<ListMetketCoinModel>? lsMarketCoin;

  const CoinMarket({Key? key, this.lsMarketCoin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        if (lsMarketCoin == null) const CircularProgressIndicator()

        else if (lsMarketCoin!.isNotEmpty) 
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
          itemCount: 8,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CoinMarketList(listCoinMarket: lsMarketCoin, index: index),

                if (index == 7) TextButton(
                  onPressed: () {

                  },
                  child: const MyText(
                    text: "View All",
                    hexaColor: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ],
            );
          }
        )

        else const Center(
          child: MyText(
            text: "No Market",
          ),
        )

      ],
    );
  }
}