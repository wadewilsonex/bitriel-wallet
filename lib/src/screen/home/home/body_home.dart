import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/list_coin_market_c.dart';
import 'package:wallet_apps/src/components/scroll_speed.dart';
import 'package:wallet_apps/src/models/image_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_apps/src/models/list_market_coin_m.dart';
import 'package:wallet_apps/src/provider/app_p.dart';
import 'package:wallet_apps/src/provider/newarticle_p.dart';
import 'package:wallet_apps/src/screen/home/home/article/article_news.dart';
import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/swap.dart';
import 'package:wallet_apps/src/screen/home/wallet/wallet.dart';
import 'package:wallet_apps/src/screen/home/events/events.dart';
import 'package:wallet_apps/src/screen/home/discover/discover.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/home/home/market/coin_market.dart';
import 'package:wallet_apps/src/screen/home/setting/setting.dart';

Widget homePageBody(
  BuildContext context,
  {
    final bool? isTrx,
    final List<Map<String, dynamic>>? imgList,
    final HomePageModel? homePageModel,
    final bool? pushReplacement,
    final Function(int index)? onPageChanged,
    final Function? downloadAsset,
  }
) {
  
  return Scaffold(
    appBar: homePageModel!.activeIndex != 4 ? defaultAppBar(
      context: context,
      homePageModel: homePageModel,
      pushReplacement: pushReplacement
    ) : null,
    body: UpgradeAlert(
      upgrader: Upgrader(
        dialogStyle: UpgradeDialogStyle.material,
        durationUntilAlertAgain: const Duration(minutes: 30)
      ),
      child: PageView(
        physics: const CustomPageViewScrollPhysics(),
        controller: homePageModel.pageController,
        onPageChanged: onPageChanged,
        children: [
          
          homePageModel.activeIndex == 0 ? DiscoverPage(homePageModel: homePageModel) : Container(),
    
          homePageModel.activeIndex == 1 ? WalletPage(isTrx: isTrx, homePageModel: homePageModel,) : Container(),
          
          Text("hello"),
    
          // DefaultTabController(
          //   length: 2,
          //   child: NestedScrollView(
          //     floatHeaderSlivers: true,
          //     headerSliverBuilder: (context, innerBoxIsScrolled) => [
                
          //       SliverOverlapAbsorber(
          //         handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          //         sliver: SliverSafeArea(
          //           top: false,
          //           sliver: SliverAppBar(
          //             toolbarHeight: 300,
          //             pinned: true,
          //             floating: true,
          //             snap: true,
          //             title: _menu(context),
          //             centerTitle: true,
          //             automaticallyImplyLeading: false,
          //             bottom: TabBar(
          //               labelColor: hexaCodeToColor(AppColors.primaryColor),
          //               unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
          //               indicatorColor: hexaCodeToColor(AppColors.primaryColor),
          //               labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'NotoSans'),
          //               unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'NotoSans'),
          //               tabs: const [
    
          //                 Tab(
          //                   text: "Markets",
          //                 ),
    
          //                 Tab(
          //                   text: "News",
          //                 ),
    
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
              
          //     body: Text("hello")//_coinMenuCategory(),
          //   ),
          // ),
          // SwapPage(),
          homePageModel.activeIndex == 3 ? const FindEvent() : Container(),
    
          homePageModel.activeIndex == 4 ? const SettingPage() : Container(),
          // const NFT(),
        ],
      ),
    ),
    bottomNavigationBar: myBottomAppBar(
      context,
      index: homePageModel.activeIndex,
      onIndexChanged: onPageChanged,
    ),
  );
}

// Widget _carouselAds(BuildContext context, int activeIndex) {
//   return Container(
//     margin: const EdgeInsets.only(top: paddingSize + 10, bottom: 10),
//     child: Column(
//       children: [
  
//         Container(
//           margin: const EdgeInsets.only(bottom: 10),
//           child: CarouselSlider(
//             options: CarouselOptions(
//               viewportFraction: 1,  
//               aspectRatio: 29 / 10,
//               autoPlay: true,
//               enableInfiniteScroll: true,
//               enlargeCenterPage: true,
//               scrollDirection: Axis.horizontal,
//               onPageChanged: homePageModel!.onAdsCarouselChanged,
//             ),
//             items: imgList!
//               .map((item) => GestureDetector(
//                 onTap: () {
//                   // Navigator.push(
//                   //   context, 
//                   //   Transition(child: AdsWebView(item: item), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
//                   // );
//                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (BuildContext context) => const HomePage(activePage: 3,)), (route) => false);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: paddingSize),
//                   child: Card(
//                     margin: EdgeInsets.zero,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(8.0),
//                       ),
//                       child: 
//                       // item['asset'].contains("https") ? Image.network(
//                       //   item['asset'],
//                       //   fit: BoxFit.fill,
//                       //   width: MediaQuery.of(context).size.width,
//                       // )
//                       // : 
//                       Image.asset(
//                         item['asset'], 
//                         fit: BoxFit.cover,
//                         width: MediaQuery.of(context).size.width,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//             .toList(),
//           ),
//         ),
  
//         AnimatedSmoothIndicator(
//           activeIndex: activeIndex,
//           count: imgList!.length,
//           effect: SlideEffect(
//             radius: 5.0,
//             dotWidth: 20.0.sp,
//             dotHeight: 7.0.sp,
//             paintStyle: PaintingStyle.fill,
//             dotColor: hexaCodeToColor(AppColors.greyColor).withOpacity(0.36),
//             activeDotColor: hexaCodeToColor(AppColors.secondary),
//           ), 
          
