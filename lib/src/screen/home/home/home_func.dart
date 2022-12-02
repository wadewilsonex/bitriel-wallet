import 'package:awesome_select/awesome_select.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../index.dart';

class HomeFunctional {

  /// Change SELENDRA Network
  Future changeNetwork({required ApiProvider? provider, required BuildContext? context, required StateSetter? setState, required String? initSLDNetwork}) async {
    return showBarModalBottomSheet(
      context: context!,
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      builder: (context) => Column(
        children: [

          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              icon: Icon(Iconsax.close_circle, color: isDarkMode ? Colors.white : Colors.black,),
            ), 
  
            title: const MyText(text: "Change Network", fontWeight: FontWeight.bold, fontSize: 18,)
          ),

          Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Theme(
              data: ThemeData(
                textTheme: TextTheme(
                  titleMedium: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)),
                  bodySmall: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.textColor))
                )
              ),
              child: SmartSelect<String>.single(
                title: 'SELENDRA',
                selectedValue: provider!.network!,
                onChange: (selected) async{
                  setState!(() => initSLDNetwork = selected.value);
                  provider.network = selected.value;
                  await provider.connectSELNode(context: context, endpoint: selected.value);
                //   await DialogComponents().dialogCustom(
                //   context: context,
                //   contents: "Switch network",
                //   btn: TextButton(
                //     onPressed: () async {
            
                //       provider.network = selected.value;
            
                //       // Notify Value Change Of Selected Network
                //       provider.notifyListeners();
                //       Navigator.pop(context, "true");
                //     }, 
                //     child: MyText(text: "Yes",)
                //   ),
                // ).then((res) async {
                //   if (res != null) {
            
                //     await provider.connectSELNode(context: context, endpoint: selected.value);
                //   }
                // });
                },
                choiceType: S2ChoiceType.radios,
                choiceItems: sldNetworkList,
                modalType: S2ModalType.popupDialog,
                modalHeader: false,
                modalConfig: const S2ModalConfig(
                  style: S2ModalStyle(
                    backgroundColor: Colors.white70,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                ),
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    isTwoLine: true,
                    leading: CircleAvatar(
                      child: Image.asset(
                        'assets/SelendraCircle-White.png',
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],  
      ),
    );
  }
}