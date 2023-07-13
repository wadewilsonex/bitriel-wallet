import 'package:bitriel_wallet/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController();
  bool backToTop = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        backToTop = _scrollController.offset > 400 ? true : false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    final walletPro = Provider.of<WalletProvider>(context);
    walletPro.getAsset();
    walletPro.sortAsset();

    return Scaffold(
      appBar: defaultAppBar(context: context),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: hexaCodeToColor(AppColors.white),
          child: Column(
            children: [

              _menuItems(context),

              _top100Tokens(),

            ],
          ),
        ),
      ),
      floatingActionButton: floatButton(_scrollController, backToTop)
    );
  }

  Widget floatButton(ScrollController scrollController, bool backToTop) 
  => backToTop ? FloatingActionButton(
    onPressed: () {
      _scrollController.animateTo(
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

  Widget _listMarketView({required List<ListMetketCoinModel> lsMarketCoin}) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemCount: lsMarketCoin.length,
      shrinkWrap: true,
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

  Widget _top100Tokens() {
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

          Consumer<MarketProvider>(
            builder: (context, marketProvider, widget) {
              return Column(
                children: [
                          
                  if (marketProvider.marketUsecasesImpl.listMarket.isNotEmpty)
                  _listMarketView(lsMarketCoin: marketProvider.marketUsecasesImpl.listMarket)
                            
                  else if(marketProvider.marketUsecasesImpl.listMarket.isEmpty) 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: paddingSize),
                    child: Column(
                      children: [
                                  
                        Lottie.asset(
                          "assets/animation/search_empty.json",
                          repeat: false,
                          reverse: false,
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                                  
                        const MyTextConstant(
                          text: "Opps, Something went wrong!", 
                          fontSize: 17, 
                          fontWeight: FontWeight.w600,
                        )          
                      ],
                    ),
                  ),
                  
                ],
              );
            }
          ),
  
          
        ],
      ),
    ); 
  }

}