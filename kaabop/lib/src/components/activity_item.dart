import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';

class ActivityItem extends StatelessWidget {
  // final TransactionInfo _transactionInfo;
  // const ActivityItem(this._transactionInfo);
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return rowDecorationStyle(
        color: isDarkTheme
            ? hexaCodeToColor(AppColors.darkCard)
            : hexaCodeToColor(AppColors.whiteHexaColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 30, //size ?? 65,
                  height: 30, //size ?? 65,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
                SizedBox(width: 8.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'Pending Transaction',
                      bottom: 16.0,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme
                          ? AppColors.whiteColorHexa
                          : AppColors.textColor,
                    ),
                    MyText(
                      text: 'To: fasgdgaggfg',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkSecondaryText,
                    ),
                  ],
                ),
              ],
            ),
            MyText(
              text: '0000 BTC',
              fontWeight: FontWeight.bold,
              color:
                  isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
            ),
          ],
        ));
  }

  Widget rowDecorationStyle(
      {Widget child, double mTop = 0, double mBottom = 16, Color color}) {
    return Container(
        margin: EdgeInsets.only(top: mTop, bottom: 2),
        padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
        height: 100,
        color: color ?? hexaCodeToColor(AppColors.whiteHexaColor),
        child: child);
  }
}
