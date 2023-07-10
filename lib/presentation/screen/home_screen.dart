import 'package:bitriel_wallet/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: hexaCodeToColor(AppColors.white),
        automaticallyImplyLeading: false,
        title: _appBar()
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: hexaCodeToColor(AppColors.white),
          child: Column(
            children: [
              _menuItems(context),
            ],
          ),
        ),
      )
    );
  }

  Widget _appBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Avartar
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: GestureDetector(
            onTap: () async {},
            child: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: SizedBox(
                height: 30,
                width: 30,
                child: Placeholder(),
              ),
            )
          ),
        ),

        const Spacer(),

        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () async {},
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hexaCodeToColor(AppColors.background),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5, left: 2),
                        height: 25,
                        width: 25,
                        child: const Placeholder(),
                      ),
                      const MyText(
                        text: "Selendra Mainnet Network",
                        hexaColor: AppColors.midNightBlue,
                        fontSize: 14,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(
                          Iconsax.arrow_down_1,
                          size: 25,
                          color: hexaCodeToColor("#5C5C5C"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        const Spacer(),

        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Ink(
            decoration: ShapeDecoration(
              color: hexaCodeToColor(AppColors.background),
              shape: const CircleBorder(),
            ),
            child: IconButton(
              splashRadius: 24,
              icon: Icon(Iconsax.scan, color: hexaCodeToColor(AppColors.midNightBlue)),
              onPressed: () async {},
            ),
          ),
        ),
      ],
    );
  }

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
      "assets/images/bitriel-logo.png",
      "assets/images/bitriel-logo.png",
      "assets/images/bitriel-logo.png",
      "assets/images/bitriel-logo.png",
      "assets/images/bitriel-logo.png",
    ];

    return ListView.builder(
      shrinkWrap: true,
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
}