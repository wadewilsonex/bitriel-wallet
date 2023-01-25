import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/presentation/home/home/home.dart';

class ConfirmationTx extends StatefulWidget {

  final ModelScanPay? scanPayM;
  final TransactionInfo? trxInfo;
  final Function? sendTrx;
  // final String? gasFeetoEther;
  const ConfirmationTx({
    Key? key,
    required this.scanPayM,
    this.trxInfo,
    this.sendTrx
    // this.gasFeetoEther,
  }) : super(key: key);

  @override
  State<ConfirmationTx> createState() => _ConfirmationTxState();
}

class _ConfirmationTxState extends State<ConfirmationTx> {

  final pTop = 2.4;

  Future enableAnimation({BuildContext? context}) async {

    Navigator.pop(context!);
    setState(() {
      widget.scanPayM!.isPay = true;
      // disable = true;
    });
    // flareController.play('Checkmark');
    await Future.delayed(const Duration(seconds: 3), (){});
    if(!mounted) return;
    Navigator.pushAndRemoveUntil(context, Transition(child: const HomePage(isTrx: true,)), ModalRoute.withName('/'));
    // await successDialog(context, "transferred the funds.", route: HomePage(activePage: 1,));
  }

  @override
  Widget build(BuildContext context) {

     
    dynamic addr;
    if (widget.trxInfo!.receiver != null){
      addr = AppUtils.addrFmt(widget.trxInfo!.receiver.toString());
    }
    // print("sendTrx ${sendTrx ?? 'sendTrx null'}");
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [ 

            Column(
              children: [
          
                MyAppBar(
                  title: AppString.confirmTxTitle,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: isDarkMode
                    ? hexaCodeToColor(AppColors.darkCard)
                    : hexaCodeToColor(AppColors.whiteHexaColor),
                ),
          
                Expanded(
                  child: Column(
                      children: [
          
                        MyText(
                          top: 4.8.vmax,
                          text: AppString.amtToSend,
                          fontSize: 2.9,
                          hexaColor: isDarkMode ? AppColors.darkSecondaryText : AppColors.textColor,
                        ),
          
                        MyText(
                          top: 30,
                          text: '${widget.trxInfo!.amount} ${widget.trxInfo!.coinSymbol}',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                          hexaColor: isDarkMode ? AppColors.whiteColorHexa : AppColors.textColor,
                        ),
                        
                        MyText(
                          top: 8.0,
                          text: '≈ \$${widget.trxInfo!.estTotalPrice}',//trxInfo!.estAmountPrice != null ? '≈ ${trxInfo!.estAmountPrice}' : '≈ \$0.00', //'≈ \$0.00',
                          hexaColor: AppColors.darkSecondaryText,
                        ),
          
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Divider(
                          color: isDarkMode ? hexaCodeToColor(AppColors.whiteColorHexa) : hexaCodeToColor(AppColors.darkSecondaryText),
                          height: 1.0,
                        ),
          
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: pTop.vmax, vertical: 28.0),
                          child: Column(
                            children: [
                              // Send To
                              spaceRow([
                                MyText(
                                  text: AppString.to,
                                  fontSize: 2.4,
                                  hexaColor: isDarkMode ? AppColors.darkSecondaryText : AppColors.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                MyText(
                                  textAlign: TextAlign.left,
                                  text: addr ?? '',
                                  // bottom: 8.0,
                                  overflow: TextOverflow.ellipsis,
                                  hexaColor: isDarkMode
                                    ? AppColors.darkSecondaryText
                                    : AppColors.textColor,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ]),
        
                              // Gas Fee
                              spaceRow([
                                MyText(
                                  text: AppString.gasFee,
                                  fontSize: 2.4,
                                  top: 8.0,
                                  fontWeight: FontWeight.bold,
                                  hexaColor: isDarkMode
                                    ? AppColors.darkSecondaryText
                                    : AppColors.textColor,
                                ),
                                Column(
                                  children: [
                                    MyText(
                                      text: widget.trxInfo!.gasFee,
                                      fontSize: 2.9,
                                      top: 8.0,
                                      fontWeight: FontWeight.bold,
                                      hexaColor: isDarkMode
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
                                  text: '${AppString.gasPrice} ${widget.trxInfo!.gasPriceUnit}:',
                                  hexaColor: isDarkMode
                                    ? AppColors.darkSecondaryText
                                    : AppColors.textColor,
                                  //fontWeight: FontWeight.bold,
                                ),
                                MyText(
                                  top: pTop.vmax,
                                  text: '  ${widget.trxInfo!.gasPrice}',
                                  fontWeight: FontWeight.bold,
                                  hexaColor: isDarkMode
                                    ? AppColors.whiteColorHexa
                                    : AppColors.textColor,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ]),
                              spaceRow([
                                MyText(
                                  top: pTop.vmax,
                                  text: AppString.gasLimit,
                                  fontWeight: FontWeight.bold,
                                  hexaColor: isDarkMode
                                    ? AppColors.darkSecondaryText
                                    : AppColors.textColor,
                                ),
                                MyText(
                                  top: pTop.vmax,
                                  text: '  ${widget.trxInfo!.maxGas}',
                                  hexaColor: isDarkMode
                                    ? AppColors.whiteColorHexa
                                    : AppColors.textColor,
                                ),
                              ])
                            ],
                          ),
                        ),
                        
                        Divider(
                          color: isDarkMode
                            ? hexaCodeToColor(AppColors.whiteColorHexa)
                            : hexaCodeToColor(AppColors.darkSecondaryText),
                          height: 1.0,
                        ),
        
                        const MyText(
                          top: 8.0,
                          text: AppString.amtPGasFee,
                          fontSize: 2.4,
                          hexaColor: AppColors.darkSecondaryText,
                          //fontWeight: FontWeight.bold,
                        ),
                        
                        Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: paddingSize,
                              // vertical: 28.0,
                            ),
                            child: spaceRow([
                              MyText(
                                text: AppString.total,
                                fontWeight: FontWeight.bold,
                                hexaColor: isDarkMode
                                  ? AppColors.darkSecondaryText
                                  : AppColors.textColor,
                                //fontWeight: FontWeight.bold,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MyText(
                                    top: 8.0,
                                    text: double.parse(widget.trxInfo!.totalAmt!).toStringAsFixed(7).toString(),
                                    fontSize: 2.9,
                                    hexaColor: AppColors.secondary,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  MyText(
                                    top: 8.0,
                                    text: '≈ \$${widget.trxInfo!.estTotalPrice}', //'≈ \$0.00',
                                    hexaColor: AppColors.darkSecondaryText,
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
                      await widget.sendTrx!(widget.trxInfo, context: context).then((value){
                        if (value != null) {
                          enableAnimation(context: context);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),

            if (widget.scanPayM!.isPay == true)
            BackdropFilter(
              // Fill Blur Background
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Lottie.asset(
                        "assets/animation/check.json",
                        alignment: Alignment.center,
                        repeat: false,
                        width: 60.w,
                      )
                    ),
                  ],
                ),
              ),
            ),

          ]
        )
      ),
    );
  }

  Widget spaceRow(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}