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
        title: TabBar(
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
    );
  }

}