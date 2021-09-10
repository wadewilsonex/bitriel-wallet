import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';

class ConfirmationTx extends StatelessWidget {
  final TransactionInfo trxInfo;
  final Function clickSend;
  const ConfirmationTx({
    Key key,
    this.trxInfo,
    this.clickSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final addr = AppUtils.addrFmt(trxInfo.receiver.toString());

    return Scaffold(
      body: BodyScaffold(
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
            MyText(
              top: 32.0,
              text: AppString.amtToSend,
              fontSize: 22,
              color: isDarkTheme
                  ? AppColors.darkSecondaryText
                  : AppColors.textColor,
            ),
            MyText(
              top: 42,
              text: '${trxInfo.amount} ${trxInfo.coinSymbol}',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              color:
                  isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
            ),
            MyText(
              top: 8.0,
              text: '≈ ${trxInfo.estAmountPrice}' ?? '≈ \$0.00', //'≈ \$0.00',
              color: AppColors.darkSecondaryText,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Divider(
              color: isDarkTheme
                  ? hexaCodeToColor(AppColors.whiteColorHexa)
                  : hexaCodeToColor(AppColors.darkSecondaryText),
              height: 1.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
              child: Column(
                children: [
                  spaceRow([
                    MyText(
                      text: AppString.to,
                      fontSize: 16.0,
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                      //fontWeight: FontWeight.bold,
                    ),
                    MyText(
                      textAlign: TextAlign.left,
                      text: addr ?? '',
                      fontSize: 16.0,
                      bottom: 8.0,
                      overflow: TextOverflow.ellipsis,
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                      //fontWeight: FontWeight.bold,
                    ),
                  ]),
                  spaceRow([
                    MyText(
                      text: AppString.gasFee,
                      fontSize: 16.0,
                      top: 8.0,
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                    Column(
                      children: [
                        MyText(
                          text: trxInfo.gasFee,
                          fontSize: 22.0,
                          top: 8.0,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme
                              ? AppColors.whiteColorHexa
                              : AppColors.textColor,
                          //fontWeight: FontWeight.bold,
                        ),
                        MyText(
                          top: 8.0,
                          text: '≈ \$${trxInfo.estGasFeePrice}' ?? '≈ \$0.00',
                          color: AppColors.darkSecondaryText,
                          //fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ]),
                  spaceRow([
                    MyText(
                      top: 32.0,
                      text: '${AppString.gasPrice} ${trxInfo.gasPriceUnit}:',
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                      //fontWeight: FontWeight.bold,
                    ),
                    MyText(
                      top: 32.0,
                      text: '  ${trxInfo.gasPrice}',
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
                      color: isDarkTheme
                          ? AppColors.darkSecondaryText
                          : AppColors.textColor,
                    ),
                    MyText(
                      top: 16.0,
                      text: '  ${trxInfo.maxGas}',
                      fontWeight: FontWeight.bold,
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
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 28.0,
                ),
                child: spaceRow([
                  MyText(
                    text: AppString.total,
                    color: isDarkTheme
                        ? AppColors.darkSecondaryText
                        : AppColors.textColor,
                    //fontWeight: FontWeight.bold,
                  ),
                  Column(
                    children: [
                      MyText(
                        top: 8.0,
                        text: AppString.amtPGasFee,
                        fontSize: 16.0,
                        color: AppColors.darkSecondaryText,
                        //fontWeight: FontWeight.bold,
                      ),
                      MyText(
                        top: 8.0,
                        text: trxInfo.totalAmt.substring(0, 9),
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        //fontWeight: FontWeight.bold,
                      ),
                      MyText(
                        top: 8.0,
                        text: '≈ \$${trxInfo.estTotalPrice}', //'≈ \$0.00',
                        color: AppColors.darkSecondaryText,
                        //fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ])),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Column(
              children: [
                MyFlatButton(
                  edgeMargin:
                      const EdgeInsets.only(left: 42, right: 42, bottom: 16),
                  textButton: AppString.confirm,
                  action: () {
                    clickSend();
                  },
                ),
              ],
            ),
          ],
        ),
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
