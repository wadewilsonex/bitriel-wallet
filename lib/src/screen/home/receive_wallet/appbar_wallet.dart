import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';
import 'package:wallet_apps/src/service/contract.dart';

class QrViewTitle extends StatelessWidget {

  final String? assetInfo;
  final String? initialValue;
  final Function? onChanged;
  final List<Map<String, dynamic>>? listContract;

  QrViewTitle({this.assetInfo, this.initialValue, this.onChanged, required this.listContract});

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

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
                    border: Border.all(
                      color: hexaCodeToColor(AppColors.darkBgd)
                    ),
                    color: hexaCodeToColor(AppColors.whiteColorHexa),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: ReuseDropDown(
                    icon: Icon(Iconsax.arrow_down_1, color: hexaCodeToColor(AppColors.darkBgd), size: 20.sp,),
                    initialValue: initialValue,
                    onChanged: (String? value){
                      onChanged!(value);
                    },
                    itemsList: listContract,//ContractService.getConSymbol(context, listContract!),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: hexaCodeToColor(AppColors.darkBgd)
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