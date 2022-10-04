import 'package:carousel_slider/carousel_slider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'package:wallet_apps/src/components/scroll_speed.dart';
import 'package:wallet_apps/src/models/image_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_apps/src/models/marketplace_list_m.dart';
import 'package:wallet_apps/src/screen/home/ads_webview/ads_webview.dart';
import 'package:wallet_apps/src/screen/home/assets/assets.dart';
import 'package:wallet_apps/src/screen/home/explorer_tab/explorer.dart';
import 'package:wallet_apps/src/screen/home/swap/swap.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:wallet_apps/src/service/marketplace_webview.dart';

import '../setting/setting.dart';

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

    return Scaffold(
      key: homePageModel!.globalKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: const Menu(),
      ),
      backgroundColor: isDarkTheme ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
      appBar: homePageModel!.activeIndex == 4 ?
      AppBar(
        backgroundColor: isDarkTheme ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: MyText(
          text: "Settings",
          fontWeight: FontWeight.bold,
          color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
          fontSize: 20,
        ),
      )
      :
      AppBar(
        // iconTheme: IconThemeData(
        //   color: hexaCodeToColor(isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor)
        // ),
        backgroundColor: homePageModel!.activeIndex == 1 ? hexaCodeToColor(isDarkTheme ? AppColors.bluebgColor : AppColors.orangeColor) : hexaCodeToColor(isDarkTheme ? AppColors.darkBgd : AppColors.lightColorBg),
        elevation: 0,
        leadingWidth: 15.w,
        leading: IconButton(
          onPressed: () {
            homePageModel!.globalKey!.currentState!.openDrawer();
          },
          icon: Icon(
            Iconsax.profile_circle, 
            color: isDarkTheme 
              ? hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.whiteColorHexa) 
              : hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.blackColor),
            size: 6.w,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Iconsax.chart_3,
                color: isDarkTheme 
                  ? hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.whiteColorHexa) 
                  : hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.blackColor),
                size: 6.w,
              ),
            ),
            onPressed: () async {
              portfolioDailog(context: context);
            },
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: paddingSize - 8.5),
            child: IconButton(
              icon: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Iconsax.scan,
                  color: isDarkTheme 
                    ? hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.whiteColorHexa) 
                    : hexaCodeToColor(homePageModel!.activeIndex == 1 ? AppColors.whiteColorHexa : AppColors.blackColor),
                  size: 6.w,
                ),
              ),
              onPressed: () async {
                
                // final value = await Navigator.push(context, Transition(child: QrScanner(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                // if (value != null){
                //   getReward!(value);
                // }
                await TrxOptionMethod.scanQR(
                  context,
                  [],
                  pushReplacement!,
                );
              },
            ),
          )
        ],
      ),
      body: PageView(
        physics: const CustomPageViewScrollPhysics(),
        controller: homePageModel!.pageController,
        onPageChanged: onPageChanged,
        children: [
          
          // Explorer(),
          DiscoverPage(homePageModel: homePageModel!),

          AssetsPage(isTrx: isTrx, homePageModel: homePageModel,),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // _carouselAds(context, homePageModel!.adsCarouselActiveIndex),
          
                const SizedBox(height: 10), 
                _menu(context),

                const SizedBox(height: 10), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                  child: MyText(
                    text: "DeFi",
                    fontSize: 17.5,
                    color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
                  child: SizedBox(
                    height: 20.h,
                    width: MediaQuery.of(context).size.width,
                    child: _defiMenu(context)
                  ),
                ),
          
                const SizedBox(height: 10), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                  child: MyText(
                    text: "Marketplace",
                    fontSize: 17.5,
                    color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
                  child: SizedBox(
                    height: 20.h,
                    width: MediaQuery.of(context).size.width,
                    child: _marketPlaceMenu(context)
                  ),
                ),
          
                const SizedBox(height: 10), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                  child: MyText(
                    text: "Selendra ECO System",
                    fontSize: 17.5,
                    color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
                  child: _selEcoSysMenu(context),
                ),
                
              ],
            ),
          ),

          const SwapPage(),

          const SettingPage(),
        ],
      ),
      bottomNavigationBar: MyBottomAppBar(
        index: homePageModel!.activeIndex,
        onIndexChanged: onPageChanged,
      ),
    );
  }

  Widget _carouselAds(BuildContext context, int activeIndex) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,  
            aspectRatio: 29 / 10,
            autoPlay: true,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: homePageModel!.onAdsCarouselChanged,
          ),
          items: imgList
            .map((item) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  Transition(child: AdsWebView(item: item), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                child: Card(
                  margin: const EdgeInsets.only(  
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    child: Image.asset(
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

        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: imgList.length,
          effect: SlideEffect(
            radius: 5.0,
            dotWidth: 25.0.sp,
            dotHeight: 5.0.sp,
            paintStyle: PaintingStyle.fill,
            dotColor: hexaCodeToColor(AppColors.sliderColor).withOpacity(0.36),
            activeDotColor: hexaCodeToColor(AppColors.sliderColor),
          ), 
          
        ),
      ],
    );
  }

  Widget _menu(BuildContext context) {
    double iconSize = 7.w;

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
                  icon: Icon(Iconsax.card_coin, color:Colors.white, size: iconSize),
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
                  icon: Icon(Iconsax.discount_shape, color:Colors.white, size: iconSize),
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
          padding: const EdgeInsets.symmetric(horizontal: paddingSize , vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyMenuItem(
                  title: "Send",
                  icon: Transform.rotate(
                    angle: 141.371669412,
                    child: Icon(Iconsax.import, color:Colors.white, size: iconSize),
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
                  icon: Icon(Iconsax.import, color:Colors.white, size: iconSize),
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
                  icon: Icon(Iconsax.scan, color:Colors.white, size: iconSize),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 125 / 456,
        crossAxisCount: 2,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: marketPlaceList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
          child: DefiMenuItem(
            image: Image.asset(
              marketPlaceList[index]['asset'],
              width: 10.w,
              height: 10.h,
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 125 / 456,
        crossAxisCount: 2,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: defiList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
          child: DefiMenuItem(
            image: Image.asset(
              defiList[index]['asset'],
              width: 10.w,
              height: 10.h,
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  "assets/logo/sala-logo.png",
                  width: 10.w,
                ),
                title: "SALA Digital",
                action: () async {
                  await LaunchApp.openApp(
                  androidPackageName: 'com.koompi.sala',
                  // openStore: false
                );
                },
              ),
            ),

            const SizedBox(width: 10,),

            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  "assets/logo/koompi-fifi.png",
                  width: 10.w,
                ),
                title: "KOOMPI Fi-Fi",
                action: () {
                  underContstuctionAnimationDailog(context: context);
                },
              ),
            )
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  "assets/logo/selendra-logo.png",
                  width: 6.w,
                ),
                title: "Funan DApp",
                action: () {
                  underContstuctionAnimationDailog(context: context);
                },
              ),
            ),

            const SizedBox(width: 10,),

            Expanded(
              child: SelEcoSysMenuItem(
                image: Image.asset(
                  "assets/logo/bitriel-logo-v2.png",
                  width: 10.w,
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