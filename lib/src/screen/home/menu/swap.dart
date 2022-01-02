import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

class Swap extends StatefulWidget {
  @override
  _SwapState createState() => _SwapState();
}

class _SwapState extends State<Swap> {

  FlareControls flareController = FlareControls();
  final GlobalKey<FormState> _swapKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  TextEditingController? _amountController;

  bool _success = false, _enableBtn = false;

  String? gasPerTrx;

  // Future<void> approve() async {
  //   final contract = Provider.of<ContractProvider>(context, listen: false);

  //   await dialogBox().then((value) async {
  //     try {
  //       final res = await getPrivateKey(value);

  //       if (res != null) {
  //         dialogLoading(context);
  //         final hash = await contract.approveSwap(res);
  //         if (hash != null) {
  //           contract.getBscBalance();
  //           Navigator.pop(context);
  //           enableAnimation('approved balance to swap.', 'Continue swap', () {
  //             Navigator.pop(context);
  //             if (_swapKey.currentState.validate()) {
  //               FocusScopeNode currentFocus = FocusScope.of(context);

  //               if (!currentFocus.hasPrimaryFocus) {
  //                 currentFocus.unfocus();
  //               }

  //               validateSwap();

  //               // successDialog('');

  //             }
  //           });
  //         }
  //       }
  //     } catch (e) {
  //       Navigator.pop(context);
  //       await customDialog('Oops', e.message.toString());
  //     }
  //   });
  // }

