import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/indecator_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'package:wallet_apps/src/components/selendra_swap_c.dart';
import 'package:wallet_apps/src/components/swap_exchange_c.dart';
import 'package:wallet_apps/src/models/discover_m.dart';
import 'package:wallet_apps/src/screen/home/explorer/multi_explorer/multi_explorer.dart';
import 'package:wallet_apps/src/screen/home/explorer/selendra_explorer/selendra_explorer.dart';

class DiscoverPageBody extends StatelessWidget {

  final HomePageModel? homePageModel;
  final TabController tabController;
  const DiscoverPageBody({
    Key? key,
    required this.tabController,
    this.homePageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [

            TabBar(
              unselectedLabelColor: hexaCodeToColor(AppColors.iconColor),
              tabs: [
                Tab(
                  child: MyText(
                    text: "Selendra Explorer",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Tab(
                  child: MyText(
                    text: "Other Explorer",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              controller: tabController,
              // labelColor: hexaCodeToColor(AppColors.whiteColorHexa),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0.5,
              indicator: CustomTabIndicator(
                color: Colors.white,
              )
            ),

            SizedBox(height: paddingSize,),

            Expanded(
              child: TabBarView(
                children: [

                  SelendraExplorer(),
                  
                  // GestureDetector(
                  //   onHorizontalDragUpdate: (details) {
                  //     if (details.delta.direction > 0) {
                  //       tabController.animateTo(1);
                  //     }
                  //     else{
                  //       homePageModel!.globalKey!.currentState!.openDrawer();
                  //     }
                  //   },
                  //   child: ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: BouncingScrollPhysics(),
                  //     itemCount: DiscoverContent.lsSelendraSwap!.length,
                  //     itemBuilder: (context, index){
                  //       return GestureDetector(
                  //         onHorizontalDragUpdate: (details) {
                  //           if (details.delta.direction > 0) {
                  //             tabController.animateTo(1);
                  //           }
                  //           else{
                  //             homePageModel!.globalKey!.currentState!.openDrawer();
                  //           }
                  //         },
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(vertical: 5),
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Padding(
                  //                 padding: const EdgeInsets.symmetric(horizontal: paddingSize,),
                  //                 child: DiscoverContent.lsSelendraSwap![index],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   ),
                  // ),

                  MultiExplorer(),
                  
                  // GestureDetector(
                  //   onHorizontalDragUpdate: (details) {
                  //     if (details.delta.direction > 0) {
                  //       homePageModel!.pageController!.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
                  //     }
                  //     else{
                  //       tabController.animateTo(0);
                  //     }
                  //   },
                  //   child: ListView.builder(
                  //     shrinkWrap: true,
                  //     physics: BouncingScrollPhysics(),
                  //     itemCount: DiscoverContent.lsSwapExchange.length,
                  //     itemBuilder: (context, index){
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 5),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                  //               child: DiscoverContent.lsSwapExchange[index],
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }
                  //   ),
                  // ),
                ],
                controller: tabController,
              ),
            ),
          ]
        ),
      ),
    );
  }

}