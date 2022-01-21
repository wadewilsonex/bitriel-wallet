import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class ConfirmationTx extends StatelessWidget {
  final TransactionInfo? trxInfo;
  final Function? sendTrx;
  final String? gasFeetoEther;
  const ConfirmationTx({
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
      body: Column(
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

          SendAppBar(
            title: "SEND",
            trailing: IconButton(
              onPressed: (){},
              icon: Icon(Icons.close, size: 30, color: Colors.white)
            ),
            margin: EdgeInsets.only(bottom: 30, left: paddingSize, right: paddingSize),
          ),

          Expanded(
            child: Stack(
              children: [

                Column(
                  children: [

                    MyText(
                      top: 30.0,
                      bottom: 30.0,
                      text: "You are sending",
                      fontSize: 14,
                      color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
                      left: paddingSize, right: paddingSize
                      
                    ),

                    MyText(
                      text: "416.66 SEL",//AppString.amtToSend,
                      fontSize: 30,
                      color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                      bottom: paddingSize,
                      left: paddingSize, right: paddingSize
                    ),

                    MyText(
                      text: "≈ \$12.5",//AppString.amtToSend,
                      fontSize: 25,
                      color: AppColors.blueColor,
                      left: paddingSize, right: paddingSize
                    ),

                    Container(
                      margin: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: hexaCodeToColor(isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor), height: 5,),
                          ),
                          MyText(
                            text: "to",
                            fontSize: 13,
                            color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                          ),
                          Expanded(
                            child: Divider(color: hexaCodeToColor(isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor), height: 5),
                          ),
                        ],
                      ),
                    ),

                    MyText(
                      text: "0x478d425e0fa854888b837dc",//AppString.amtToSend,
                      fontSize: 30,
                      color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                      left: paddingSize * 2, right: paddingSize * 2,
                      bottom: paddingSize * 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    MyText(
                      text: "Network Fee 0,00024782 (\$0.13)",//AppString.amtToSend,
                      fontSize: 13,
                      color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                      left: paddingSize, right: paddingSize,
                      bottom: paddingSize / 2,
                    ),

                    MyText(
                      text: "Total \$12.63",//AppString.amtToSend,
                      fontSize: 13,
                      color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                      left: paddingSize, right: paddingSize
                    ),

                    // Confirmation
                    // MyText(
                    //   top: 42,
                    //   text: '${trxInfo!.amount} ${trxInfo!.coinSymbol}',
                    //   fontSize: 32,
                    //   fontWeight: FontWeight.bold,
                    //   overflow: TextOverflow.ellipsis,
                    //   color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                    // ),
                    // MyText(
                    //   top: 8.0,
                    //   text: trxInfo!.estAmountPrice != null ? '≈ ${trxInfo!.estAmountPrice}' : '≈ \$0.00', //'≈ \$0.00',
                    //   color: AppColors.darkSecondaryText,
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.05,
                    // ),
                    // Divider(
                    //   color: isDarkTheme ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.darkSecondaryText),
                    //   height: 1.0,
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
                    //   child: Column(
                    //     children: [
                    //       spaceRow([
                    //         MyText(
                    //           text: AppString.to,
                    //           fontSize: 16.0,
                    //           color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
                    //           //fontWeight: FontWeight.bold,
                    //         ),
                    //         MyText(
                    //           textAlign: TextAlign.left,
                    //           text: addr ?? '',
                    //           fontSize: 16.0,
                    //           bottom: 8.0,
                    //           overflow: TextOverflow.ellipsis,
                    //           color: isDarkTheme
                    //             ? AppColors.darkSecondaryText
                    //             : AppColors.textColor,
                    //           //fontWeight: FontWeight.bold,
                    //         ),
                    //       ]),
                    //       spaceRow([
                    //         MyText(
                    //           text: AppString.gasFee,
                    //           fontSize: 16.0,
                    //           top: 8.0,
                    //           color: isDarkTheme
                    //             ? AppColors.darkSecondaryText
                    //             : AppColors.textColor,
                    //         ),
                    //         Column(
                    //           children: [
                    //             MyText(
                    //               text: trxInfo!.gasFee,
                    //               fontSize: 22.0,
                    //               top: 8.0,
                    //               fontWeight: FontWeight.bold,
                    //               color: isDarkTheme
                    //                 ? AppColors.whiteColorHexa
                    //                 : AppColors.textColor,
                    //               //fontWeight: FontWeight.bold,
                    //             ),
                    //             MyText(
                    //               top: 8.0,
                    //               text: trxInfo!.estGasFeePrice != null ? '≈ \$${trxInfo!.estGasFeePrice}' : '≈ \$0.00',
                    //               color: AppColors.darkSecondaryText,
                    //               //fontWeight: FontWeight.bold,
                    //             ),
                    //           ],
                    //         ),
                    //       ]),
                    //       spaceRow([
                    //         MyText(
                    //           top: 32.0,
                    //           text: '${AppString.gasPrice} ${trxInfo!.gasPriceUnit}:',
                    //           color: isDarkTheme
                    //             ? AppColors.darkSecondaryText
                    //             : AppColors.textColor,
                    //           //fontWeight: FontWeight.bold,
                    //         ),
                    //         MyText(
                    //           top: 32.0,
                    //           text: '  ${trxInfo!.gasPrice}',
                    //           fontWeight: FontWeight.bold,
                    //           color: isDarkTheme
                    //             ? AppColors.whiteColorHexa
                    //             : AppColors.textColor,
                    //           //fontWeight: FontWeight.bold,
                    //         ),
                    //       ]),
                    //       spaceRow([
                    //         MyText(
                    //           top: 16.0,
                    //           text: AppString.gasLimit,
                    //           color: isDarkTheme
                    //             ? AppColors.darkSecondaryText
                    //             : AppColors.textColor,
                    //         ),
                    //         MyText(
                    //           top: 16.0,
                    //           text: '  ${trxInfo!.maxGas}',
                    //           fontWeight: FontWeight.bold,
                    //           color: isDarkTheme
                    //             ? AppColors.whiteColorHexa
                    //             : AppColors.textColor,
                    //         ),
                    //       ])
                    //     ],
                    //   ),
                    // ),
                    // Divider(
                    //   color: isDarkTheme
                    //     ? hexaCodeToColor(AppColors.whiteColorHexa)
                    //     : hexaCodeToColor(AppColors.darkSecondaryText),
                    //   height: 1.0,
                    // ),
                    // Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 16.0,
                    //       vertical: 28.0,
                    //     ),
                    //     child: spaceRow([
                    //       MyText(
                    //         text: AppString.total,
                    //         color: isDarkTheme
                    //           ? AppColors.darkSecondaryText
                    //           : AppColors.textColor,
                    //         //fontWeight: FontWeight.bold,
                    //       ),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: [
                    //           MyText(
                    //             top: 8.0,
                    //             text: AppString.amtPGasFee,
                    //             fontSize: 16.0,
                    //             color: AppColors.darkSecondaryText,
                    //             //fontWeight: FontWeight.bold,
                    //           ),
                    //           MyText(
                    //             top: 8.0,
                    //             text: double.parse(trxInfo!.totalAmt!).toStringAsFixed(7).toString(),
                    //             fontSize: 32.0,
                    //             fontWeight: FontWeight.bold,
                    //             color: AppColors.secondary,
                    //             //fontWeight: FontWeight.bold,
                    //           ),
                    //           MyText(
                    //             top: 8.0,
                    //             text: '≈ \$${trxInfo!.estTotalPrice}', //'≈ \$0.00',
                    //             color: AppColors.darkSecondaryText,
                    //             //fontWeight: FontWeight.bold,
                    //           ),
                    //         ],
                    //       ),
                    //     ]
                    //   )
                    // ),

                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.03,
                    // ),
                    // MyFlatButton(
                    //   edgeMargin: const EdgeInsets.only(left: 42, right: 42, bottom: 16),
                    //   textButton: AppString.confirm,
                    //   action: () async {
                    //     await sendTrx!(trxInfo, context: context);
                    //   },
                    // )
                    
                  ],
                ),

                Positioned(
                  left: paddingSize, right: paddingSize,
                  bottom: 30,
                  child: ConfirmationSlider(
                    text: "Slide to confirm",
                    height: 50,
                    textStyle: TextStyle(color: Colors.white),
                    width: MediaQuery.of(context).size.width / 1.2,
                    backgroundColor: Colors.transparent,
                    foregroundColor: hexaCodeToColor(AppColors.blueColor),
                    onConfirmation: (){
                      print("Slide");
                    }
                  ),
                )
              ]
            ),
          )

        ],
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
