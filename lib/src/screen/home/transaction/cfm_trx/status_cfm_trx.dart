import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';

class StatusCfmTrx extends StatelessWidget {
  final TransactionInfo? trxInfo;
  final Function? sendTrx;
  final String? gasFeetoEther;
  const StatusCfmTrx({
    Key? key,
    this.trxInfo,
    this.sendTrx,
    this.gasFeetoEther,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    // final addr = AppUtils.addrFmt(trxInfo!.receiver.toString());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // MyAppBar(
            //   title: "AppString.confirmTxTitle",
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   color: isDarkTheme
            //     ? hexaCodeToColor(AppColors.darkCard)
            //     : hexaCodeToColor(AppColors.whiteHexaColor),
            // ),

            Expanded(
              child: Column(
                children: [

                  MyText(
                    top: 30.0,
                    text: "Transaction is sent to the network.",
                    color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
                    left: paddingSize * 2, right: paddingSize * 2,
                    bottom: paddingSize * 2,
                    
                  ),

                  MyText(
                    text: "Transaction is sent to the network. You will get notification when it is confirmed. You can safely close this screen.",//AppString.amtToSend,
                    color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                    bottom: paddingSize,
                    left: paddingSize, right: paddingSize
                  ),

                  MyFlatButton(
                    height: 110,
                    textButton: "Ok",
                    fontSize: 15,
                    buttonColor: AppColors.blueColor,
                    edgePadding: EdgeInsets.only(top: 20, bottom: 20, left: paddingSize * 3, right: paddingSize * 3),
                    // edgeMargin: const EdgeInsets.only(
                    //   top: 40,
                    // ),
                    hasShadow: false,
                    action: (){},
                  ),
                  
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget spaceRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
