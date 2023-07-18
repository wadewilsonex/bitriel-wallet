import 'package:bitriel_wallet/index.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final coinMarketCap = MarketUCImpl();
    
    coinMarketCap.scrollController.addListener(() {
      coinMarketCap.backToTop.value = coinMarketCap.scrollController.offset > 400 ? true : false;
    });

    coinMarketCap.getMarkets();

    Provider.of<SDKProvier>(context, listen: false).setBuildContext = context;
    Provider.of<SDKProvier>(context, listen: false).fetchAllAccount();

    return Scaffold(
      appBar: defaultAppBar(context: context),
      body: SingleChildScrollView(
        controller: coinMarketCap.scrollController,
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: hexaCodeToColor(AppColors.white),
          child: Column(
            children: [

              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
                }, 
                child: const Text("To wallet screen")
              ),

              TextButton(
                onPressed: () async {
                  await Provider.of<SDKProvier>(context, listen: false).getSdkImpl.deleteAccount(context);
                }, 
                child: const Text("Delete account")
              ),

              _menuItems(context),

              _top100Tokens(coinMarketCap),

            ],
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: coinMarketCap.backToTop,
        builder: (context, value, wg){
          return floatButton(coinMarketCap.scrollController, value);
        }
      )
    );
  }

  Widget floatButton(ScrollController scrollController, bool backToTop) 
  => backToTop ? FloatingActionButton(
    onPressed: () {
      scrollController.animateTo(
        0, 
        duration: const Duration(seconds: 1), 
        curve: Curves.bounceInOut
      );
    },
    child: const Icon(Iconsax.arrow_up_3),
  ) 
  : const SizedBox();

  Widget _menuItems(BuildContext context) {
    return Consumer<AssetProvider>(
      builder: (context, pro, wg) {
        return Container(
          // padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: hexaCodeToColor("#8ECAE6").withOpacity(0.20),
            borderRadius: const BorderRadius.all(Radius.circular(20))
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 14, right: 14, left: 14, bottom: 14 / 2 ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DashboardMenuItem(
                              title: "Swap",
                              asset: "${pro.dirPath}/icons/swap-coin.png",
                              hexColor: "#219EBC",
                              action: () async {
                                
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DashboardMenuItem(
                              title: "Staking",
                              asset: "${pro.dirPath}/icons/stake-coin.png",
                              hexColor: "#FF9F00",
                              action: () {
                                // underContstuctionAnimationDailog(context: context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DashboardMenuItem(
                              title: "Buy",
                              asset: "${pro.dirPath}/icons/buy-coin.png",
                              hexColor: "#FF0071",
                              action: () async {
                                // underContstuctionAnimationDailog(context: context);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DashboardMenuItem(
                              title: "Bitriel NFTs",
                              asset: "${pro.dirPath}/icons/nft_polygon.png",
                              hexColor: "#6C15ED",
                              action: () {
                                
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 14, left: 14, bottom: 14 / 2 ),
                child: Divider(
                  color: hexaCodeToColor("#78839C").withOpacity(0.25),
                ),
              ),

              SizedBox(
                height: 30,
                child: _listScrollMenuItem()
              ),

              const SizedBox(height: 14,),

            ],
          ),
        );
      }
    );
  }

  Widget _listScrollMenuItem() {
    List<String> menuName = ["Any Tickets", "Bitriel Go", "Bitriel Pay", "Bitriel X", "Bitriel ID"];
    List<String> menuImage = [
      "assets/logo/bitriel-logo.png",
      "assets/logo/bitriel-logo.png",
      "assets/logo/bitriel-logo.png",
      "assets/logo/bitriel-logo.png",
      "assets/logo/bitriel-logo.png",
    ];

    return ListView.builder(
      shrinkWrap: true,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      scrollDirection: Axis.horizontal,
      itemCount: menuName.length,
      itemBuilder:(context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 14.0, right: index == menuName.length - 1 ? 14 : 0),
          child: ScrollMenuItem(
            title: menuName[index], 
            asset: menuImage[index],
            action: () {
          
            }
          ),
        );
      },
    );
  }

  Widget _top100Tokens(MarketUCImpl coinMarketCap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [

          const Align(
            alignment: Alignment.topLeft,
            child: MyTextConstant(
              text: "Top Coins 100",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          ValueListenableBuilder(
            valueListenable: coinMarketCap.lstMarket, 
            builder: (context, value, wg){
              if (value.isEmpty) return const CircularProgressIndicator();
              return _listMarketView(value);
            }
          )

        ],
      ),
    ); 
  }

  Widget _listMarketView(List<Market> markets){
    
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemCount: markets.length,
      shrinkWrap: true,
      itemBuilder: (context, index){

        Market current = markets[index];

        final String priceConvert = double.parse("${current.price}".replaceAll(",", "")).toStringAsFixed(2);
        
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TokenInfo(tokenName: current.name, market: current,))
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                // Asset Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: Colors.white, 
                    child: Image.network(
                      current.logo, width: 30, height: 30,
                    )
                  )
                ),
            
                // Asset Name
                const SizedBox(width: 10),
          
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                
                      Row( 
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          
                          MyTextConstant(
                            text: current.symbol.toUpperCase(),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color2: hexaCodeToColor(AppColors.text),
                            textAlign: TextAlign.start,
                          ),
          
                        ],
                      ),
                
                      MyTextConstant(
                        text: current.name,
                        fontSize: 12,
                        color2: hexaCodeToColor(AppColors.darkGrey),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
                
                const Spacer(),
          
                // Total Amount
                MyTextConstant(
                  fontSize: 17,
                  text: "\$${priceConvert.replaceAllMapped(Fmt().reg, Fmt().mathFunc)}",
                  textAlign: TextAlign.right,
                  fontWeight: FontWeight.w600,
                  color2: hexaCodeToColor(AppColors.text),
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}