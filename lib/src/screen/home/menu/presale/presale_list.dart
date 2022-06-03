import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/presale_p.dart';

class PresaleList extends StatelessWidget {

  Future<String> dialogBox(BuildContext context) async {
    /* Show Pin Code For Fill Out */
    final String _result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: FillPin(),
        );
      }
    );
    return _result;
  }

  Future<void> customDialog(BuildContext context, String text1, String text2) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: Text(text1, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(text2, textAlign: TextAlign.center),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> successDialog(BuildContext context, String operationText, String btnText, Function onPressed) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            //height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.08,
                  ),
                  SvgPicture.asset(
                    AppConfig.iconsPath+'tick.svg',
                    height: 100,
                    width: 100,
                  ),
                  MyText(
                    text: 'SUCCESS!',
                    fontSize: 22,
                    top: MediaQuery.of(context).size.width * 0.1,
                    fontWeight: FontWeight.bold,
                  ),
                  MyText(
                    top: 8.0,
                    fontSize: 16,
                    text: 'You have successfully ' + operationText,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ignore: deprecated_member_use
                      SizedBox(
                        height: 50,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[300]),
                              foregroundColor: MaterialStateProperty.all(
                                  hexaCodeToColor(AppColors.secondary)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // ignore: deprecated_member_use
                      SizedBox(
                        height: 50,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: (){
                            onPressed();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  hexaCodeToColor(AppColors.secondary)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                          child: Text(
                            btnText,
                            style: TextStyle(
                              color: hexaCodeToColor('#ffffff'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> submitRedeem(BuildContext context, int orderId) async {
    final preSale = Provider.of<PresaleProvider>(context, listen: false);

    final String? pin = await dialogBox(context);

    if (pin != null) {
      dialogLoading(context);
      final privateKey = await AppServices.getPrivateKey(pin, context);

      if (privateKey != null) {
        try {
          final redeemHash =
              await preSale.redeem(privateKey: privateKey, orderId: orderId);

          if (redeemHash != null) {
            // final stt = await contract.getPending(redeemHash,
            //     nodeClient: contract.bscClient);

            // if (stt) {
            //   Navigator.pop(context);
            //   successDialog(context, 'redeemed.', 'Go to wallet', () {
            //     Navigator.pushNamedAndRemoveUntil(
            //         context, Home.route, ModalRoute.withName('/'));
            //   });
            //   // enableAnimation(
            //   //     'contributed ${_model.amountController.text} of ${_model.listSupportToken[_model.tokenIndex]['symbol']}.',
            //   //     'Go to wallet', () {
            //   //   Navigator.pushNamedAndRemoveUntil(
            //   //       context, Home.route, ModalRoute.withName('/'));
            //   // });
            // } else {
            //   Navigator.pop(context);
            //   await customDialog(context, 'Transaction failed',
            //       'Something went wrong with your transaction.');
            // }
          }
        } catch (e) {
          Navigator.pop(context);
          customDialog(context, 'Opps', '$e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDarkTheme
            ? hexaCodeToColor(AppColors.darkBgd)
            : hexaCodeToColor(AppColors.lowWhite),
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [

            SizedBox(height: 16.0),
            Container(
              height: 5,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),

            SizedBox(height: 24.0),
            MyText(
              width: double.infinity,
              fontSize: 22.0,
              text: "Presale Activity",
              color: isDarkTheme
                ? AppColors.darkSecondaryText
                : AppColors.textColor,
              fontWeight: FontWeight.bold,
            ),

            SizedBox(height: 24.0),

            // List Ordered Of Presale
            Expanded(
              child: Consumer<PresaleProvider>(
                builder: (context, value, child) {

                  return Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: value.presaleOrderInfo.length,
                      itemBuilder: (context, index) {
                        return value.presaleOrderInfo.isEmpty
                        ? SvgPicture.asset(
                          AppConfig.iconsPath+'no_data.svg',
                          width: 180,
                          height: 180,
                        )
                        : Container(
                            margin: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: isDarkTheme
                                ? hexaCodeToColor(AppColors.darkCard)
                                : hexaCodeToColor(AppColors.whiteColorHexa),
                            ),
                            child: Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                _customColumn(
                                  context,
                                  'Order Id : ${value.presaleOrderInfo[index].id}',
                                  'Amount : ${value.presaleOrderInfo[index].amount}'
                                ),
                                _customColumn(
                                  context,
                                  '${value.presaleOrderInfo[index].redeemDateTime}',
                                  '',
                                  topTextSize: 14.0,
                                  crossAxis: CrossAxisAlignment.end,
                                  bottomWidget:value.presaleOrderInfo[index].isClaimed
                                  ? ElevatedButton(
                                      onPressed: null,
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(hexaCodeToColor(AppColors.secondary).withOpacity(0)
                                        ),
                                      ),
                                      child: Text(
                                        'CLAIMED',
                                        style: TextStyle(
                                          color: hexaCodeToColor(AppColors.secondary)
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                      !value.presaleOrderInfo[index].isBefore
                                        ? hexaCodeToColor(AppColors.secondary)
                                        : Colors.grey[300]
                                      ),
                                      shadowColor: MaterialStateProperty.all(
                                        !value.presaleOrderInfo[index].isBefore
                                          ? hexaCodeToColor(AppColors.secondary)
                                          : hexaCodeToColor(AppColors.secondary).withOpacity(0)
                                      )
                                    ),
                                    onPressed: value.presaleOrderInfo[index].isBefore
                                    ? () {}
                                    : () => submitRedeem(
                                      context,
                                      value.presaleOrderInfo[index].id
                                    ),
                                    child: Text('REDEEM'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      )
                    );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _customColumn(context, String topText, String bottomText, {Widget? bottomWidget, double? topTextSize, CrossAxisAlignment? crossAxis}) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: crossAxis ?? CrossAxisAlignment.start,
      children: [
        Expanded(
          child: MyText(
            textAlign: TextAlign.left,
            fontSize: topTextSize ?? 16.0,
            color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
            //fontWeight: FontWeight.w700,
            text: topText,
          )
        ),
        Expanded(
          child: Center(
            child: bottomWidget ??
            MyText(
              textAlign: TextAlign.left,
              fontSize: 16.0,
              color:
                  isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
              // fontWeight: FontWeight.w700,
              text: bottomText,
            )
          )
        ),
      ],
    );
  }
}
