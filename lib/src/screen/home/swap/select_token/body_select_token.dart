import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/select_swap_token_c.dart';
import 'package:wallet_apps/src/models/select_swap_token_m.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';

class SelectSwapTokenBody extends StatelessWidget {
  final TextEditingController? searchController;

  SelectSwapTokenBody({ 
    Key? key,
    this.searchController,
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

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            _searchToken(context, searchController!),
      
            _tokenList(context),
          ],
        ),
      ),
    );
  }

  Widget _searchToken(BuildContext context, TextEditingController controller){
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
      ),
    );
  }

  Widget _tokenList(BuildContext context){
    return Consumer<SwapProvider>(
      builder: (context, provider, widget){
        return ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: provider.label == "first" ? provider.ls.length : provider.ls2.length,//SwapTokenListModel().lsSwapToken.length,
          itemBuilder: (context, index){
            print(provider.label == "first" ? provider.ls.length : provider.ls2.length);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SwapTokenList(
                      title: provider.label == "first" ? provider.ls[index].title : provider.ls2[index].title,
                      subtitle: provider.label == "first" ? provider.ls[index].subtitle : provider.ls2[index].subtitle,
                      isActive: provider.label == "first" ? provider.ls[index].isActive : provider.ls2[index].isActive,
                      image: provider.label == "first" ? provider.ls[index].image : provider.ls2[index].image,
                      action: (){
                        
                        if (provider.label == "first"){

                          provider.name1 = provider.contractProvider!.sortListContract[index].symbol!;
                          provider.logo1 = provider.contractProvider!.sortListContract[index].logo!;
                          provider.index1 = index;

                        } else {

                          provider.name2 = provider.contractProvider!.sortListContract[index].symbol!;
                          provider.logo2 = provider.contractProvider!.sortListContract[index].logo!;
                          provider.index2 = index;

                        }

                        provider.setList();
                        Provider.of<SwapProvider>(context, listen: false).label = "";
                        Provider.of<SwapProvider>(context, listen: false).notifyListeners();
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