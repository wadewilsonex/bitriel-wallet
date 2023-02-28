import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/trendingcoin_m.dart';

class TrendMarketList extends StatelessWidget {

  final List<CoinsModel>? trendingCoin;
  final int? index;

  const TrendMarketList({Key? key,
    @required this.trendingCoin,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
      
          // Asset Logo
          trendingCoin![index!].item.large != null ? SizedBox(
            height: 45,
            width: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(color: Colors.white, child: Image.network(trendingCoin![index!].item.large!, fit: BoxFit.fill,))
            ),
          ) 
          : const ClipRRect(
            child: SizedBox(
              height: 45,
              width: 45,
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
                      text: trendingCoin![index!].item.symbol != null ? '${trendingCoin![index!].item.symbol!.toUpperCase()} ' : '',
                      fontSize: 18,
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
                  text: trendingCoin![index!].item.name ?? '',
                  fontSize: 14,
                  hexaColor: AppColors.tokenNameColor
                )
              ],
            ),
          ),
          
          const Spacer(),

          // Total Amount
          MyText(
            fontSize: 17,
            // width: double.infinity,
            text: "\$${double.parse("${trendingCoin![index!].item.priceBtc}".replaceAll(",", "")).toStringAsFixed(5)}",//!.length > 7 ? double.parse(scModel!.balance!).toStringAsFixed(4) : scModel!.balance,
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