import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/indecator_c.dart';
import 'package:wallet_apps/src/presentation/home/explorer/multi_explorer/multi_explorer.dart';
import 'package:wallet_apps/src/presentation/home/explorer/selendra_explorer/selendra_explorer.dart';

class DiscoverPageBody extends StatelessWidget {

  final HomePageModel? homePageModel;
  final TabController tabController;
  final TextEditingController? searchController;
  const DiscoverPageBody({
    Key? key,
    required this.tabController,
    this.homePageModel,
    this.searchController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 2.9.sp, right: 2.9.sp),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [

            TabBar(
              labelColor: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.textColor),
              unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
              tabs: [

                Tab(
                  height: 6.sp,
                  iconMargin: EdgeInsets.only(bottom: 1.5.sp),
                  child: MyText(
                    text: "Selendra Explorer",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Tab(
                  height: 6.sp,
                  iconMargin: EdgeInsets.only(bottom: 1.5.sp),
                  child: MyText(
                    text: "Other Explorer",
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 1.sp,
              indicator: CustomTabIndicator(
                radius: 1.2.sp,
                indicatorHeight: 0.5.sp,
                color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.primaryColor),
              )
            ),

            SizedBox(height: paddingSize,),

            Expanded(
              child: TabBarView(
                controller: tabController,
                // children: const [
                //   SelendraExplorer(),
                //   MultiExplorer(),
                // ],
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
                    child: const SelendraExplorer()
                  ),
                  
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.direction > 0) {
                        homePageModel!.pageController!.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      }
                      else{
                        tabController.animateTo(0);
                      }
                    },
                    child: const MultiExplorer(),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

}