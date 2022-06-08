import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';
import 'package:wallet_apps/src/service/contract.dart';

class QrViewTitle extends StatelessWidget {

  final String? assetInfo;
  final String? initialValue;
  final Function? onChanged;

  QrViewTitle({this.assetInfo, this.initialValue, this.onChanged});

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final contract = Provider.of<ContractProvider>(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.5.h),
      child: Stack(
        alignment: Alignment.center,
        children: [

          // Align(
          //   child: MyText(
          //     text: 'Wallet',
          //     fontSize: 20.0,
          //     color: isDarkTheme
          //       ? AppColors.whiteColorHexa
          //       : AppColors.textColor,
          //   ),
          // ),
          
          if (assetInfo != null)
            Container()
          else
          Align(
            alignment: Alignment.topRight,
            child: Consumer<WalletProvider>(
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w,),
                  decoration: BoxDecoration(
                    color: hexaCodeToColor(AppColors.whiteColorHexa).withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: ReuseDropDown(
                    icon: Icon(Iconsax.arrow_down_1, color: Colors.white, size: 20.sp,),
                    initialValue: initialValue,
                    onChanged: (String? value){
                      onChanged!(value);
                    },
                    itemsList: ContractService.getConSymbol(context, contract.sortListContract),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: isDarkTheme
                        ? hexaCodeToColor( AppColors.whiteHexaColor)
                        : hexaCodeToColor(AppColors.textColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}