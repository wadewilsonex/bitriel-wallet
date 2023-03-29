import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../../index.dart';

class HomeFunctional {
    
  late int selectedIndex;
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
                        controller: controller,
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
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: sldNetworkList.length,
                                itemBuilder: (context, index) {
                                  selectedIndex = index;
                                  return ListTile(
                                    title:  MyText(
                                      text: sldNetworkList[index],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    ),
                                    trailing: AppConfig.networkList[0].wsUrlMN == sldNetworkList[index] ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 30,) 
                                                : Icon(Icons.circle, color: Colors.grey[600], size: 30,),
                                    onTap: () async{
                                      selectedIndex = index;

                                        print(selectedIndex);

                                        dialogLoading(context);

                                        AppConfig.networkList[0].wsUrlMN = sldNetworkList[index];

                                        setState(() => provider.selNetwork = sldNetworkList[index]);
                                        await provider.connectSELNode(context: context, endpoint: sldNetworkList[index]).then((value) => {
                                          Navigator.pop(context),
                                        });

                                        setStateWidget(() {});

                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              );
            }
          ),
        ],  
      ),
    );
  }
}