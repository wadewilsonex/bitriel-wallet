import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/components/select_swap_token_c.dart';
import 'package:wallet_apps/src/models/select_swap_token_m.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';

class SelectSwapTokenBody extends StatelessWidget {
  final TextEditingController? searchController;
  final Function? query;

  const SelectSwapTokenBody({ 
    Key? key,
    this.searchController,
    this.query
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? hexaCodeToColor(AppColors.darkBgd) : hexaCodeToColor(AppColors.lightColorBg),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const MyText(text: "Select Token", fontWeight: FontWeight.bold, fontSize: 22,),
        actions: <Widget>[
          
          IconButton(
            icon: Icon(
              Iconsax.close_circle,
              size: 30,
              color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor),
            ),
            onPressed: () {
              Provider.of<SwapProvider>(context, listen: false).label = "";
              Navigator.pop(context);
            },
          )
        ]
      ),

      body: Consumer<SwapProvider>(
        builder: (context, provider, widget){
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                
                _searchToken(provider.label, context, searchController!, query),
          
                Expanded(
                  child: Stack(
                    children: [
                      
                      provider.searched.isEmpty ? _tokenList(context, provider.ls, provider) : Container(),
                      // List Asset
          
                      // Items Searched
                      provider.searched.isNotEmpty ? _tokenList(context, provider.searched, provider) : Container()
                    ],
                  )
              
                )
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _searchToken(String label, BuildContext context, TextEditingController controller, Function? query){
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 20,
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteHexaColor),),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteHexaColor),),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteHexaColor),),
          ),
          hintText: "Search token name",
          hintStyle: TextStyle(
            fontSize: 20,
            color: hexaCodeToColor("#AAAAAA"),
          ),
          prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 20.0),
          /* Prefix Text */
          filled: true,
          fillColor: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.whiteHexaColor),
          // suffixIcon: Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     controller.value.text.isNotEmpty ? GestureDetector(
          //       onTap: () async {
          //         controller.clear();
          //       },
          //       child: Container(
          //         padding: const EdgeInsets.only(right: 16.0),
          //         child: Icon(Iconsax.close_circle, color: hexaCodeToColor(AppColors.iconGreyColor)),
          //       ),
          //     )
          //     : Container(),

          //     Icon(Iconsax.search_normal_1, color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.blackColor), size: 20)
          //   ],
          // ),
          suffixIcon: Icon(Iconsax.search_normal_1, color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.blackColor), size: 20)
        ),
        onChanged: (String value){
          query!(label, value);
        },
      ),
    );
  }

  Widget _tokenList(BuildContext context, List<SwapTokenListModel> ls, SwapProvider provider){
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: ls.length,//SwapTokenListModel().lsSwapToken.length,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SwapTokenList(
                  title: ls[index].title,
                  subtitle: ls[index].subtitle,
                  isActive: ls[index].isActive,
                  network: ls[index].network,
                  image: ls[index].image,
                  action: () async {
                    int indexFound = index;

                    if (provider.searched.isNotEmpty){
                      debugPrint("index = Provider.of<SwapProvider>(context, listen: false).ls ${Provider.of<SwapProvider>(context, listen: false).ls[index].network}");

                      // List<dynamic> found = Provider.of<SwapProvider>(context, listen: false).lstCoins!.where((element) {

                      // })
                      indexFound = Provider.of<SwapProvider>(context, listen: false).ls.indexOf(provider.searched[index]);
                      debugPrint("indexFound $indexFound");
                    }

                    provider.setNewAsset(indexFound);
                    provider.searched.clear();

                    debugPrint("index $index");
                    debugPrint("Found search ${provider.ls[index]}");

                    convertCoin(provider.name1, provider.name2, provider.model!.myController!.text).then((value) {
  
                      provider.lstConvertCoin = json.decode(value.body);

                      provider.notifyListeners();

                    });

                    provider.twoCoinModel!.from = provider.name1;
                    provider.twoCoinModel!.to = provider.name2;
                    provider.twoCoinModel!.networkFrom = provider.networkFrom;
                    provider.twoCoinModel!.networkTo = provider.networkTo;
                    provider.twoCoinModel!.amt = provider.balance1;
                    provider.twoCoinModel!.affiliateId = "DCNVjpI0Txr1Sw2w";

                    debugPrint("provider.twoCoinModel!.toJson() ${provider.twoCoinModel!.toJson()}");

                    Navigator.pop(context);
                    
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}