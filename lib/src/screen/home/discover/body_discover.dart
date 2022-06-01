import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/defi_menu_item_c.dart';
import 'package:wallet_apps/src/components/marketplace_menu_item_c.dart';
import 'package:wallet_apps/src/components/menu_item_c.dart';
import 'package:wallet_apps/src/components/selendra_swap_c.dart';
import 'package:wallet_apps/src/components/swap_exchange_c.dart';
import 'package:wallet_apps/src/models/discover_m.dart';

class DiscoverPageBody extends StatelessWidget {
  final TabController tabController;
  const DiscoverPageBody({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {

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
        bottom: TabBar(
          unselectedLabelColor: hexaCodeToColor("#AAAAAA"),
          tabs: [
            Tab(
              child: Text(
                "Selendra Swap",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Exchange Swap",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          controller: tabController,
          indicatorColor: hexaCodeToColor("#AAAAAA"),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        // bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: DiscoverContent().lsSelendraSwap.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: paddingSize,),
                      child: DiscoverContent().lsSelendraSwap[index],
                    ),
                  ],
                ),
              );
            }
          ),
          
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: DiscoverContent().lsSwapExchange.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: paddingSize),
                      child: DiscoverContent().lsSwapExchange[index],
                    ),
                  ],
                ),
              );
            }
          ),
        ],
        controller: tabController,
      ),

      // body: Container(
      //   height: MediaQuery.of(context).size.height,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      
      //       Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
      //               child: MyText(
      //                 text: "Exchange Swap",
      //                 fontSize: 20,
      //                 color: AppColors.whiteColorHexa,
      //                 textAlign: TextAlign.start,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),
                  
      //             Expanded(
      //               child: ListView.builder(
      //                 shrinkWrap: true,
      //                 physics: BouncingScrollPhysics(),
      //                 itemCount: DiscoverContent().lsSwapExchange.length,
      //                 itemBuilder: (context, index){
      //                   return Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       Padding(
      //                         padding: const EdgeInsets.symmetric(horizontal: paddingSize),
      //                         child: DiscoverContent().lsSwapExchange[index],
      //                       ),
      //                       SizedBox(height: 10),
      //                     ],
      //                   );
      //                 }
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),

      //       // SizedBox(height: 25),

      //       Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [

      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: 10),
      //               child: MyText(
      //                 text: "Selendra Swap",
      //                 fontSize: 20,
      //                 color: AppColors.whiteColorHexa,
      //                 textAlign: TextAlign.start,
      //                 fontWeight: FontWeight.w600,
      //               ),
      //             ),

      //             Expanded(
      //               child: ListView.builder(
      //                 shrinkWrap: true,
      //                 physics: BouncingScrollPhysics(),
      //                 itemCount: DiscoverContent().lsSelendraSwap.length,
      //                 itemBuilder: (context, index){
      //                   return Container(
      //                     child: Column(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         Padding(
      //                           padding: const EdgeInsets.symmetric(horizontal: paddingSize,),
      //                           child: DiscoverContent().lsSelendraSwap[index],
      //                         ),
      //                         SizedBox(height: 10),
      //                       ],
      //                     ),
      //                   );
      //                 }
      //               ),
      //             ),
      //           ]
      //         ),
      //       ),
      
      //     ],
      //   ),
      // ),
      bottomNavigationBar: MyBottomAppBar(
        apiStatus: true,
      ),
    );
  }

}