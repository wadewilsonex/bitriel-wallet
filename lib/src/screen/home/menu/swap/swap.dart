import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/menu/swap/body_swap.dart';
import 'package:wallet_apps/src/screen/home/menu/swap/des_swap.dart';

class Swap extends StatefulWidget {
  @override
  _SwapState createState() => _SwapState();
}

class _SwapState extends State<Swap> {

  SwapModel _swapModel = SwapModel();
  
  Future<String>? approve(String pKey) async {
    String? _hash;
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      _hash = await contract.approveSwap(pKey);
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
    String? _hash;
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      _hash = await contract.swap(_swapModel.amountController!.text, pKey);
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
    try {
      final contract = Provider.of<ContractProvider>(context, listen: false);

      await dialogBox().then((value) async {
        final res = await AppServices.getPrivateKey(value, context);
        if (res != '') {
          dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");
          final approveHash = await approve(res!);

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
                        'swapped ${_swapModel.amountController!.text} of SEL v1 to SEL v2.',
                        'Go to wallet', () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Home.route, ModalRoute.withName('/'));
                    });
                    _swapModel.amountController!.text = '';
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
    final contract = Provider.of<ContractProvider>(context, listen: false);
    await dialogBox().then((value) async {
      try {
        final res = await AppServices.getPrivateKey(value, context);
        if (res != '') {
          dialogLoading(context);
          final String? hash = await contract.swap(_swapModel.amountController!.text, res!);
          if (hash != null) {
            await Future.delayed(const Duration(seconds: 7));
            final res = await contract.getSwap.listenTransfer(hash);

            if (res != null) {
              if (res) {
                setState(() {});
                Navigator.pop(context);
                enableAnimation(
                  'swapped ${_swapModel.amountController!.text} of SEL v1 to SEL v2.',
                  'Go to wallet', () {
                  Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
                });
                _swapModel.amountController!.text = '';
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
      } catch (e) {
        Navigator.pop(context);
        await customDialog('Opps', e.toString());
      }
    });
  }

  Future<void> confirmFunction() async {
    try {

      dialogLoading(context);
      final res = await Provider.of<ContractProvider>(context, listen: false).checkAllowance();

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
    print("validateSwap");
    // Loading
    dialogLoading(context);

    final contract = Provider.of<ContractProvider>(context, listen: false);

    if (double.parse(_swapModel.amountController!.text) > double.parse(contract.listContract[ApiProvider().selV1Index].balance!) ||  double.parse(contract.listContract[ApiProvider().selV1Index].balance!) == 0) {
      // Close Loading
      Navigator.pop(context);
      customDialog('Insufficient Balance', 'Your loaded balance is not enough to swap.');
    } else {
      Navigator.pop(context);
      await confirmDialog(_swapModel.amountController!.text, await swap);
    }
  }

  Future enableAnimation(String operationText, String btnText, Function onPressed) async {
    setState(() {
      _swapModel.success = true;
    });
    _swapModel.flareController!.play('Checkmark');

    Timer(const Duration(milliseconds: 3), () {
      // Navigator.pop(context);
      setState(() {
        _swapModel.success = false;
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

  // After Swap
  Future<void> successDialog(String operationText, String btnText, Function onPressed) async {
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

  Future<void> confirmDialog(String amount, Function swap) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                    AppConfig.iconsPath+'arrow.svg',
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
                    text: '$amount of SEL v1',
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

  void onChanged(String value){
    if (value.isNotEmpty) {
      _swapModel.enableBtn = true;
    } else if (_swapModel.enableBtn == true){
      _swapModel.enableBtn = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    _swapModel.amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _swapModel.amountController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwapBody(
      swapModel: _swapModel,
      onChanged: onChanged,
      fetchMax: fetchMax,
      validateSwap: validateSwap,
    );
  }

  Future<void> fetchMax(BuildContext context) async {
    dialogLoading(context, content: 'Fetching Balance');

    final contract = Provider.of<ContractProvider>(context, listen: false);

    await contract.selTokenWallet(context);

    setState(() {
      _swapModel.amountController!.text = contract.listContract[ApiProvider().selV1Index].balance!;
      _swapModel.enableBtn = true;
    });

    // Close Dialog
    Navigator.pop(context);
  }
}
