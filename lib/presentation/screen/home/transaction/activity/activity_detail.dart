import 'package:share_plus/share_plus.dart';
import '../../../../../index.dart';

class ActivityDetail extends StatelessWidget {
  final TransactionInfo? trxInfo;
  const ActivityDetail({Key? key, @required this.trxInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    final addr = AppUtils.addrFmt(trxInfo!.receiver.toString());

    return Scaffold(
      body: Container(
        color: isDarkMode
            ? hexaCodeToColor(AppColors.darkBgd)
            : hexaCodeToColor(AppColors.whiteColorHexa),
        child: Column(
          children: [
            myAppBar(
              context,
              title: 'Transfer',
              onPressed: () {
                Navigator.pop(context);
              },
              color: isDarkMode
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(AppColors.whiteHexaColor),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    text: '${trxInfo!.amount} ${trxInfo!.coinSymbol}',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    hexaColor: AppColors.secondary,
                  ),
                  MyText(
                    top: 8.0,
                    text: trxInfo!.estGasFeePrice != null 
                      ? '≈ \$${trxInfo!.estGasFeePrice}' 
                      : '≈ \$0.00', //'≈ $0.00',
                    hexaColor: AppColors.darkSecondaryText,
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 16.0),
            //   child: MyText(
            //     width: double.infinity,
            //     text: 'Transaction',
            //     fontSize: 20,
            //     fontWeight: FontWeight.w800,
            //     textAlign: TextAlign.start,
            //   ),
            // ),
            Card(
              margin: const EdgeInsets.all(16.0),
              color: isDarkMode
                  ? hexaCodeToColor(AppColors.darkCard)
                  : hexaCodeToColor(
                      AppColors.whiteColorHexa,
                    ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow('Date', trxInfo!.timeStamp!, isDarkMode),
                    const Divider(),
                    _buildRow(
                        'Status',
                        trxInfo!.status == null
                            ? 'Pending Transaction'
                            : trxInfo!.status!
                                ? 'Completed'
                                : 'Failed',
                        isDarkMode),
                    const Divider(),
                    _buildRow('To', addr, isDarkMode),
                    const Divider(),
                    _buildRow('Network Fee', trxInfo!.gasFee!, isDarkMode),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 21),
              // ignore: deprecated_member_use
              child: TextButton(
                onPressed: () {
                  // method.qrShare(keyQrShare, wallet);

                  if (trxInfo!.scanUrl != null) {
                    Share.share(trxInfo!.scanUrl!);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.share,
                      color: hexaCodeToColor(AppColors.secondary),
                      size: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: const MyText(
                        text: "SHARE",
                        hexaColor: AppColors.secondary,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildRow(String leadingText, String trailingText, bool isDarkMode) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: leadingText,
            fontWeight: FontWeight.w600,
            hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
          ),
          Expanded(
            child: MyText(
              textAlign: TextAlign.end,
              text: trailingText,
              // fontWeight: FontWeight.w700,
              hexaColor:
                  isDarkMode ? AppColors.whiteColorHexa : AppColors.greyCode,
            ),
          ),
        ],
      ),
    );
  }
}
