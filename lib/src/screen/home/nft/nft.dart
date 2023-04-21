import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/components/circle_tab_indicator_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/nfts/ticket_nft_m.dart';
import 'package:wallet_apps/src/screen/home/nft/tab/all_tab.dart';
import 'package:wallet_apps/src/screen/home/nft/tab/ticket_tab.dart';
import 'package:wallet_apps/src/screen/home/nft/tab/nft_tab.dart';

class NFT extends StatefulWidget {
  const NFT({Key? key}) : super(key: key);

  @override
  State<NFT> createState() => _NFTState();
}

class _NFTState extends State<NFT> with TickerProviderStateMixin {

  int active = 0;

  List<TicketNFTModel>? lstTicket = [];

  void queryTickets() async {

    if (kDebugMode) {
      debugPrint("queryTickets");
    }
    await StorageServices.fetchData(DbKey.token).then((value) async {
    //   debugPrint("token value != null $value");
      if (value != null){
        await getTickets('value').then((res) async {
          if (kDebugMode) {
            debugPrint("Res data ${res.body}");
          }

          (await json.decode(res.body))['tickets'].forEach((data){
            lstTicket!.add(
              TicketNFTModel.fromApi(data)
            );
          });

          setState(() { });
          
        });
      }
    });
  }

  @override
  initState(){
    queryTickets();
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
            width: 60,
            child: TabBar(
              labelColor: hexaCodeToColor(AppColors.primaryColor),
              unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
              indicator: CircleTabIndicator(color: hexaCodeToColor(AppColors.primaryColor), radius: 3),
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'NotoSans'),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'NotoSans'),
              tabs: const [
                Tab(
                  text: "ALL",
                ),
            
                Tab(
                  text: "TICKET",
                ),
            
                Tab(
                  text: "NFT",
                )
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                
                const AllTab(lstTicket: []),
                TicketTab(lstTicket: lstTicket,),
                NftTab(lstTicket: lstTicket!)
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