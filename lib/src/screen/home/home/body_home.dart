import 'package:carousel_slider/carousel_slider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'package:wallet_apps/src/models/image_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_apps/src/screen/home/assets/assets.dart';
import 'package:wallet_apps/src/screen/home/discover/discover.dart';
import 'package:wallet_apps/src/screen/home/swap/swap.dart';

class HomePageBody extends StatelessWidget {

  final HomePageModel? homePageModel;
  final Function(int index)? onIndexChanged;

  const HomePageBody({ 
    Key? key, 
    this.homePageModel,
    this.onIndexChanged
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: homePageModel!.globalKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Menu(),
      ),
      backgroundColor: hexaCodeToColor(AppColors.darkBgd),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            homePageModel!.globalKey!.currentState!.openDrawer();
          },
          icon: Icon(Iconsax.profile_circle, size: 25),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Iconsax.scan,
              size: 25,
            ),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: PageView(
        controller: homePageModel!.pageController,
        onPageChanged: onIndexChanged,
        children: [

          DiscoverPage(),

          AssetsPage(),

          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: paddingSize),
                  child: _carouselAds(context, homePageModel!.carouActiveIndex),
                ),
          
                SizedBox(height: 25), 
                _menu(context),
          
                SizedBox(height: 25), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                  child: MyText(
                    text: "DeFi",
                    fontSize: 20,
                    color: AppColors.whiteColorHexa,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
                  child: _defiMenu(context),
                ),
          
                SizedBox(height: 25), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                  child: MyText(
                    text: "Marketplace",
                    fontSize: 20,
                    color: AppColors.whiteColorHexa,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
                  child: _marketPlaceMenu(context),
                ),
                
              ],
            ),
          ),

          SwapPage(),
        ],
      ),
      bottomNavigationBar: MyBottomAppBar(
        index: homePageModel!.activeIndex,
        apiStatus: true,
        onIndexChanged: onIndexChanged,
      ),
    );
  }

  Widget _carouselAds(BuildContext context, int activeIndex) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 21 / 9,
              autoPlay: true,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: homePageModel!.onPageChanged,
            ),
            items: imgList
              .map((item) => Container(
                    child: Center(
                      child:Image.network(item, fit: BoxFit.cover)
                    ),
                  )
                )
              .toList(),
          ),

          SizedBox(height: 15),

          AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: imgList.length,
            effect: SlideEffect(
              radius: 5.0,
              dotWidth: 25.0,
              dotHeight: 7.0,
              paintStyle: PaintingStyle.fill,
              dotColor: hexaCodeToColor(AppColors.sliderColor).withOpacity(0.36),
              activeDotColor: hexaCodeToColor(AppColors.sliderColor),
            ), 
            
          ),
        ],
      )
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
                child: MenuItem(
                  title: "Swap",
                  icon: Icon(Iconsax.card_coin, color: Colors.white, size: 35),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  action: () {
                  },
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: MenuItem(
                  title: "Staking",
                  icon: Icon(Iconsax.discount_shape, color: Colors.white, size: 35),
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  action: () {
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
                child: MenuItem(
                  title: "Send",
                  icon: Transform.rotate(
                    angle: 141.371669412,
                    child: Icon(Iconsax.import, color: Colors.white, size: 35),
                  ),
                  
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () {
                  },
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: MenuItem(
                  title: "Recieve",
                  icon: Icon(Iconsax.import, color: Colors.white, size: 35),
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  action: () {
                  },
                ),
              ),

              SizedBox(width: 10,),

              Expanded(
                child: MenuItem(
                  title: "Pay",
                  icon: Icon(Iconsax.scan, color: Colors.white, size: 35),
                  begin: Alignment.bottomRight,
                  end: Alignment.topCenter,
                  action: () {
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _defiMenu(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefiMenuItem(
            title: "Bitriel DEX",
            action: () {
        
            },
          ),
        ),

        SizedBox(width: 10,),

        Expanded(
          child: DefiMenuItem(
            title: "Uniswap",
            action: () {
        
            },
          ),
        )
      ],
    );
  }

  Widget _marketPlaceMenu(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MarketPlaceMenuItem(
                title: "SALA Digital",
                action: () {
            
                },
              ),
            ),

            SizedBox(width: 10,),

            Expanded(
              child: MarketPlaceMenuItem(
                title: "KOOMPI Fi-Fi",
                action: () {
            
                },
              ),
            )
          ],
        ),

        SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: MarketPlaceMenuItem(
                title: "Land Tokens",
                action: () {
            
                },
              ),
            ),

            SizedBox(width: 10,),

            Expanded(
              child: MarketPlaceMenuItem(
                title: "OpenSea",
                action: () {
            
                },
              ),
            )
          ],
        )
      ],
    );
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 10 : 20;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(images[pagePosition]))),
    );
}

  imageAnimation(PageController animation, images, pagePosition) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, widget) {
        print(pagePosition);

        return SizedBox(
          width: 200,
          height: 200,
          child: widget,
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Image.network(images[pagePosition]),
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }


}