import 'package:bitriel_wallet/index.dart';

class WalletScreen extends StatelessWidget {

  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {

    if (context.mounted){

      final walletPro = Provider.of<WalletProvider>(context, listen: false);
      walletPro.setBuildContext = context;
      walletPro.getAsset();
      
      Provider.of<SDKProvier>(context, listen: false).fetchAllAccount();
    }

    return Scaffold(
      backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
      body: DefaultTabController(
        length: 1,
        child: RefreshIndicator(
          notificationPredicate: (notification) {
            // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
            if (notification is OverscrollNotification || Platform.isIOS) {
              return notification.depth == 2;
            }
            return notification.depth == 0;
          },
          onRefresh: () async {
            // await MarketProvider.fetchTokenMarketPrice(isQueryApi: true)
          },
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    toolbarHeight: 270,
                    pinned: true,
                    floating: true,
                    snap: true,
                    title: userWallet(context),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      labelColor: hexaCodeToColor(AppColors.primaryColor),
                      unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
                      indicatorColor: hexaCodeToColor(AppColors.primaryColor),
                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'NotoSans'),
                      unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'NotoSans'),
                      tabs: const [
                        Tab(
                          text: "Assets",
                        ),
                                    
                        // Tab(
                        //   text: "NFTs",
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ], 
            
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
            
            
                  Expanded(
                    child: Consumer<SDKProvier>(
                      builder: (context, value, wg){
                        return ListView.builder(
                          itemCount: value.getUnverifyAcc.length,
                          itemBuilder: (context, index){
                            if (value.getUnverifyAcc[index].status == true){
                              return Text("Arealdy verify");
                            }else{
                              return Text("Not yet verify");
                            }
                          }
                        );
                      }
                    ),
                  ),
                  // Consumer<WalletProvider>(
                  //   builder: (context, pro, wg){
                  //     return ListView.builder(
                  //       itemCount: pro.sortListContract!.length,
                  //       itemBuilder: (context, index){
            
                  //         return Text("${pro.sortListContract![index].symbol!} ${pro.sortListContract![index].balance!}");
                  //       }
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            
            // body: _tabBarView(context, dismiss!),
          ),
        ),
      ),
    );
  }
}