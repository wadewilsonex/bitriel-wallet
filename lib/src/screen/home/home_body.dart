import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/effect_c.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/presale.dart';

class HomeBody extends StatelessWidget {

  final boxSize = 125.0;
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        
        // Pie Chart With List Asset Market
        // PortFolioCus(),

        Container(
          color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : Colors.white,
          padding: EdgeInsets.only(bottom: 15, top: 15, left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  child: Container(
                    height: boxSize,
                    width: boxSize,
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        shadow(context)
                      ],
                      gradient: LinearGradient(
                        colors: [
                          hexaCodeToColor('#92d0ff'),
                          hexaCodeToColor('#00ccff'),
                        ]
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      // color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
                    ),
                    child: MyText(
                      text: "Claim",
                      color: AppColors.whiteHexaColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClaimAirDrop()));
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    height: boxSize,
                    width: boxSize,
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        shadow(context)
                      ],
                      gradient: LinearGradient(
                        colors: [
                          // hexaCodeToColor('#f39d0c'),
                          // hexaCodeToColor('#ff7900'),

                          hexaCodeToColor('#00ddff'),
                          hexaCodeToColor('#00ffe0'),
                        ]
                      )
                      // color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
                    ),
                    child: MyText(
                      text: "Swap",
                      color: AppColors.whiteHexaColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Swap()));
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Container(
                    height: boxSize,
                    width: boxSize,
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        shadow(context)
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        colors: [
                          hexaCodeToColor('#00ffe0'),
                          hexaCodeToColor('#a7ffe3'),
                        ]
                      )
                      // color: isDarkTheme ? hexaCodeToColor(AppColors.darkCard) : hexaCodeToColor(AppColors.whiteColorHexa),
                    ),
                    child: MyText(
                      text: "Presale",
                      color: AppColors.whiteHexaColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Presale()));
                  },
                ),
              )
            ],
          )
        ),
        
        Divider(
          height: 0.5,
          color: isDarkTheme ? Colors.black : Colors.grey.shade400,
        ),

        Consumer<ContractProvider>(builder: (context, value, child) {
          return value.isReady
            // Asset List As Row
            ? AnimatedOpacity(
                opacity: value.isReady ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: AssetList(),
              )
            // Loading Data Effect Shimmer
            : MyShimmer(
                isDarkTheme: isDarkTheme,
              );
        }),
      ],
    );
  }
}
