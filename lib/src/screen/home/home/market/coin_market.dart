import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/list_coin_market_c.dart';
import 'package:wallet_apps/src/models/list_market_coin_m.dart';

class CoinMarket extends StatelessWidget {

  final List<ListMetketCoinModel>? lsMarketCoin;

  const CoinMarket({Key? key, this.lsMarketCoin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      itemCount: 7,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CoinMarketList(listCoinMarket: lsMarketCoin, index: index),

          if (index == 6) InkWell(
              onTap: () async{
                await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    builder: (context) => _viewAllCoin(context)
                );
              },
              child: const MyText(
                text: "View All",
                hexaColor: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              )
            ),

          ],
        );
      }
    );
  }

  Widget _viewAllCoin(BuildContext context){
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return ListView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
          itemCount: lsMarketCoin!.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CoinMarketList(listCoinMarket: lsMarketCoin, index: index),
              ],
            );
          }
        );
      }
    );
  }
}