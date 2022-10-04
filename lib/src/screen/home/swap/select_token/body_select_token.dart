import 'package:wallet_apps/index.dart';
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Iconsax.close_circle,
              size: 25,
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
                      
                      provider.searched.isEmpty ? _tokenList(context, provider.label == "first" ? provider.ls : provider.ls2) : Container(),
                      // List Asset
          
                      // Items Searched
                      provider.searched.isNotEmpty ? _tokenList(context, provider.searched) : Container()
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
          fontSize: 14,
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor),),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor),),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.orangeColor),),
          ),
          hintText: "Type token name",
          hintStyle: TextStyle(
            fontSize: 14,
            color: hexaCodeToColor("#AAAAAA"),
          ),
          prefixStyle: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.orangeColor), fontSize: 18.0),
          /* Prefix Text */
          filled: true,
          fillColor: hexaCodeToColor(isDarkMode ? AppColors.bluebgColor : AppColors.lightColorBg),
          suffixIcon: Icon(Iconsax.search_normal_1, color: hexaCodeToColor(isDarkMode ? AppColors.whiteHexaColor : AppColors.blackColor), size: 20),
        ),
        onChanged: (String value){
          query!(label, value);
        },
      ),
    );
  }

  Widget _tokenList(BuildContext context, List<SwapTokenListModel> ls){
    return Consumer<SwapProvider>(
      builder: (context, provider, widget){
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
                      image: ls[index].image,
                      action: (){
                        if (provider.searched.isNotEmpty){

                          index = Provider.of<SwapProvider>(context, listen: false).ls.indexOf(provider.searched[index]);
                        }
                        provider.setNewAsset(index);
                        provider.searched = [];
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
    );
  }
}