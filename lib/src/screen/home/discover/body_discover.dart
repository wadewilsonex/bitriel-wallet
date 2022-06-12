import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'package:wallet_apps/src/components/selendra_swap_c.dart';
import 'package:wallet_apps/src/components/swap_exchange_c.dart';
import 'package:wallet_apps/src/models/discover_m.dart';

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
                    text: "Selendra Swap",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Tab(
                  child: MyText(
                    text: "Exchange Swap",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              controller: tabController,
              labelColor: hexaCodeToColor(AppColors.whiteColorHexa),
              indicatorColor: hexaCodeToColor("#D4D6E3"),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0.5,
            ),

            SizedBox(height: paddingSize,),



            Expanded(
              child: TabBarView(
                children: [
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.direction > 0) {
                        tabController.animateTo(1);
                      }
                      else{
                        homePageModel!.globalKey!.currentState!.openDrawer();
                      }
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: DiscoverContent.lsSelendraSwap!.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (details.delta.direction > 0) {
                              tabController.animateTo(1);
                            }
                            else{
                              homePageModel!.globalKey!.currentState!.openDrawer();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: paddingSize,),
                                  child: DiscoverContent.lsSelendraSwap![index],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.direction > 0) {
                        homePageModel!.pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
                      }
                      else{
                        tabController.animateTo(0);
                      }
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: DiscoverContent.lsSwapExchange.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                                child: DiscoverContent.lsSwapExchange[index],
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ),
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