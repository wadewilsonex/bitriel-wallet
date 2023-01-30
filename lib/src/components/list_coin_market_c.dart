import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/list_market_coin_m.dart';

class CoinMarketList extends StatelessWidget {

  final List<ListMetketCoinModel>? listCoinMarket;
  final int? index;

  const CoinMarketList({Key? key,
    @required this.listCoinMarket,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          // Asset Logo
          listCoinMarket![index!].image != null ? SizedBox(
            height: 10.w,
            width: 10.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(listCoinMarket![index!].image!)
            ),
          ) 
          : ClipRRect(
            child: SizedBox(
              height: 10.w,
              width: 10.w,
            ),
          ),
      
          // Asset Name
          SizedBox(width: 2.w),
          SizedBox(
            width: 30.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                Row( 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    
                    MyText(
                      text: listCoinMarket![index!].symbol != null ? '${listCoinMarket![index!].symbol!.toUpperCase()} ' : '',
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      hexaColor: isDarkMode
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                      textAlign: TextAlign.start,
                    ),

                  ],
                ),
          
                MyText(
                  top: 4.0,
                  text: listCoinMarket![index!].name ?? '',
                  fontSize: 14,
                  hexaColor: AppColors.tokenNameColor
                )
              ],
            ),
          ),
          
          const Spacer(),

          // Total Amount
          MyText(
            fontSize: 15,
            // width: double.infinity,
            text: "\$${double.parse("${listCoinMarket![index!].currentPrice}".replaceAll(",", "")).toStringAsFixed(5)}",//!.length > 7 ? double.parse(scModel!.balance!).toStringAsFixed(4) : scModel!.balance,
            textAlign: TextAlign.right,
            fontWeight: FontWeight.w600,
            hexaColor: isDarkMode
              ? AppColors.whiteColorHexa
              : AppColors.textColor,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }
}