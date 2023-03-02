import 'package:awesome_select/awesome_select.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../../index.dart';

class HomeFunctional {

  /// Change SELENDRA Network
  Future changeNetwork({required BuildContext? context, required StateSetter? setState}) async {
    
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

          Consumer<ApiProvider>(
            builder: (context, provider, widget) {
              
              return Padding(
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
                    selectedValue: provider.selNetwork!,
                    onChange: (selected) async{
                      
                      provider.selNetwork = selected.value;
                      AppConfig.networkList[0].wsUrlMN = selected.value;

                      setState!(() => provider.selNetwork = selected.value);
                      await provider.connectSELNode(context: context, endpoint: selected.value);
                      
                    },
                    choiceType: S2ChoiceType.radios,
                    choiceItems: sldNetworkList,
                    choiceStyle: S2ChoiceStyle(titleStyle: TextStyle(color: hexaCodeToColor(AppColors.blackColor))),
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
              );
            }
          )
        ],  
      ),
    );
  }
}