  Future<String>? approve(String pKey) async {
    print("approve");
    String? _hash;
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      _hash = await contract.approveSwap(pKey);
      print(_hash);
    } catch (e) {
      Navigator.pop(context);
      if (e.toString() == 'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Opps', e.toString());
      }
    }
    return _hash!;
  }

  Future<String>? swap(String pKey) async {
    print("Swap");
    String? _hash;
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      _hash = await contract.swap(_amountController!.text, pKey);
    } catch (e) {
      Navigator.pop(context);
      // print(e.message);

      if (e.toString() == 'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Transaction failed', 'Something went wrong with your transaction.');
        // await customDialog('Opps', e.message.toString());
      }
    }

    return _hash!;
  }

  Future<void> approveAndSwap() async {
    print("approveAndSwap");
    try {
      final contract = Provider.of<ContractProvider>(context, listen: false);

      await dialogBox().then((value) async {
        final res = await AppServices.getPrivateKey(value, context);
        print("res $res");
        if (res != null) {
          dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");
          final approveHash = await approve(res);

          if (approveHash != null) {
            // await Future.delayed(Duration(seconds: 10));
            final approveStatus = await contract.getSwap.listenTransfer(approveHash);

            if (approveStatus!) {
              final resAllow = await ContractProvider().checkAllowance();

              if (resAllow.toString() != '0') {
                final swapHash = await swap(res);

                if (swapHash != null) {
                  final isSuccess = await contract.getSwap.listenTransfer(swapHash);

                  if (isSuccess!) {
                    Navigator.pop(context);
                    enableAnimation(
                      'swapped ${_amountController!.text} of SEL v1 to SEL v2.',
                      'Go to wallet', () {
                      Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
                    });
                    _amountController!.text = '';
                    setState(() {});
                  } else {
                    Navigator.pop(context);
                    await customDialog('Transaction failed',
                        'Something went wrong with your transaction.');
                  }
                }
              } else {
                Navigator.pop(context);
                await customDialog('Transaction failed',
                    'Something went wrong with your transaction.');
              }
            } else {
              Navigator.pop(context);
              await customDialog('Transaction failed',
                  'Something went wrong with your transaction.');
            }
          }
        }
      });
    } catch (e) {}
  }

  Future<void> swapWithoutAp() async {
    print("swapWithoutAp");
    final contract = Provider.of<ContractProvider>(context, listen: false);
    print("contract.listContract[1].address! ${contract.listContract[1].address!}");
    await dialogBox().then((value) async {
      try {
        final res = await AppServices.getPrivateKey(value, context);

        if (res != '') {
          dialogLoading(context);
          final String? hash = await contract.swap(_amountController!.text, res!);
          if (hash != null) {
            await Future.delayed(const Duration(seconds: 7));
            final res = await contract.getSwap.listenTransfer(hash);

            if (res != null) {
              if (res) {
                setState(() {});
                _amountController!.text = '';
                Navigator.pop(context);
                enableAnimation('swapped ${_amountController!.text} of SEL v1 to SEL v2.', 'Go to wallet', () {
                  Navigator.pushNamedAndRemoveUntil(
                    context, Home.route, ModalRoute.withName('/')
                  );
                });
              } else {
                Navigator.pop(context);
                await customDialog('Transaction failed', 'Something went wrong with your transaction.');
              }
            } else {
              Navigator.pop(context);
              await customDialog('Transaction failed', 'Something went wrong with your transaction.');
            }
          } else {
            // contract.getBscBalance();
            // contract.getBscV2Balance();
            Navigator.pop(context);
          }
        }
      } catch (e) {
        print("Error swapWithoutAp $e");
        Navigator.pop(context);
        await customDialog('Opps', e.toString());
      }
    });
  }

  Future<void> confirmFunction() async {
    print("confirmFunction");
    try {

      dialogLoading(context);
      final res = await Provider.of<ContractProvider>(context, listen: false).checkAllowance();

      print(res);

      if (res.toString() == '0') {
        Navigator.pop(context);
        await approveAndSwap();
      } else {
        Navigator.pop(context);

        await swapWithoutAp();
      }
    } catch (e) {
      print("Error confirmFunction $e");
    }
  }

  void validateSwap() async {
    // Loading
    dialogLoading(context);

    final contract = Provider.of<ContractProvider>(context, listen: false);

    final maxGas = await contract.getBep20MaxGas(contract.listContract[0].address!, "0x6871EB5dB4554dB54276D5E5d24f17B9E9dF95F3", _amountController!.text);
    print("maxGas $maxGas");
    final EtherAmount? ress = await contract.getBscGasPrice();
    final gasPrice = ress!.getValueInUnit(EtherUnit.gwei).toString();
    final gasFee = double.parse(maxGas) * double.parse(gasPrice);
    final estGasFeePrice = (gasFee / pow(10, 9)).toString();
    gasPerTrx = estGasFeePrice;
    setState(() { });

    if (double.parse(_amountController!.text) > double.parse(contract.listContract[0].balance!) ||  double.parse(contract.listContract[0].balance!) == 0) {
      // Close Loading
      Navigator.pop(context);
      customDialog('Insufficient Balance', 'Your loaded balance is not enough to swap.');
    } else {
      Navigator.pop(context);
      await confirmDialog(_amountController!.text, await swap);
    }
  }

  Future enableAnimation(String operationText, String btnText, Function onPressed) async {
    setState(() {
      _success = true;
    });
    flareController.play('Checkmark');

    Timer(const Duration(milliseconds: 3), () {
      // Navigator.pop(context);
      setState(() {
        _success = false;
      });

      successDialog(operationText, btnText, onPressed);
    });
  }

  /* Show Pin Code For Fill Out */
  Future<String> dialogBox() async {
    final String _result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: FillPin(),
          );
        });
    return _result;
  }

  Future<void> customDialog(String text1, String text2) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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

  // After Swap
  Future<void> successDialog(
      String operationText, String btnText, Function onPressed) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                    'assets/icons/tick.svg',
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

  Future<void> confirmDialog(String amount, Function swap) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  const MyText(
                    text: 'Swapping',
                    //color: '#000000',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SvgPicture.asset(
                    'assets/icons/arrow.svg',
                    height: 100,
                    width: 100,
                    color: hexaCodeToColor(AppColors.secondary),
                  ),
                  const MyText(
                    text: 'SEL v1 to SEL v2',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    top: 40,
                    bottom: 8.0,
                  ),
                  MyText(
                    textAlign: TextAlign.left,
                    text: 'Amount: $amount of SEL v1',
                    fontSize: 16,
                  ),
                  
                  MyText(
                    textAlign: TextAlign.left,
                    text: 'Fee: $gasPerTrx',
                    fontSize: 16,
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await confirmFunction();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              hexaCodeToColor(AppColors.secondary)),
                          foregroundColor: MaterialStateProperty.all(
                              hexaCodeToColor(AppColors.secondary)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)))),
                      child: Text(
                        'CONFIRM',
                        style: TextStyle(
                          color: hexaCodeToColor('#ffffff'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _amountController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _amountController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final contract = Provider.of<ContractProvider>(context, listen: false);
    return Scaffold(
      body: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  MyAppBar(
                    title: "Swap SEL v2",
                    color: isDarkTheme
                      ? hexaCodeToColor(AppColors.darkCard)
                      : hexaCodeToColor(AppColors.whiteHexaColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    children: [
                      MyText(
                        width: double.infinity,
                        text: contract.listContract[0].balance == null
                          ? 'Available Balance:  ${AppString.loadingPattern} SEL v1'
                          : 'Available Balance:  ${contract.listContract[0].balance} SEL v1',
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                            ? AppColors.darkSecondaryText
                            : AppColors.textColor,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        bottom: 20.0,
                        top: 16.0,
                        left: 16.0,
                      ),

                      // Swap Contents
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                            ? hexaCodeToColor(AppColors.darkCard)
                            : hexaCodeToColor(AppColors.whiteHexaColor),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [shadow(context)]
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                    ? hexaCodeToColor(AppColors.darkBgd)
                                    : hexaCodeToColor(AppColors.whiteColorHexa),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Form(
                                  key: _swapKey,
                                    child: Column(
                                      children: [
                                        
                                        MyText(
                                          width: double.infinity,
                                          text: 'Amount',
                                          fontWeight: FontWeight.bold,
                                          color: isDarkTheme
                                            ? AppColors.darkSecondaryText
                                            : AppColors.textColor,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          bottom: 4.0,
                                        ),

                                        Flexible(
                                          child: Container(
                                          // alignment: Alignment.bottomLeft,
                                          child: TextFormField(
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(TextField.noMaxLength),
                                              FilteringTextInputFormatter(RegExp(r"^\d+\.?\d{0,8}"), allow: true)
                                            ],
                                            controller: _amountController,
                                            keyboardType: Platform.isAndroid
                                              ? TextInputType.number
                                              : TextInputType.text,
                                            textInputAction: TextInputAction.done,
                                            style: TextStyle(
                                              color: isDarkTheme
                                                ? hexaCodeToColor(AppColors.whiteColorHexa)
                                                : hexaCodeToColor(AppColors.textColor),
                                              fontSize: 18.0
                                            ),
                                            decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () async {
                                                  await fetchMax();
                                                },
                                                child: MyText(
                                                  text: 'Max',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.secondarytext,
                                                ),
                                              ),
                                              prefixIconConstraints: BoxConstraints(
                                                minWidth: 0,
                                                minHeight: 0,
                                              ),
                                              border: InputBorder.none,
                                              hintText: '0.00',
                                              hintStyle: TextStyle(
                                                fontSize: 20.0,
                                                color: isDarkTheme
                                                  ? hexaCodeToColor(AppColors.darkSecondaryText)
                                                  : hexaCodeToColor(AppColors.textColor).withOpacity(0.3),
                                              ),
                                            ),
                                            validator: (value) => value!.isEmpty
                                              ? 'Please fill in amount'
                                              : null,
                                            /* Limit Length Of Text Input */
                                            onChanged: (String value) {
                                              if (value.isNotEmpty) {
                                                setState(() {});
                                                _enableBtn = true;
                                              } else {
                                                setState(() {});
                                                _enableBtn = false;
                                              }
                                            },
                                            onFieldSubmitted: (value) {},
                                          ),
                                        )
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              // Swap Button
                              MyFlatButton(
                                edgeMargin: const EdgeInsets.only(bottom: 16),
                                textButton: 'Swap',
                                action: !_enableBtn
                                  ? null
                                  : () async {
                                  if (_swapKey.currentState!.validate()) {
                                    FocusScopeNode currentFocus = FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }

                                    validateSwap();
                                  }
                                },
                              ),
                              SwapDescription(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_success == false)
                Container()
              else
                BackdropFilter(
                  // Fill Blur Background
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: CustomAnimation.flareAnimation(
                          flareController,
                          "assets/animation/check.flr",
                          "Checkmark",
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )),
    );
  }

  Future<void> fetchMax() async {
    dialogLoading(context, content: 'Fetching Balance');

    final contract = Provider.of<ContractProvider>(context, listen: false);

    await contract.selTokenWallet();

    setState(() {
      _amountController!.text = contract.listContract[0].balance!;
      _enableBtn = true;
    });

    // Close Dialog
    Navigator.pop(context);
  }
}
