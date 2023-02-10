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
            height: 10.w,
            width: 10.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(color: Colors.white, child: Image.network(trendingCoin![index!].item.large!))
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
                      text: trendingCoin![index!].item.symbol != null ? '${trendingCoin![index!].item.symbol!.toUpperCase()} ' : '',
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
                  text: trendingCoin![index!].item.name ?? '',
                  fontSize: 14,
                  hexaColor: AppColors.tokenNameColor
                )
              ],
            ),
          ),
          
          // Market Price
          // Expanded(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
      
          //       trendingCoin![index!].item.priceBtc != null ?
          //       MyText(
          //         text: '\$ ${trendingCoin![index!].item.priceBtc}',
          //         fontSize: 15,
          //         fontWeight: FontWeight.w600,
          //         hexaColor: AppColors.textColor
          //       )
          //       : const MyText(
          //         text: '...',
          //         fontSize: 15,
          //         fontWeight: FontWeight.w600,
          //         hexaColor: AppColors.textColor
          //       ),
      
          //       // scModel!.change24h != null ? Container(
          //       //   margin: const EdgeInsets.only(top: 4),
          //       //   child: Row(
          //       //     crossAxisAlignment: CrossAxisAlignment.center,
          //       //     children: [
          //       //       scModel!.change24h != null && scModel!.change24h != ''
          //       //       ? Flexible(
          //       //         child: Row(
          //       //           children: [

          //       //             if (scModel!.change24h != "0")
          //       //             MyText(
          //       //               text: double.parse(scModel!.change24h!).isNegative ? '(${scModel!.change24h}%)' : '(+${scModel!.change24h!}%)',
          //       //               fontSize: 14,
          //       //               fontWeight: FontWeight.w500,
          //       //               hexaColor: double.parse(scModel!.change24h!).isNegative
          //       //                 ? '#FF0000'
          //       //                 : isDarkMode ? '#00FF00' : '#66CD00',
          //       //             )
                            
          //       //             else MyText(
          //       //               text: '(${scModel!.change24h}%)',
          //       //               fontSize: 14,
          //       //               fontWeight: FontWeight.w500,
          //       //               hexaColor: AppColors.greyCode
          //       //               // double.parse(scModel!.change24h!).isNegative
          //       //               //   ? AppColors.greyCode
          //       //               //   : isDarkMode ? '#00FF00' : '#66CD00',
          //       //             ),

          //       //             if (scModel!.change24h != "0")
          //       //             double.parse(scModel!.change24h!).isNegative ? Icon(UniconsLine.chart_down, color: Colors.red, size: 18.sp) : Icon(UniconsLine.arrow_growth, color: Colors.green, size: 18.sp),
          //       //           ],
          //       //         ),
          //       //       )
          //       //       : Container(),
                      
          //       //       // double.parse(scModel!.change24h!).isNegative
          //       //     ],
          //       //   ),
          //       // )
          //       // : Container(),
          //     ],
          //   ),
          // ),

          const Spacer(),

          // Total Amount
          MyText(
            fontSize: 15,
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