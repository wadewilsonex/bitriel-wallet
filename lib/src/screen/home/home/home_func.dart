import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../../index.dart';

class HomeFunctional {
    
  /// Change SELENDRA Network
  Future changeNetwork({required BuildContext? context, required StateSetter setState}) async {    
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
              icon: Icon(Iconsax.close_circle, color: isDarkMode ? Colors.white : Colors.black, size: 30,),
            ), 
  
            title: const MyText(text: "Change Network", fontWeight: FontWeight.bold, fontSize: 18,)
          ),

          StatefulBuilder(
            builder: (context, setStateWidget) {
              return Consumer<ApiProvider>(
                builder: (context, provider, widget) {
                  
                  return ExpandedTileList.builder(
                    itemCount: 1,
                    maxOpened: 1,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: paddingSize, vertical: paddingSize / 2),
                    itemBuilder: (context, index, controller) {
                      return ExpandedTile(
                        theme: const ExpandedTileThemeData(
                          headerColor: Colors.white,
                          headerRadius: 10.0,
                          contentBackgroundColor: Colors.white,
                          contentRadius: 10.0,
                        ),
                        controller: index == 2 ? controller.copyWith(isExpanded: true) : controller,
                        leading: Container(
                          alignment: Alignment.centerLeft,
                          width: 50,
                          height: 50,
                          child: CircleAvatar(
                            child: Image.asset(
                              'assets/SelendraCircle-White.png',
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyText(
                              text: "SELENDRA",
                              hexaColor: AppColors.blackColor,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                  
                            MyText(
                              text: provider.selNetwork!,
                              textAlign: TextAlign.start,
                            )
                          ],
                        ),
                        content: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                                
                              InkWell(
                                onTap: () async{
                                  dialogLoading(context);
                                  setState(() => provider.selNetwork);
                                  await provider.connectSELNode(context: context, endpoint: AppConfig.networkList[0].wsUrlMN).then((value) => {
                                    Navigator.pop(context),
                                  });
                                  setStateWidget(() {}); 
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(paddingSize),
                                  child: Row(
                                    children: [
                                      const MyText(
                                        text: "wss://rpc0.selendra.org",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: provider.selNetwork == AppConfig.networkList[0].wsUrlMN 
                                          ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 30,) 
                                          : Icon(Icons.circle, color: Colors.grey[600], size: 30,) 
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),

                              InkWell(
                                onTap: () async{
                                  dialogLoading(context);
                                  setState(() => provider.selNetwork);
                                  await provider.connectSELNode(context: context, endpoint: AppConfig.networkList[1].wsUrlMN).then((value) => {
                                    Navigator.pop(context),
                                  });
                                  setStateWidget(() {}); 
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(paddingSize),
                                  child: Row(
                                    children: [
                                      const MyText(
                                        text: "wss://rpc1.selendra.org",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: provider.selNetwork == AppConfig.networkList[1].wsUrlMN 
                                          ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 30,) 
                                          : Icon(Icons.circle, color: Colors.grey[600], size: 30,) 
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  
                  // return Padding(
                  //   padding: const EdgeInsets.all(paddingSize),
                  //   child: Theme(
                  //     data: ThemeData(
                  //       textTheme: TextTheme(
                  //         titleMedium: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor)),
                  //         bodySmall: TextStyle(color: hexaCodeToColor(isDarkMode ? AppColors.lowWhite : AppColors.textColor))
                  //       )
                  //     ),
                  //     child: SmartSelect<String>.single(
                  //       title: 'SELENDRA',
                  //       selectedValue: provider.selNetwork!,
                  //       onChange: (selected) async{
                          
                  //         provider.selNetwork = selected.value;
                  //         AppConfig.networkList[0].wsUrlMN = selected.value;

                  //         setState!(() => provider.selNetwork = selected.value);
                  //         await provider.connectSELNode(context: context, endpoint: selected.value);
                          
                  //       },
                  //       choiceItems: sldNetworkList,
                  //       choiceStyle: S2ChoiceStyle(titleStyle: TextStyle(color: hexaCodeToColor(AppColors.blackColor))),
                  //       modalType: S2ModalType.bottomSheet,
                  //       modalHeader: false,
                  //       modalConfig: const S2ModalConfig(
                  //         style: S2ModalStyle(
                  //           backgroundColor: Colors.white,
                  //           elevation: 1,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                  //           ),
                  //         ),
                  //       ),
                  //       tileBuilder: (context, state) {
                  //         return S2Tile.fromState(
                  //           state,
                  //           isTwoLine: true,
                  //           leading: CircleAvatar(
                  //             child: Image.asset(
                  //               'assets/SelendraCircle-White.png',
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // );
                }
              );
            }
          )
        ],  
      ),
    );
  }
}