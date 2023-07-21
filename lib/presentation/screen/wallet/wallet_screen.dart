import 'package:bitriel_wallet/index.dart';
import 'package:bitriel_wallet/presentation/screen/wallet/wallet_info_screen.dart';

class WalletScreen extends StatelessWidget {

  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController searchController = TextEditingController();

    if (context.mounted){

      final walletPro = Provider.of<WalletProvider>(context, listen: false);
      walletPro.setBuildContext = context;
      walletPro.getAsset();
      
      Provider.of<SDKProvier>(context, listen: false).fetchAllAccount();
    }

    return Scaffold(
      appBar: defaultAppBar(context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _cardPortfolio(context),

            Row(
              children: [
                Expanded(child: _searchBar(searchController)),
                IconButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const AddAsset())
                    );
                  }, 
                  icon: const Icon(Icons.add)
                ),

                const SizedBox(width: 14)
              ],
            ),

            _listItemAsset(),

          ],
        ),
      ),
    );
    

    // return Scaffold(
    //   backgroundColor: hexaCodeToColor(AppColors.lightColorBg),
    //   body: DefaultTabController(
    //     length: 1,
    //     child: RefreshIndicator(
    //       notificationPredicate: (notification) {
    //         // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
    //         if (notification is OverscrollNotification || Platform.isIOS) {
    //           return notification.depth == 2;
    //         }
    //         return notification.depth == 0;
    //       },
    //       onRefresh: () async {
    //         // await MarketProvider.fetchTokenMarketPrice(isQueryApi: true)
    //       },
    //       child: NestedScrollView(
    //         floatHeaderSlivers: true,
    //         headerSliverBuilder: (context, innerBoxIsScrolled) => [
              
    //           SliverOverlapAbsorber(
    //             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //             sliver: SliverSafeArea(
    //               top: false,
    //               sliver: SliverAppBar(
    //                 toolbarHeight: 270,
    //                 pinned: true,
    //                 floating: true,
    //                 snap: true,
    //                 title: userWallet(context),
    //                 centerTitle: true,
    //                 automaticallyImplyLeading: false,
    //                 bottom: TabBar(
    //                   labelColor: hexaCodeToColor(AppColors.primaryColor),
    //                   unselectedLabelColor: hexaCodeToColor(AppColors.greyColor),
    //                   indicatorColor: hexaCodeToColor(AppColors.primaryColor),
    //                   labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'NotoSans'),
    //                   unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'NotoSans'),
    //                   tabs: const [
    //                     Tab(
    //                       text: "Assets",
    //                     ),
                                    
    //                     // Tab(
    //                     //   text: "NFTs",
    //                     // )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ], 
            
    //         body: Consumer<WalletProvider>(
    //           builder: (context, pro, wg){
    //             return ListView.builder(
    //               itemCount: pro.sortListContract!.length,
    //               itemBuilder: (context, index){
    //                 return Text("${pro.sortListContract![index].symbol!} ${pro.sortListContract![index].balance!}");
    //               }
    //             );
    //           },
    //         ),
            
    //         // body: _tabBarView(context, dismiss!),
    //       ),
    //     ),
    //   ),
    // );
  }
}

Widget _cardPortfolio(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.all(14),
    margin: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: hexaCodeToColor(AppColors.cardColor),
      borderRadius: const BorderRadius.all(Radius.circular(20))
    ),
    child: Column(
      children: [

        MyTextConstant(
          text: "Avialable balance",
          color2: hexaCodeToColor(AppColors.darkGrey),
          fontSize: 15,
        ),

        MyTextConstant(
          text: "\$125.42",
          color2: hexaCodeToColor(AppColors.midNightBlue),
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: 15),

        Row(
          children: [

            Expanded(
              child: MyIconButton(
                edgeMargin: const EdgeInsets.all(10),
                fontWeight: FontWeight.w600,
                buttonColor: AppColors.green,
                action: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TokenPayment())
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextConstant(
                      text: "Send",
                      color2: hexaCodeToColor(AppColors.white),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(width: 5,),

                    const Icon(Iconsax.send_sqaure_2, color: Colors.white, size: 20,)
                  ],
                ),
              ),
            ),
        
            Expanded(
              child: MyIconButton(
                edgeMargin: const EdgeInsets.all(10),
                fontWeight: FontWeight.w600,
                buttonColor: "161414",
                action: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReceiveWallet())
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextConstant(
                      text: "Receive",
                      color2: hexaCodeToColor(AppColors.white),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(width: 5,),

                    const Icon(Iconsax.receive_square_2, color: Colors.white, size: 20,)
                  ],
                ),
              ),
            )
          ],
        ),

      ],
    )
  );
}

Widget _searchBar(TextEditingController searchController) {
  return Container(
    // Add padding around the search bar
    padding: const EdgeInsets.symmetric(horizontal: 14.0),
    // Use a Material design search bar
    child: TextField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: 'Search coins, tokens',
        // Add a clear button to the search bar
        suffixIcon: IconButton(
          icon: const Icon(Iconsax.close_circle),
          onPressed: () => searchController.clear(),
        ),
        // Add a search icon or button to the search bar
        prefixIcon: IconButton(
          icon: const Icon(Iconsax.search_normal_1),
          onPressed: () {
            // Perform the search here
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    ),
  );
}

Card getCardByIndex(int index, List<dynamic> member) {
  return Card(
    child: ListTile(
      leading: const CircleAvatar(),
      title: Text(member[index]["name"]),
      subtitle: Text(member[index]["noHp"]),
      onTap: () {},
    )
  );
}

  Widget _getGroupSeparator(AssetsModel assetsModel) {
  return SizedBox(
    height: 50,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: hexaCodeToColor("#F4F4F4"),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: MyTextConstant(
            text: assetsModel.chain,
            color2: hexaCodeToColor("#979797"),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    ),
  );
}

Widget _getItem(BuildContext ctx, AssetsModel assetsModel) {
  return SizedBox(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Icon(assetsModel.icon),
      title: Text(assetsModel.name),
      onTap: () {
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (context) => WalletInfo())
        );
      },
    ),
  );
}

Widget _listItemAsset() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: StickyGroupedListView<AssetsModel, String>(
      shrinkWrap: true,
      elements: elements,
      order: StickyGroupedListOrder.ASC,
      groupBy: (AssetsModel element) => element.chain,
      groupComparator: (String value1, String value2) => value2.compareTo(value1),
      itemComparator: (AssetsModel element1, AssetsModel element2) => element1.chain.compareTo(element2.chain),
      floatingHeader: true,
      groupSeparatorBuilder: _getGroupSeparator,
      itemBuilder: _getItem,
    ),
  );
}


//  Widget _listAsset(BuildContext context, IndexPath index, Map<String, List> elements) {



//     String user = elements.values.toList()[index.section][index.index];
//     return InkWell(child: Row(children: [
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           height: 40,width: 40,
//           decoration: BoxDecoration(
//           color:  Colors.primaries[Random().nextInt(Colors.primaries.length)],

//           shape: BoxShape.circle,
//         ),child: Center(child: Text(user.substring(0,1).toUpperCase(),style: const TextStyle(fontSize: 22,color: Colors.white))),),
//       ),
//        Text(
//         user,
//         style: const TextStyle(fontSize: 18),
//       ),
//     ],));
//   }
