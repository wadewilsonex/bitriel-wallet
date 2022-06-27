import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/appbar_c.dart';

class ConfirmationTx extends StatelessWidget {
  final TransactionInfo? trxInfo;
  final Function? sendTrx;
  // final String? gasFeetoEther;
  const ConfirmationTx({
    Key? key,
    this.trxInfo,
    this.sendTrx,
    // this.gasFeetoEther,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    dynamic addr;
    if (trxInfo!.receiver != null){
     addr = AppUtils.addrFmt(trxInfo!.receiver.toString());
    }
    // print("sendTrx ${sendTrx ?? 'sendTrx null'}");
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
      
            MyAppBar(
              title: AppString.confirmTxTitle,
              onPressed: () {
                Navigator.pop(context);
              },
              color: isDarkTheme
                ? hexaCodeToColor(AppColors.darkCard)
                : hexaCodeToColor(AppColors.whiteHexaColor),
            ),
      
            Expanded(
              child: Column(
                  children: [
      
                    MyText(
                      top: 32.0,
                      text: AppString.amtToSend,
                      fontSize: 20,
                      color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
                    ),
      
                    MyText(
                      top: 30,
                      text: '${trxInfo!.amount} ${trxInfo!.coinSymbol}',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                    ),
                    
                    MyText(
                      top: 8.0,
                      text: '≈ \$${trxInfo!.estTotalPrice}',//trxInfo!.estAmountPrice != null ? '≈ ${trxInfo!.estAmountPrice}' : '≈ \$0.00', //'≈ \$0.00',
                      color: AppColors.darkSecondaryText,
                    ),
      
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Divider(
                      color: isDarkTheme ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.darkSecondaryText),
                      height: 1.0,
                    ),
      
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
                      child: Column(
                        children: [
                          // Send To
                          spaceRow([
                            MyText(
                              text: AppString.to,
                              fontSize: 16.0,
                              color: isDarkTheme ? AppColors.darkSecondaryText : AppColors.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                            MyText(
                              textAlign: TextAlign.left,
                              text: addr ?? '',
                              bottom: 8.0,
                              overflow: TextOverflow.ellipsis,
                              color: isDarkTheme
                                ? AppColors.darkSecondaryText
                                : AppColors.textColor,
                              //fontWeight: FontWeight.bold,
                            ),
                          ]),

                          // Gas Fee
                          spaceRow([
                            MyText(
                              text: AppString.gasFee,
                              fontSize: 16.0,
                              top: 8.0,
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme
                                ? AppColors.darkSecondaryText
                                : AppColors.textColor,
                            ),
                            Column(
                              children: [
                                MyText(
                                  text: trxInfo!.gasFee,
                                  fontSize: 20,
                                  top: 8.0,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme
                                    ? AppColors.whiteColorHexa
                                    : AppColors.textColor,
                                  //fontWeight: FontWeight.bold,
                                ),
                                // MyText(
                                //   top: 8.0,
                                //   text: trxInfo!.estGasFeePrice != null ? '≈ \$${trxInfo!.estGasFeePrice}' : '≈ \$0.00',
                                //   color: AppColors.darkSecondaryText,
                                //   //fontWeight: FontWeight.bold,
                                // ),
                              ],
                            ),
                          ]),

                          spaceRow([
                            MyText(
                              top: 32.0,
                              fontWeight: FontWeight.bold,
                              text: '${AppString.gasPrice} ${trxInfo!.gasPriceUnit}:',
                              color: isDarkTheme
                                ? AppColors.darkSecondaryText
                                : AppColors.textColor,
                              //fontWeight: FontWeight.bold,
                            ),
                            MyText(
                              top: 32.0,
                              text: '  ${trxInfo!.gasPrice}',
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme
                                ? AppColors.whiteColorHexa
                                : AppColors.textColor,
                              //fontWeight: FontWeight.bold,
                            ),
                          ]),
                          spaceRow([
                            MyText(
                              top: 16.0,
                              text: AppString.gasLimit,
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme
                                ? AppColors.darkSecondaryText
                                : AppColors.textColor,
                            ),
                            MyText(
                              top: 16.0,
                              text: '  ${trxInfo!.maxGas}',
                              color: isDarkTheme
                                ? AppColors.whiteColorHexa
                                : AppColors.textColor,
                            ),
                          ])
                        ],
                      ),
                    ),
                    
                    Divider(
                      color: isDarkTheme
                        ? hexaCodeToColor(AppColors.whiteColorHexa)
                        : hexaCodeToColor(AppColors.darkSecondaryText),
                      height: 1.0,
                    ),

                    MyText(
                      top: 8.0,
                      text: AppString.amtPGasFee,
                      fontSize: 16.0,
                      color: AppColors.darkSecondaryText,
                      //fontWeight: FontWeight.bold,
                    ),
                    
                    Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: paddingSize,
                          // vertical: 28.0,
                        ),
                        child: spaceRow([
                          MyText(
                            text: AppString.total,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme
                              ? AppColors.darkSecondaryText
                              : AppColors.textColor,
                            //fontWeight: FontWeight.bold,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MyText(
                                top: 8.0,
                                text: double.parse(trxInfo!.totalAmt!).toStringAsFixed(7).toString(),
                                fontSize: 20,
                                color: AppColors.secondary,
                                //fontWeight: FontWeight.bold,
                              ),
                              MyText(
                                top: 8.0,
                                text: '≈ \$${trxInfo!.estTotalPrice}', //'≈ \$0.00',
                                color: AppColors.darkSecondaryText,
                                //fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ]
                      )
                    ),
                  ],
                ),
            ),

            Padding(
              padding: EdgeInsets.all(paddingSize),
              child: MyGradientButton(
                textButton: AppString.confirm,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                action: () async {
                  // Generate Random Three Number Before Navigate
                  await sendTrx!(trxInfo, context: context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget spaceRow(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
