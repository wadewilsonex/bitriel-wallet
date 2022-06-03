import 'package:flutter/cupertino.dart';
import 'package:wallet_apps/index.dart';

class SearchComponent extends StatelessWidget{

  final Function? query;
  final Function? setState;

  SearchComponent({@required this.query, this.setState});
  
  Widget build(BuildContext context){
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return CupertinoSearchTextField(
      itemColor: Colors.white,
      style: TextStyle(color: isDark ? Colors.black : Colors.white),
      placeholderStyle: TextStyle(color: isDark ? Colors.black : Colors.white),
      decoration: BoxDecoration(
        color: isDark ? hexaCodeToColor("#48484C") : Colors.grey[400],
        borderRadius: BorderRadius.circular(5)
      ),
      onChanged: (el){
        query!(el, setState);
      },
    );
  }
}

class SearchItem extends StatelessWidget{

  final List<SmartContractModel>? lsItem;

  final Function? mySetState;

  final Function? onTap;

  SearchItem({@required this.lsItem, this.mySetState, this.onTap});
  
  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      padding: EdgeInsets.all(paddingSize),
      color: hexaCodeToColor(isDarkTheme ? AppColors.darkCard : AppColors.lowWhite),//"#2C2C2D" : AppColors.bgdColor),
      child: ListView.builder(
        itemCount: lsItem!.length,
        itemBuilder: (context, index){
          return InkWell(
            onTap: (){
              onTap!();
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: paddingSize),
              child: Row(
                children: <Widget>[

                  // Asset Logo
                  Container(
                    width: 65, //size ?? 65,
                    height: 65, //size ?? 65,
                    padding: const EdgeInsets.only(right: 10),
                    // margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Image.asset(
                      lsItem![index].logo!,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text.rich(
                        TextSpan(
                          text: lsItem![index].symbol != null ? '${lsItem![index].symbol} ' : '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: hexaCodeToColor(isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.blackColor,
                            ),
                          ),
                          children: [
                            TextSpan(
                              text: ApiProvider().isMainnet ? lsItem![index].org : lsItem![index].orgTest,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: hexaCodeToColor(isDarkTheme
                                  ? AppColors.whiteColorHexa
                                  : AppColors.darkSecondaryText,
                                ),
                              ),
                            )
                          ]
                        )
                      ),

                      MyText(
                        text: lsItem![index].name!, 
                        color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.darkSecondaryText,
                        fontSize: 14,
                      )
                    ],
                  ),
                  
                  Expanded(child: Container()),

                  CupertinoSwitch(
                    value: lsItem![index].show!,
                    onChanged: (bool value) async {
                      Provider.of<ContractProvider>(context, listen: false).listContract[index].show = value;
                      mySetState!(() { });
                      await StorageServices.storeAssetData(context);
                      await Provider.of<ContractProvider>(context, listen: false).sortAsset();
                    },
                  )

                ],
              ),
            ),
          );
          
        }
      ),
    );
  }
}

class SearchItemTrx extends StatelessWidget{

  final List<SmartContractModel>? lsItem;

  final Function? mySetState;

  final Function? onTap;

  SearchItemTrx({@required this.lsItem, this.mySetState, this.onTap});
  
  Widget build(BuildContext context){
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
      color: hexaCodeToColor(isDarkTheme ? AppColors.darkBgd : AppColors.lowWhite),
      child: ListView.builder(
        itemCount: lsItem!.length,
        itemBuilder: (context, index){
          return InkWell(
            onTap: (){
              onTap!();
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: paddingSize),
              child: Row(
                children: <Widget>[

                  // Asset Logo
                  Container(
                    width: 65, //size ?? 65,
                    height: 65, //size ?? 65,
                    padding: const EdgeInsets.only(right: 10),
                    // margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Image.asset(
                      lsItem![index].logo!,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text.rich(
                        TextSpan(
                          text: lsItem![index].symbol != null ? '${lsItem![index].symbol}' : '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: hexaCodeToColor(isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.blackColor,
                            ),
                          ),
                          children: [
                            TextSpan(
                              text: " ${lsItem![index].name!}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: hexaCodeToColor(isDarkTheme
                                  ? AppColors.darkSecondaryText
                                  : AppColors.darkSecondaryText,
                                ),
                              ),
                            )
                          ]
                        )
                      ),

                      lsItem![index].org!.isNotEmpty 
                      ? MyText(
                        text: lsItem![index].org!, 
                        color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.blackColor,
                        fontSize: 14,
                      )
                      : Container()
                    ],
                  ),
                  
                  Expanded(child: Container()),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      MyText(
                        text: '${lsItem![index].balance} ${lsItem![index].symbol}',
                        color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.blackColor,
                      ),

                      MyText(
                        text: '\$ ${lsItem![index].marketPrice!.isEmpty ? '0.0' : lsItem![index].marketPrice}',
                        color: isDarkTheme
                        ? AppColors.darkSecondaryText
                        : AppColors.blackColor,
                        fontSize: 14,
                      )
                    ],
                  ),           

                ],
              ),
            )
          );
          
        }
      ),
    );
  }
}