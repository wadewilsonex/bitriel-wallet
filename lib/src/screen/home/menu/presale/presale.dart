import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/presale_m.dart';
import 'package:wallet_apps/src/provider/presale_p.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/body_presale.dart';

class Presale extends StatefulWidget {
  @override
  _PresaleState createState() => _PresaleState();
}

class _PresaleState extends State<Presale> {
  
  PresaleModel _model = PresaleModel();

  Future<String>? order(String pKey) async {

    String? _hash;
    dialogLoading(context);
    final presale = Provider.of<PresaleProvider>(context, listen: false);
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      final hash = await presale.orderUsingBnb(
        context: context,
        amount: double.parse(_model.amountController.text),
        privateKey: pKey,
        discountRate: _model.rate,
      );

      if (hash != null) {

        final stt = await contract.getBnb.listenTransfer(hash);

        if (stt!) {
          Navigator.pop(context);
          enableAnimation(
              'contributed ${_model.amountController.text} of ${_model.listSupportToken![_model.tokenIndex]['symbol']}.',
              'Go to wallet', () {
                
            Navigator.pushAndRemoveUntil(context, Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), ModalRoute.withName('/'));
          });
          _model.amountController.text = '';
          presale.initEstSel();
          presale.setListOrder();
          setState(() {});
        } else {
          Navigator.pop(context);
          await customDialog('Transaction failed',
              'Something went wrong with your transaction.');
        }
      }
    } catch (e) {
      Navigator.pop(context);
      if (e.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Opps', e.toString());
      }
    }
    return _hash!;
  }

  // Future<String> presale(String pKey) async {
  //   String _hash;
  //   final contract = Provider.of<ContractProvider>(context, listen: false);

  //   try {} catch (e) {
  //     Navigator.pop(context);
  //     // if (ApiProvider().isDebug == true) print(e.message);

  //     if (e.message.toString() ==
  //         'insufficient funds for gas * price + value') {
  //       await customDialog('Opps', 'Insufficient funds for gas');
  //     } else {
  //       await customDialog('Transaction failed',
  //           'Something went wrong with your transaction.');
  //       // await customDialog('Opps', e.message.toString());
  //     }
  //   }

  //   return _hash;
  // }

  Future<void> orderToken(String suppTokenAddr, String privateKey, double amount, int discountRate) async {
    try {
      final presale = Provider.of<PresaleProvider>(context, listen: false);
      final hash = await presale.orderUsingToken(
        context: context,
        suppTokenAddr: suppTokenAddr,
        privateKey: privateKey,
        amount: amount,
        discountRate: discountRate
      );

      if (hash != null) {

        // final stt = await contract.getPending(hash, nodeClient: contract.bscClient);

        // if (stt) {
        //   Navigator.pop(context);
        //   enableAnimation(
        //       'contributed ${_model.amountController.text} of ${_model.listSupportToken[_model.tokenIndex]['symbol']}.',
        //       'Go to wallet', () {
        //     Navigator.pushNamedAndRemoveUntil(
        //         context, Home.route, ModalRoute.withName('/'));
        //   });
        //   _model.amountController.text = '';
        //   presale.initEstSel();
        //   presale.setListOrder();
        //   setState(() {});
        // } else {
        //   Navigator.pop(context);
        //   await customDialog('Transaction failed',
        //       'Something went wrong with your transaction.');
        // }
      }
    } catch (e) {
      Navigator.pop(context);

      if (e.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Transaction failed',
            'Something went wrong with your transaction.');
      }
    }
  }

  Future<void> approveAndOrderToken(String privateKey, String tokenAddress,
      double amount, int discountRate) async {
    final presale = Provider.of<PresaleProvider>(context, listen: false);

    final String? approveHash = await presale.approvePresale(privateKey, tokenAddress);

    if (approveHash != null) {
      // final stt = await contract.getPending(approveHash,
      //     nodeClient: contract.bscClient);

      // if (stt) {
      //   await orderToken(tokenAddress, privateKey, amount, discountRate);
      // } else {
      //   Navigator.pop(context);
      //   await customDialog('Transaction failed',
      //       'Something went wrong with your transaction.');
      // }
    }
  }

  Future<String>? getPrivateKey(String pin) async {
    String? privateKey;
    final encryptKey = await StorageServices().readSecure(DbKey.private);
    try {
      if (encryptKey != ''){
        privateKey = await Provider.of<ApiProvider>(context, listen: false).decryptPrivateKey(encryptKey!, pin);
      }
    } catch (e) {
      await customDialog('Opps', 'PIN verification failed');
    }

    return privateKey!;
  }

  void validatePresale() async {
    // Loading
    dialogLoading(context);

    final contract = Provider.of<ContractProvider>(context, listen: false);

    if (double.parse(_model.amountController.text) >
            double.parse(contract.listContract[0].balance!) ||
        double.parse(contract.listContract[0].balance!) == 0) {
      // Close Loading
      Navigator.pop(context);
      customDialog('Insufficient Balance',
          'Your loaded balance is not enough to Presale.');
    } else {
      Navigator.pop(context);
      // confirmDialog(_model.amountController.text, Presale);
    }
  }

  Future enableAnimation(String operationText, String btnText, Function onPressed) async {
    setState(() {
      _model.success = true;
    });

    _model.flareController.play('Checkmark');

    Timer(const Duration(milliseconds: 3), () {
      // Navigator.pop(context);
      setState(() {
        _model.success = false;
      });

      successDialog(operationText, btnText, onPressed);
    });
  }

  Future<String> dialogBox() async {
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

  // After Presale
  Future<void> successDialog(String operationText, String btnText, Function onPressed) async {
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

  void rateChange(int index) {
    _model.rateIndex = index;
    if (index == 1) {
      _model.rate = 10;
    } else if (index == 2) {
      _model.rate = 20;
    } else {
      _model.rate = 30;
    }

    setState(() {});
  }

  void onChanged(String value) {
    final presale = Provider.of<PresaleProvider>(context, listen: false);

    if (_model.amountController.text.isNotEmpty) {
      _model.canSubmit = true;
      setEstSel();
    } else if (_model.canSubmit && _model.amountController.text.isEmpty) {
      _model.canSubmit = false;
      presale.setInitEstSel();
    }
    setState(() {});
  }

  void setEstSel() {
    final presale = Provider.of<PresaleProvider>(context, listen: false);

    //presale.calEstimateSel(, 429.000, _model.rate);
    if (_model.amountController.text != '') {
      presale.calEstimateSel(_model.amountController.text, _model.listSupportToken![_model.tokenIndex]['price'], _model.rate);
    }
  }

  void onChangedDropDown(String value) {
    _model.symbol = value;
    for (int i = 0; i < _model.listSupportToken!.length; i++) {
      if (_model.listSupportToken![i]['symbol'] == value) {
        _model.tokenIndex = i;
      }
    }
    setState(() {});
  }

  Future<void> priceChecker() async {
    try {

      final presale = Provider.of<PresaleProvider>(context, listen: false);
      final contract = Provider.of<ContractProvider>(context, listen: false);

      _model.totalInvestment = double.parse(_model.amountController.text) * _model.listSupportToken![_model.tokenIndex]['price'];
      
      await presale.minInvestment().then((value) async {
        /// The minInvestment function return value type _BigIntImpl
        ///
        /// To Convert To Double we need to use toDouble()
        ///

        final res = presale.calAmtPrice(_model.amountController.text, _model.listSupportToken![_model.tokenIndex]['price']);

        if (res < value.first.toDouble()) {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                title: Align(
                  child: Text('Message'),
                ),
                content: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text("Your order amount less than minimum investment!"),
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
        // Can Order Presale
        else {
          //get user pin
          final res = await dialogBox();

          //check if pin null
          //get user pKey
          final privateKey = await AppServices.getPrivateKey(res, context);

          if (privateKey != null && privateKey != 'Failed to get string encoded: \'Decrypt failure.\'.') {
            if (_model.tokenIndex == 0) {
              // await contract.getBnbBalance();

              if (double.parse(contract.listContract[4].balance!) < double.parse(_model.amountController.text)) {
                customDialog('Insufficient Balance', 'Your loaded balance is not enough.');
              } else {
                await order(privateKey);
              }
            } else {
              final tokenBalance = await presale.checkTokenBalance(_model.listSupportToken![_model.tokenIndex]['tokenAddress'], context: context);

              if (tokenBalance < double.parse(_model.amountController.text)) {
                customDialog('Insufficient Balance',
                    'Your loaded balance is not enough.');
              } else {
                await checkIsAllownce(privateKey);
              }
            }
          }
        }
      });
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error priceChecker $e");
    }
  }

  Future<void> checkIsAllownce(String pKey) async {
    try {

      dialogLoading(context);

      final presale = Provider.of<PresaleProvider>(context, listen: false);
      final res = await presale.checkAllowance(_model.listSupportToken![_model.tokenIndex]['tokenAddress']);

      if (res.toString() == '0' || res.toString() != '1000000000000000042420637374017961984') {
        await approveAndOrderToken(
          pKey,
          _model.listSupportToken![_model.tokenIndex]['tokenAddress'],
          double.parse(_model.amountController.text),
          _model.rate
        );
      } else {
        await orderToken(
          _model.listSupportToken![_model.tokenIndex]['tokenAddress'],
          pKey,
          double.parse(_model.amountController.text),
          _model.rate
        );
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error checkIsAllownce $e");
    }
  }

  Future<void> submitPresale() async {
    try {

      final contract = Provider.of<ContractProvider>(context, listen: false);
      final presale = Provider.of<PresaleProvider>(context, listen: false);
      if (_model.canSubmit == false) {
        snackBar(context, "Please fill out all field");
      } else {
        if (_model.tokenIndex == 0) {
          dialogLoading(context);
          // await contract.getBnbBalance();

          if (double.parse(contract.listContract[4].balance!) <
              double.parse(_model.amountController.text)) {
            Navigator.pop(context);
            customDialog('Insufficient Balance', 'Your loaded balance is not enough.');
          } else {
            Navigator.pop(context);
            await priceChecker();
          }
        } else {
          dialogLoading(context);
          final tokenBalance = await presale.checkTokenBalance(_model.listSupportToken![_model.tokenIndex]['tokenAddress'], context: context);

          if (tokenBalance < double.parse(_model.amountController.text)) {
            Navigator.pop(context);
            customDialog('Insufficient Balance', 'Your loaded balance is not enough.');
          } else {
            Navigator.pop(context);
            await priceChecker();
          }
        }
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error submitPresale $e");
    }
  }

  void initMethod() async {
    try {

      final contract = Provider.of<ContractProvider>(context, listen: false);
      final _presale = await Provider.of<PresaleProvider>(context, listen: false);
      await _presale.initPresaleContract();
      _presale.setConProvider = contract;
      // _presale.getBNBPrice();
      // await contract.getBnbBalances();

      _model.balance = double.parse(contract.listContract[4].balance!);
      _model.listSupportToken = await Provider.of<PresaleProvider>(context, listen: false).fetchAndFillPrice(_model.listSupportToken!);
      // if (ApiProvider().isDebug == true) print("_model.listSupportToken ${_model.listSupportToken}");
      // await Provider.of<PresaleProvider>(context, listen: false).setListOrder();

      //await Provider.of<PresaleProvider>(context, listen: false).getOrders(3);
      if (!mounted) return;

      setState(() {});
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error initMethod $e");
    }
  }

  @override
  void initState() {
    if (mounted) initMethod();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _model.amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PresaleBody(
        model: _model,
        onRateChange: rateChange,
        onChange: onChanged,
        submitPresale: submitPresale,
      ),
    );
  }
}
