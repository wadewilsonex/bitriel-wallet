import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/circle_tab_indicator_c.dart';
import 'package:wallet_apps/src/components/tab_c.dart';
import 'package:wallet_apps/src/screen/home/nft/doers/all_tab.dart';
import 'package:wallet_apps/src/screen/home/nft/doers/gift_tab.dart';
import 'package:wallet_apps/src/screen/home/nft/doers/nft_tab.dart';

class NFT extends StatefulWidget {
  const NFT({Key? key}) : super(key: key);

  @override
  State<NFT> createState() => _NFTState();
}

class _NFTState extends State<NFT> with TickerProviderStateMixin {

  int active = 0;

  @override
  initState(){

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(
            width: 60.w,
            child: TabBar(
              labelColor: hexaCodeToColor(AppColors.primaryColor),
              unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
              indicator: CircleTabIndicator(color: hexaCodeToColor(AppColors.primaryColor), radius: 3),
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Barlow'),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Barlow'),
              tabs: const [
                Tab(
                  text: "ALL",
                ),
            
                Tab(
                  text: "NFT",
                ),
            
                Tab(
                  text: "TICKET",
                )
              ],
            ),
          ),

          // Container(
          //   margin: EdgeInsets.only(top: 30, left: 30),
          //   child: Row(
          //     children: [

          //       TabItemComponent(
          //         label: "ALL", 
          //         active: active, 
          //         index: 0, 
          //         onTap: (){}
          //       ),

          //       TabItemComponent(
          //         label: "NFT", 
          //         active: active, 
          //         index: 1, 
          //         onTap: (){}
          //       ),

          //       TabItemComponent(
          //         label: "GIFT", 
          //         active: active, 
          //         index: 2, 
          //         onTap: (){}
          //       )
                
          //     ],
          //   ),
          // ),

          const Expanded(
            child: TabBarView(
              children: [

                AllTab(),
                GiftTab(),
                NftTab()
                // NFTBody(type: "ALL",),
                // NFTBody(type: "NFT"),
                // NFTBody(type: "TICKET")
              ],
            ),
          )
        ],
      ),
    );
  }
}