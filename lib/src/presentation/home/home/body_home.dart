import 'package:carousel_slider/carousel_slider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:video_player/video_player.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/bottom_app_bar/bottom_appBar_c.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'package:wallet_apps/src/components/scroll_speed.dart';
import 'package:wallet_apps/src/models/image_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_apps/src/models/marketplace_list_m.dart';
import 'package:wallet_apps/src/presentation/home/assets/assets.dart';
import 'package:wallet_apps/src/presentation/home/events/events.dart';
import 'package:wallet_apps/src/presentation/home/explorer/explorer.dart';
import 'package:wallet_apps/src/presentation/home/home/home.dart';
import 'package:wallet_apps/src/presentation/home/nft/nft.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:wallet_apps/src/utils/service/marketplace_webview.dart';

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
    this.getReward
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("media query ${MediaQuery.of(context).size.width}");
    print("1.vmax ${1.vmax}");
    return Scaffold(
      key: homePageModel!.globalKey,
      // extendBody: true,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: const Menu(),
      ),
      appBar: defaultAppBar(
        context: context,
        homePageModel: homePageModel,
        pushReplacement: pushReplacement
      ),
      bottomNavigationBar: BottomAppBarCom(
        index: homePageModel!.activeIndex,
        onIndexChanged: onPageChanged,
      ),
      body: PageView(
        physics: const CustomPageViewScrollPhysics(),
        controller: homePageModel!.pageController,
        onPageChanged: onPageChanged,
        children: [
          
          // Explorer(),
          ExplorerPage(homePageModel: homePageModel!),

          AssetsPage(isTrx: isTrx, homePageModel: homePageModel,),

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

                // const SizedBox(height: 10), 
                // _menu(context),

                SizedBox(height: 3.vmax), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.vmax),
                  child: const MyText(
                    text: "DeFi",
                    fontSize: 2.5,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.vmax),
                  child: SizedBox(
                    height: 20.h,
                    width: MediaQuery.of(context).size.width,
                    child: _defiMenu(context)
                  ),
                ),
          
                SizedBox(height: 3.vmax), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.vmax),
                  child: const MyText(
                    text: "NFTs",
                    fontSize: 2.5,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.vmax),
                  child: SizedBox(
                    height: 20.h,
                    width: MediaQuery.of(context).size.width,
                    child: _marketPlaceMenu(context)
                  ),
                ),
          
                SizedBox(height: 3.vmax), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.vmax),
                  child: const MyText(
                    text: "DApps",
                    fontSize: 2.5,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.5.vmax),
                  child: _selEcoSysMenu(context),
                ),
                
                // SizedBox(height: 10.h), 
              ],
            ),
          ),

          // SwapPage(),
          const FindEvent(),

          // const SettingPage(), Fifth tab
          const NFT(),
        ],
      )
    );
  }

  Widget _carouselAds(BuildContext context, int activeIndex) {
    return Container(
      margin: EdgeInsets.only(top: paddingSize + 10, bottom: 10),
      child: Column(
        children: [
    
          Container(
            margin: EdgeInsets.only(bottom: 10),
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
                    padding: EdgeInsets.symmetric(horizontal: paddingSize),
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
    double iconSize = 6.w;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyMenuItem(
                  title: "Swap",
                  icon: Icon(Iconsax.card_coin, color: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.secondary), size: iconSize),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  action: () {
                    underContstuctionAnimationDailog(context: context);
                  },
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: MyMenuItem(
                  title: "Staking",
                  icon: Icon(Iconsax.discount_shape, color: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.secondary), size: iconSize),
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  action: () {
                    underContstuctionAnimationDailog(context: context);
                  },
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingSize , vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyMenuItem(
                  title: "Send",
                  icon: Transform.rotate(
                    angle: 141.371669412,
                    child: Icon(Iconsax.import, color: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.secondary), size: iconSize),
                  ),
                  
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () {
                    Navigator.push(
                      context, 
                      Transition(child: const SubmitTrx("", true, []), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    );
                  },
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: MyMenuItem(
                  title: "Recieve",
                  icon: Icon(Iconsax.import, color: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.secondary), size: iconSize),
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  action: () {
                    Navigator.push(
                      context, 
                      Transition(child: const ReceiveWallet(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    );
                  },
                ),
              ),

              const SizedBox(width: 10,),

              Expanded(
                child: MyMenuItem(
                  title: "Pay",
                  icon: Icon(Iconsax.scan, color: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.secondary), size: iconSize),
                  begin: Alignment.bottomRight,
                  end: Alignment.topCenter,
                  action: () async {
                    await TrxOptionMethod.scanQR(
                      context,
                      [],
                      pushReplacement!
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

  Widget _marketPlaceMenu(BuildContext context) {

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // childAspectRatio: 125 / 456,
        childAspectRatio: (15.vmax / 65.vmax),
        crossAxisCount: 2,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: marketPlaceList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(right: 13.sp, top: 13.sp),
          child: DefiMenuItem(
            image: Image.asset(
              marketPlaceList[index]['asset'],
              width: 6.vmax,
              height: 6.vmax,
            ),
            title: marketPlaceList[index]['title'],
            subtitle: marketPlaceList[index]['subtitle'],
            action: () async {
              Navigator.push(
                context,
                Transition(child: MarketPlaceWebView(url: marketPlaceList[index]['url'], title: marketPlaceList[index]['title'],), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              );
            },
          ),
        );
      },
    );
  }

  Widget _defiMenu(BuildContext context) {

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // childAspectRatio: (125 / 456).vmax,
        childAspectRatio: (15.vmax / 65.vmax),
        crossAxisCount: 2,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: defiList.length, 
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return Padding(
          padding: EdgeInsets.only(right: 1.5.vmax, top: 1.5.vmax),
          child: DefiMenuItem(
            image: Image.asset(
              defiList[index]['asset'],
              width: 6.vmax,
              height: 6.vmax,
              fit: BoxFit.cover,
            ),
            title: defiList[index]['title'],
            subtitle: defiList[index]['subtitle'],
            action: () async {
              Navigator.push(
                context,
                Transition(child: MarketPlaceWebView(url: defiList[index]['url'], title: defiList[index]['title'],), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
              );
            },
          ),
        );
      },
    );
  }

  Widget _selEcoSysMenu(BuildContext context) {

    const lgSize = 7;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  "assets/logo/weteka.png",
                  width: lgSize.vmax,
                  height: lgSize.vmax,
                ),
                title: "Weteka",
                action: () async {
                  await LaunchApp.openApp(
                  androidPackageName: 'com.koompi.sala',
                  // openStore: false
                );
                },
              ),
            ),

            SizedBox(width: 3.w,),

            Expanded(
              child: SelEcoSysMenuItem(
                image: SvgPicture.asset(
                  "assets/logo/Koompi_wifi.svg",
                  width: lgSize.vmax,
                  height: lgSize.vmax,
                  color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : "#0CACDA"),
                ),
                title: "KOOMPI Fi-Fi",
                action: () {
                  underContstuctionAnimationDailog(context: context);
                },
              ),
            )
          ],
        ),

        SizedBox(height: 3.w,),

        Row(
          children: [
            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  isDarkMode ?
                  "assets/logo/selendra-logo.png" :
                  "assets/logo/selendra.png",
                  width: lgSize.vmax,
                  height: lgSize.vmax,
                ),
                title: "Funan DApp",
                action: () {
                  underContstuctionAnimationDailog(context: context);
                },
              ),
            ),

            SizedBox(width: 3.w,),

            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  isDarkMode 
                  ? "assets/logo/bitriel-light.png" 
                  : "assets/logo/bitriel-logo-v2.png",
                  width: lgSize.vmax,
                  height: lgSize.vmax,
                ),
                title: "Bitriel DEX",
                action: () {
                  underContstuctionAnimationDailog(context: context);
                },
              ),
            )
          ],
        )
      ],
    );
  }

}