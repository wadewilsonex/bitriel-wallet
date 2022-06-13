import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/search_c.dart';
import 'package:wallet_apps/src/provider/search_p.dart';

class MyBottomSheet {
  dynamic response;
  bool pushReplacement = false;

  Future<dynamic> trxOptions({BuildContext? context, List? portfolioList, String? asset}) {
    final isDarkTheme = Provider.of<ThemeProvider>(context!, listen: false).isDark;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkTheme
              ? hexaCodeToColor(AppColors.darkBgd)
              : hexaCodeToColor(AppColors.lowWhite),
          ),
          height: 153,
          child: Column(
            children: [
              Align(
                child: MyText(
                  color: isDarkTheme
                    ? AppColors.whiteColorHexa
                    : AppColors.textColor,
                  top: 20,
                  bottom: 33,
                  text: "Transaction options",
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyBottomSheetItem(
                      subTitle: "Scan wallet",
                      icon: "icons/qr_code.svg",
                      action: () async {
                        // Navigator.pop(context);
                        try {
                          await TrxOptionMethod.scanQR(
                            context,
                            portfolioList!,
                            pushReplacement
                          );
                        } catch (e) {
                          if (ApiProvider().isDebug == true) print("error TrxOptionMethod.scanQR $e");
                        }
                        
                      },
                    ),
                  ),
                  Expanded(
                    child: MyBottomSheetItem(
                      icon: "icons/form.svg",
                      subTitle: "Fill wallet",
                      action: () {
                        Navigator.pop(context);
                        TrxOptionMethod.navigateFillAddress(
                          context,
                          portfolioList!,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: MyBottomSheetItem(
                      icon: "icons/contact.svg",
                      subTitle: "Invite friend",
                      action: () async {
                        // TrxOptionMethod.selectContact(
                        //     context, portfolioList);
                        Navigator.pop(context);
                        await dialog(
                          context,
                          'Coming Soon!',
                          'Invite friend',
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> dialog(BuildContext context, String text1, String text2, {Widget? action}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: Text(text1),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(text2, textAlign: TextAlign.center,),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> notification({BuildContext? context}) {
    return showModalBottomSheet(
      context: context!,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: hexaCodeToColor(AppColors.lowWhite)),
          height: MediaQuery.of(context).size.height - 107,
          child: Column(
            children: [
              Align(
                child: MyText(
                  color: "#FFFFFF",
                  top: 20,
                  bottom: 33,
                  text: "Notification",
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppConfig.iconsPath+'no_data.svg', height: 200),
                    MyText(text: "There are no notification found")
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> listToken({@required BuildContext? context, @required Function? query }){
    final isDarkTheme = Provider.of<ThemeProvider>(context!, listen: false).isDark;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(color: hexaCodeToColor(AppColors.lowWhite)),
                height: MediaQuery.of(context).size.height / 1.2,
                child: Column(
                  children: [

                    Container(
                      color: isDarkTheme ? hexaCodeToColor("#2C2C2D") : Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: MyText(
                                  top: 10,
                                  bottom: 33,
                                  text: "Tokens",
                                  color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor,
                                ),
                              ),

                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(onPressed: (){Navigator.pop(context);}, child: MyText(text: "Done", fontWeight: FontWeight.w700, color: AppColors.blueColor)),
                              )
                            ],
                          ),

                          SearchComponent(query: query, setState: setState)
                        ],
                      ),
                    ),

                    Expanded(
                      child: Stack(
                        children: [
                          
                          // List Asset
                          Consumer<ContractProvider>(
                            builder: (context, provider, widget){
                              return SearchItem(lsItem: provider.listContract, mySetState: setState,);
                            }
                          ),

                          // Items Searched
                          Consumer<SearchProvider>(
                            builder: (context, provider, widget){
                              return provider.getSchLs.isNotEmpty ? SearchItem(lsItem: provider.getSchLs, mySetState: setState) : Container();
                            }
                          ),
                        ],
                      )
                    )
                    
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }
}
