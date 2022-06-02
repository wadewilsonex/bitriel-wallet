import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/select_swap_token_c.dart';
import 'package:wallet_apps/src/models/select_swap_token_m.dart';

class SelectSwapTokenBody extends StatelessWidget {

  final TextEditingController? searchController;

  const SelectSwapTokenBody({ 
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
              Navigator.pop(context);
            },
          )
        ]
      ),

      body: SingleChildScrollView(
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
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: SwapTokenListModel().lsSwapToken.length,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SwapTokenListModel().lsSwapToken[index],
              ),
            ],
          ),
        );
      }
    );
  }
}