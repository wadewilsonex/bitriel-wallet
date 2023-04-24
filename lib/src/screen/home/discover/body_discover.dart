import 'dart:ui';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/models/market/marketplace_list_m.dart';
import 'package:wallet_apps/src/screen/home/webview/marketplace_webview.dart';

class DiscoverPageBody extends StatelessWidget {

  final HomePageModel? homePageModel;
  final TabController tabController;
  final TextEditingController? searchController;
  const DiscoverPageBody({
    Key? key,
    required this.tabController,
    this.homePageModel,
    this.searchController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _searchInputWeb(context),

            const SizedBox(height: 10), 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "DeFi",
                fontSize: 20,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: 5),
              child: SizedBox(
                height: 20.h,
                width: MediaQuery.of(context).size.width,
                child: _defiMenu(context)
              ),
            ),
        
            const SizedBox(height: 10), 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "NFTs",
                fontSize: 20,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.only(left: paddingSize, right: paddingSize, bottom: 5),
              child: SizedBox(
                height: 20.h,
                width: MediaQuery.of(context).size.width,
                child: _marketPlaceMenu(context)
              ),
            ),
        
            const SizedBox(height: 10), 
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingSize),
              child: MyText(
                text: "DApps",
                fontSize: 20,
                textAlign: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 5),
              child: _selEcoSysMenu(context),
            ),
          ]
        ),
      ),
    );
  }

  Widget _searchInputWeb(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(paddingSize),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage('assets/search_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const MyText(
                  text: 'DApp Browser',
                  fontWeight: FontWeight.w700,
                  color2: Colors.white,
                  fontSize: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                const MyText(
                  right: 25,
                  left: 25,
                  text: "Welcome to bitriel DApp browser you can search any DApp sites you want",
                  color2: Colors.white,
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  onFieldSubmitted: (val) {
                    Navigator.push(
                      context,
                      Transition(child: MarketPlaceWebView(url: searchController!.text, title: "DApp Browser",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                    );
                    searchController!.clear();
                  },
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    fontSize: 20,
                    color: hexaCodeToColor(AppColors.blackColor),
                  ),
                  decoration: InputDecoration(
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor).withOpacity(0),),
                    ),

                    hintText: "Enter dapp site name or URL",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: hexaCodeToColor(AppColors.blackColor),
                    ),

                    prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 18.0),
                    
                    /* Prefix Text */
                    filled: true,
                    fillColor: hexaCodeToColor("#D9D9D9").withOpacity(0.9),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          Transition(child: MarketPlaceWebView(url: searchController!.text, title: "DApp Browser",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                        );
                        searchController!.clear();
                      },
                      icon: Icon(Iconsax.search_normal_1, color: hexaCodeToColor( AppColors.primaryColor), size: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
            image: Image.file(
              File(marketPlaceList[index]['asset']),
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
            image: Image.file(
              File(defiList[index]['asset']),
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
    return Consumer<AppProvider>(
      builder: (context, pro, wg) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                
                Expanded(
                  child: SelEcoSysMenuItem(
                    image: Image.file(
                      File("${pro.dirPath}/logo/weteka.png"),
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

                const SizedBox(width: 10,),

                Expanded(
                  child: SelEcoSysMenuItem(
                    image: SvgPicture.file(
                      File("${pro.dirPath}/logo/Koompi_wifi.svg"),
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

            const SizedBox(height: 10),

            // Row(
            //   children: [
            //     Expanded(
            //       child: SelEcoSysMenuItem(
            //         image: Image.asset(
            //           isDarkMode ?
            //           "assets/logo/selendra-logo.png" :
            //           "assets/logo/selendra.png",
            //           width: 12.w,
            //         ),
            //         title: "Funan DApp",
            //         action: () {
            //           underContstuctionAnimationDailog(context: context);
            //         },
            //       ),
            //     ),

            //     const SizedBox(width: 10,),

            //     Expanded(
            //       child: SelEcoSysMenuItem(
            //         image: Image.asset(
            //           isDarkMode 
            //           ? "assets/logo/bitriel-light.png" 
            //           : "assets/logo/bitriel-logo-v2.png",
            //           width: 15.w,
            //         ),
            //         title: "Bitriel DEX",
            //         action: () {
            //           underContstuctionAnimationDailog(context: context);
            //         },
            //       ),
            //     )
            //   ],
            // )
          ],
        );
      }
    );
  }


}