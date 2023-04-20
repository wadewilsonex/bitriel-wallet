import 'dart:ui';

import 'package:wallet_apps/index.dart';

class SwapTokenList extends StatelessWidget {

  final bool? isActive;
  final String? title;
  final String? subtitle;
  final String? network;
  final Widget? image;
  final Function? action;
  
  const SwapTokenList({
    Key? key, 
    this.isActive = false,
    this.title,
    required this.network,
    this.subtitle,
    this.image,
    @required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String networkSplit = network!.replaceAll("(BEP20)", "");
    String networkName = networkSplit.trimRight();

    return GestureDetector(
      onTap: action == null ? null : (){
        if (isActive == false) action!();
      },
      child: Container(
        color: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        child: Row(
          children: [
      
            SizedBox(
              height: 65,
              width: 65,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: image 
                ),
              ),
            ),
          
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MyText(
                      text: title,
                      fontSize: 22,
                      color2: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor),
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.start,
                    ),
                    MyText(
                      pLeft: 7,
                      text: subtitle,
                      fontSize: 19,
                      color2: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),

                Row(
                  children: [
                    
                    networkName == "Binance Smart Chain" || networkName == "Ethereum Network" ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: networkName == "Binance Smart Chain" 
                        ? hexaCodeToColor("#F3BA2F").withOpacity(0.8)
                        :
                        networkName == "Ethereum Network" 
                        ? hexaCodeToColor("#444971").withOpacity(0.8)
                        : null,
                      ),
                      child: MyText(
                        text: networkName == "Binance Smart Chain" 
                          ? "BEP20"
                          :
                          networkName == "Ethereum Network" 
                          ? "ERC20"
                          : "",
                          
                        color2: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.whiteHexaColor),
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                    
                    : const SizedBox(),

                    networkName == "Binance Smart Chain" || networkName == "Ethereum Network" ? const SizedBox(width: 5,) : const SizedBox(),

                    MyText(
                      text: networkName,
                      color2: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor),
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}