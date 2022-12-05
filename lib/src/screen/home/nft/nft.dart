import 'package:wallet_apps/index.dart';
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
        children: [

          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Container(
          //     color: Colors.black.withOpacity(0.2),
          //     // height: 30,
          //     // width: 230,
          //     margin: const EdgeInsets.only(left: 20),
          //     child: TabBar(
          //       labelColor: Colors.green,
          //       unselectedLabelColor: Colors.amber,
          //       indicatorColor: Colors.green,
          //       indicator: BoxDecoration(
          //         borderRadius: BorderRadius.only(
          //           topRight: Radius.zero
          //         )
          //       ),
          //       tabs: [
          
                  

          //         // Tab(
          //         //   text: "ALL",
          //         //   icon: Icon(Icons.abc),
          //         // ),
          
          //         // Tab(
          //         //   text: "NFT",
          //         // ),
          
          //         // Tab(
          //         //   text: "TICKET",
          //         // )
          //       ],
          //     ),
          //   ),
          // ),

          Container(
            margin: EdgeInsets.only(top: 30, left: 30),
            child: Row(
              children: [

                TabItemComponent(
                  label: "ALL", 
                  active: active, 
                  index: 0, 
                  onTap: (){}
                ),

                TabItemComponent(
                  label: "NFT", 
                  active: active, 
                  index: 1, 
                  onTap: (){}
                ),

                TabItemComponent(
                  label: "GIFT", 
                  active: active, 
                  index: 2, 
                  onTap: (){}
                )
                
              ],
            ),
          ),

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