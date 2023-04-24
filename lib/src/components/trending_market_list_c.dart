// import 'package:animate_do/animate_do.dart';
// import 'package:lottie/lottie.dart';
// import 'package:wallet_apps/index.dart';
// import 'package:wallet_apps/src/api/api_chart.dart';
// import 'package:wallet_apps/src/components/chart/chart_m.dart';
// import 'package:wallet_apps/src/models/trendingcoin_m.dart';

// class TrendMarketList extends StatefulWidget {

//   final List<CoinsModel>? trendingCoin;
//   final int? index;

//   const TrendMarketList({Key? key,
//     @required this.trendingCoin,
//     @required this.index,
//   }) : super(key: key);

//   @override
//   State<TrendMarketList> createState() => _TrendMarketListState();
// }

// class _TrendMarketListState extends State<TrendMarketList> {
  
//   String periodID = '1DAY';

//   Future<void> queryAssetChart(int index, StateSetter modalSetState) async {
//     await ApiCalls().getChart(
//       widget.trendingCoin![index].item.symbol!, 
//       'usd', periodID, 
//       DateTime.now().subtract(const Duration(days: 6)), 
//       DateTime.now()
//     ).then((value) {
//       setState(() {
//         widget.trendingCoin![index].item.chart = value;
//       });

//       modalSetState( () {});
      
//     });
//   }
  
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
    
//     return InkWell(
//       onTap: () {

//         showModalBottomSheet(
//           backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical( 
//               top: Radius.circular(25.0),
//             ),
//           ),
//           context: context,
//           builder: (BuildContext context) {
//             return StatefulBuilder(
//               builder: (context, modalSetState){

//                 widget.trendingCoin![widget.index!].item.chart == null ? queryAssetChart(widget.index!, modalSetState) : null;

//                 return Padding(
//                   padding: const EdgeInsets.all(paddingSize),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [

//                       if (widget.trendingCoin![widget.index!].item.chart == null)
//                       const CircularProgressIndicator()
                      
//                       else if (widget.trendingCoin![widget.index!].item.chart!.isNotEmpty)
//                       FadeInUp(
//                         duration: const Duration(milliseconds: 500),
//                         child: Container(
//                           child: chartAsset(
//                             Image.network(
//                               widget.trendingCoin![widget.index!].item.large!,
//                               fit: BoxFit.fill,
//                             ),
//                             widget.trendingCoin![widget.index!].item.name!,
//                             widget.trendingCoin![widget.index!].item.symbol!,
//                             'USD',
//                             widget.trendingCoin![widget.index!].item.priceBtc != null ?
//                             double.parse("${widget.trendingCoin![widget.index!].item.priceBtc}".replaceAll(",", "")).toStringAsFixed(5)
//                             : "0.00",
//                             widget.trendingCoin![widget.index!].item.chart!,
//                           ),
//                         ),
//                       )
//                       else Center(
//                         child: Column(
//                           children: [

//                             Lottie.asset(
//                               "assets/animation/search_empty.json",
//                               repeat: true,
//                               reverse: true,
//                               width: 70.w,
//                             ),

//                             const Padding(
//                               padding: EdgeInsets.all(paddingSize),
//                               child: MyText(text: "Sorry, there are no results for this coin!", fontSize: 18, fontWeight: FontWeight.w600,),
//                             )
//                           ],
//                         ),
//                       ),

//                     ],
//                   ),
//                 );
//               }
//             );
//           }
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         child: Row(
//           children: <Widget>[
        
//             // Asset Logo
//             widget.trendingCoin![widget.index!].item.large != null ? SizedBox(
//               height: 45,
//               width: 45,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(50),
//                 child: Container(color: Colors.white, child: Image.network(widget.trendingCoin![widget.index!].item.large!, fit: BoxFit.fill,))
//               ),
//             ) 
//             : const ClipRRect(
//               child: SizedBox(
//                 height: 45,
//                 width: 45,
//               ),
//             ),
        
//             // Asset Name
//             SizedBox(width: 2.w),
//             SizedBox(
//               width: MediaQuery.of(context).size.width / 2,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
            
//                   Row( 
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
                      
//                       MyText(
//                         text: widget.trendingCoin![widget.index!].item.symbol != null ? '${widget.trendingCoin![widget.index!].item.symbol!.toUpperCase()} ' : '',
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         hexaColor: isDarkMode
//                           ? AppColors.whiteColorHexa
//                           : AppColors.textColor,
//                         textAlign: TextAlign.start,
//                       ),
    
//                     ],
//                   ),
            
//                   MyText(
//                     top: 4.0,
//                     text: widget.trendingCoin![widget.index!].item.name ?? '',
//                     fontSize: 15,
//                     hexaColor: AppColors.tokenNameColor,
//                     textAlign: TextAlign.start,
//                   )
//                 ],
//               ),
//             ),
            
//             const Spacer(),
    
//             // Total Amount
            
//             widget.trendingCoin![widget.index!].item.priceBtc != null ?
//             MyText(
//               fontSize: 17,
//               text: "\$${double.parse("${widget.trendingCoin![widget.index!].item.priceBtc}".replaceAll(",", "")).toStringAsFixed(5)}",
//               textAlign: TextAlign.right,
//               fontWeight: FontWeight.w600,
//               hexaColor: isDarkMode
//                 ? AppColors.whiteColorHexa
//                 : AppColors.textColor,
//               overflow: TextOverflow.fade,
//             )
//             :
//             MyText(
//               fontSize: 17,
//               text: "\$0.00",
//               textAlign: TextAlign.right,
//               fontWeight: FontWeight.w600,
//               hexaColor: isDarkMode
//                 ? AppColors.whiteColorHexa
//                 : AppColors.textColor,
//               overflow: TextOverflow.fade,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }