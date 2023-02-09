import 'package:carousel_slider/carousel_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/circle_tab_indicator_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'package:wallet_apps/src/components/scroll_speed.dart';
import 'package:wallet_apps/src/models/image_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_apps/src/screen/home/wallet/wallet.dart';
import 'package:wallet_apps/src/screen/home/events/events.dart';
import 'package:wallet_apps/src/screen/home/discover/discover.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/home/home/market/coin_market.dart';
import 'package:wallet_apps/src/screen/home/home/market/coin_trending.dart';
import 'package:wallet_apps/src/screen/home/nft/nft_marketplace.dart/nft_marketplace.dart';
import 'package:wallet_apps/src/screen/home/setting/setting.dart';
import 'package:wallet_apps/src/screen/home/swap/swap_method/swap_method.dart';

class HomePageBody extends StatelessWidget {

  final bool? isTrx;
  final HomePageModel? homePageModel;
  final bool? pushReplacement;
  final Function(int index)? onPageChanged;
  final Function? onTapWeb;
  final Function? getReward;

  const HomePageBody({ 
    Key? key, 
    this.isTrx,
    this.homePageModel,
    this.onPageChanged,
    this.pushReplacement,
    this.onTapWeb,
    this.getReward,
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageModel!.globalKey,
      // extendBody: true,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: const Menu(),
      ),
      appBar: homePageModel!.activeIndex != 4 ? defaultAppBar(
        context: context,
        homePageModel: homePageModel,
        pushReplacement: pushReplacement
      ) : null,
      body: PageView(
        physics: const CustomPageViewScrollPhysics(),
        controller: homePageModel!.pageController,
        onPageChanged: onPageChanged,
        children: [
          
          DiscoverPage(homePageModel: homePageModel!),

          WalletPage(isTrx: isTrx, homePageModel: homePageModel,),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                // Container(
                //   height: 130,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5)
                //   ),
                //   margin: const EdgeInsets.only(left: paddingSize, right: paddingSize, top: paddingSize, bottom: 20),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(5),
                //     child: InkWell(
                //       onTap: (){
                //         Navigator.push(
                //           context,
                //           Transition(child: const MarketPlaceWebView(url: "https://booking.doformetaverse.com/", title: "Do For Metaverse",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                //         );
                //       },
                //       child: VideoPlayer(videoController!),
                //     ),
                //   ),
                // ),
                
                // _carouselAds(context, homePageModel!.adsCarouselActiveIndex),
          
                // ShowCaseWidget(
                //   builder: Builder(
                //     builder : (context) => Container()
                //   ),
                // ),
          
                const SizedBox(height: 10), 
                _menu(context),
          
                const SizedBox(height: 10), 
          
                SizedBox(
                  height: 490,
                  child: _coinMenuCategory()
                ),

                discliamerText(),

              ],
            ),
          ),

          // SwapPage(),
          const FindEvent(),

          const SettingPage(),
          // const NFT(),
        ],
      ),
      bottomNavigationBar: MyBottomAppBar(
        index: homePageModel!.activeIndex,
        onIndexChanged: onPageChanged,
      ),
    );
  }

  Widget _carouselAds(BuildContext context, int activeIndex) {
    return Container(
      margin: const EdgeInsets.only(top: paddingSize + 10, bottom: 10),
      child: Column(
        children: [
    
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,  
                aspectRatio: 29 / 10,
                autoPlay: true,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: homePageModel!.onAdsCarouselChanged,
              ),
              items: imgList
                .map((item) => GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context, 
                    //   Transition(child: AdsWebView(item: item), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    // );
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (BuildContext context) => const HomePage(activePage: 3,)), (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        child: 
                        // item['asset'].contains("https") ? Image.network(
                        //   item['asset'],
                        //   fit: BoxFit.fill,
                        //   width: MediaQuery.of(context).size.width,
                        // )
                        // : 
                        Image.asset(
                          item['asset'], 
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
            ),
          ),
    
          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: imgList.length,
            effect: SlideEffect(
              radius: 5.0,
              dotWidth: 20.0.sp,
              dotHeight: 7.0.sp,
              paintStyle: PaintingStyle.fill,
              dotColor: hexaCodeToColor(AppColors.greyColor).withOpacity(0.36),
              activeDotColor: hexaCodeToColor(AppColors.secondary),
            ), 
            
          ),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyMenuItem(
                  title: "Swap",
                  asset: "assets/icons/swap-coin.png",
                  colorHex: "#0D6BA6",
                  action: () async {
                    await showBarModalBottomSheet(
                      context: context,
                      backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical( 
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) => Column(
                        children: const [
                          SwapMethod(),
                        ],  
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: MyMenuItem(
                  title: "Staking",
                  asset: "assets/icons/stake-coin.png",
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
          padding: const EdgeInsets.symmetric(horizontal: paddingSize , vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyMenuItem(
                  title: "Buy",
                  asset: "assets/icons/buy-coin.png",
                  colorHex: "#F29F05",
                  action: () async {
                    underContstuctionAnimationDailog(context: context);
                  },
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: MyMenuItem(
                  title: "bitriel NFT",
                  asset: "assets/icons/nft_polygon.png",
                  colorHex: "#192E3C",
                  action: () {
                    Navigator.push(
                      context, 
                      Transition(
                        child: const NFTMarketPlace(),
                        transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                      )
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  Widget _coinMenuCategory() {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          SizedBox(
            width: 80.w,
            child: TabBar(
              labelColor: hexaCodeToColor(AppColors.primaryColor),
              unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
              indicator: CircleTabIndicator(color: hexaCodeToColor(AppColors.primaryColor), radius: 3),
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'NotoSans'),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'NotoSans'),
              tabs: const [
                Tab(
                  text: "Trending",
                ),
            
                Tab(
                  text: "Market",
                ),
            
                Tab(
                  text: "News",
                )
              ],
            ),
          ),
      
          Expanded(
            child: TabBarView(
              children: [
                
                Consumer<MarketProvider>(
                  builder: (context, marketProvider, widget) {
                    return CoinTrending(trendingCoin: marketProvider.cnts,);
                  }
                ),
                
                Consumer<MarketProvider>(
                  builder: (context, marketProvider, widget) {
                    return CoinMarket(lsMarketCoin: marketProvider.lsMarketLimit,);
                  }
                ),

                const MyText(text: "News",),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget discliamerText(){
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingSize),
      child: MyText(
        text: 
        '''IMPORTANT DISCLAIMER: All content provided herein our website, hyperlinked sites, associated applications, forums, blogs, social media accounts and other platforms ("Site") is for your general information only, procured from third party sources. We make no warranties of any kind in relation to our content, including but not limited to accuracy and updates. No part of the content that we provide constitutes financial advice, legal advice or any other form of advice meant for your specific reliance for any purpose. Any use or reliance on our content is solely at your own risk and discretion. You should conduct your own research, review, analyses and verify our content before relying on them. Trading is a highly risky activity that can lead to major losses, please therefore consult your financial advisor before making any decision. No content on our Site is meant to be a solicitation or offer.''',
        hexaColor: AppColors.greyCode,
        textAlign: TextAlign.start,
        fontSize: 15,
        pBottom: 10,
      ),
    );
  }


}