//         ),
//       ],
//     ),
//   );
// }

Widget _menu(BuildContext context) {
    return Column(
      children: [
        
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Flex(
            mainAxisSize: MainAxisSize.max,
            direction: Axis.horizontal,
            children: [
              
              Expanded(
                child: myMenuItem(
                  context, 
                  title: "Swap",
                  asset: "/icons/swap-coin.png",
                  colorHex: "#0D6BA6",
                  action: () async {
                    Navigator.push(
                      context,
                      Transition(child: const SwapPage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    );
                    // await showBarModalBottomSheet(
                    //   context: context,
                    //   backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                    //   shape: const RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.vertical(
                    //       top: Radius.circular(25.0),
                    //     ),
                    //   ),
                    //   builder: (context) => Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: const [
                    //       SwapMethod(),
                    //     ],
                    //   ),
                    // );
                  },
                ),
              ),

              const SizedBox(width: 10,),
              
              Expanded(
                child: myMenuItem(
                  context, 
                  title: "Staking",
                  asset: "/icons/stake-coin.png",
                  colorHex: "#151644",
                  action: () {
                    underContstuctionAnimationDailog(context: context);
                  },
                ),
              ),
            ],
          ),
        ),
    
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Flex(
            mainAxisSize: MainAxisSize.max,
            direction: Axis.horizontal,
            children: [
              
              Expanded(
                child: myMenuItem(
                  context, 
                  title: "Buy",
                  asset: "/icons/buy-coin.png",
                  colorHex: "#F29F05",
                  action: () async {
                    underContstuctionAnimationDailog(context: context);
                  },
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: myMenuItem(
                  context, 
                  title: "Bitriel NFTs",
                  asset: "/icons/nft_polygon.png",
                  colorHex: "#192E3C",
                  action: () {

                    underContstuctionAnimationDailog(context: context);
                    
                    // customDialog(
                    //   context, 
                    //   'Access to Bitriel NFTs?', 
                    //   'Bitriel NFTs is still in development!!!\n\n You can play around with Bitriel NFTs page.',
                    //   txtButton: "Cancel",
                    //   btn2: MyFlatButton(
                    //     height: 60,
                    //     edgeMargin: const EdgeInsets.symmetric(horizontal: paddingSize),
                    //     isTransparent: false,
                    //     buttonColor: AppColors.whiteHexaColor,
                    //     textColor: AppColors.redColor,
                    //     textButton: "Confirm",
                    //     isBorder: true,
                    //     action: () {
                    //       // Close pop up dialog
                    //       Navigator.pop(context);

                    //       Navigator.push(
                    //         context, 
                    //         Transition(
                    //           child: const NFTMarketPlace(),
                    //           transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                    //         )
                    //       );
                    //     }
                    //   )
                    // );
                    
                  },
                ),
              ),

            ],
          ),
        )
      ],
    );
}

Widget _coinMenuCategory() {

  return TabBarView(
    children: [

      Consumer<MarketProvider>(
        builder: (context, marketProvider, widget) {
          return SingleChildScrollView(
            child: Column(
              children: [
                          
                if (marketProvider.ls7Market.isNotEmpty)
                coinMarket(context, marketProvider.ls7Market,),
          
                if (marketProvider.ls7Market.isNotEmpty)
                InkWell(
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
                      builder: (context) => _viewAllCoin(context, marketProvider.lsMarketLimit)
                    );
                  },
                  child: const MyText(
                    text: "View All",
                    hexaColor: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  )
                )
                          
                else if(marketProvider.ls7Market.isEmpty) 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingSize),
                  child: Column(
                    children: [
                                
                      Lottie.asset(
                        "assets/animation/search_empty.json",
                        repeat: true,
                        reverse: true,
                        width: 70.w,
                      ),
                                
                      const MyText(
                        text: "Opps, Something went wrong!", 
                        fontSize: 17, 
                        fontWeight: FontWeight.w600,
                        pTop: 20,
                      )          
                    ],
                  ),
                ),
                
                AppUtils.discliamerShortText(context),
              ],
            ),
          );
        }
      ),

      Consumer<ArticleProvider>(
        builder: (context, articleProvider, widget) {
          return SingleChildScrollView(
            child: Column(
              children: [
                          
                if (articleProvider.tenArticleQueried!.isNotEmpty)
                articleNews(context, articleProvider.tenArticleQueried!,)
                          
                else if(articleProvider.articleQueried!.isEmpty) 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(  
                    children: [
                                
                      Lottie.asset(
                        "assets/animation/search_empty.json",
                        repeat: true,
                        reverse: true,
                        width: 70.w,
                      ),
                      
                                
                      const MyText(
                        text: "Opps, Something went wrong!", 
                        fontSize: 17, 
                        fontWeight: FontWeight.w600,
                        pTop: 20,
                      )
                                
                    ],
                  ),
                ),
                
                AppUtils.discliamerShortText(context),
              ],
            ),
          );
        }
      ),
    ],
  );
}


Widget _viewAllCoin(BuildContext context, List<ListMetketCoinModel>? lsMarketCoin){
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
        shrinkWrap: true,
        // children: lsMarketCoin!.map((e) {
        //   return CoinMarketList(listCoinMarket: lsMarketCoin, index: lsMarketCoin.indexOf(e));
        // }).toList(),
        itemCount: lsMarketCoin!.length,
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