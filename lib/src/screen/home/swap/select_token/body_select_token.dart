import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/search_c.dart';
import 'package:wallet_apps/src/components/select_swap_token_c.dart';
import 'package:wallet_apps/src/models/select_swap_token_m.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/search_p.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';

class SelectSwapTokenBody extends StatelessWidget {
  final TextEditingController? searchController;
  final Function? query;

  SelectSwapTokenBody({ 
    Key? key,
    this.searchController,
    this.query
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Iconsax.close_circle,
              size: 25,
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
          color: hexaCodeToColor(AppColors.whiteColorHexa),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor("#114463"),),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 0, color: hexaCodeToColor("#114463"),),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(width: 3, color: hexaCodeToColor("#114463"),),
          ),
          hintText: "Type token name",
          hintStyle: TextStyle(
            fontSize: 14,
            color: hexaCodeToColor("#AAAAAA"),
          ),
          prefixStyle: TextStyle(color: hexaCodeToColor(AppColors.whiteHexaColor), fontSize: 18.0),
          /* Prefix Text */
          filled: true,
          fillColor: hexaCodeToColor("#114463"),
          suffixIcon: Icon(Iconsax.search_normal_1, color: hexaCodeToColor("#AAAAAA"), size: 20),
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
          physics: BouncingScrollPhysics(),
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
                          print(Provider.of<SwapProvider>(context, listen: false).ls[index].title);
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