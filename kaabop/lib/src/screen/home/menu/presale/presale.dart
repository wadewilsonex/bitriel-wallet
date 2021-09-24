import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/presale_m.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/body_presale.dart';
import 'package:wallet_apps/src/screen/home/menu/presale/des_presale.dart';

class Presale extends StatefulWidget {
  @override
  _PresaleState createState() => _PresaleState();
}

class _PresaleState extends State<Presale> {

  PresaleModel _model = PresaleModel();

  Future<String> approve(String pKey) async {
    String _hash;
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      // final hash = await contract.approvePresale(pKey);

      // if (hash != null) {
      //   // _hash = hash;
      // }
    } catch (e) {
      Navigator.pop(context);
      if (e.message.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Opps', e.message.toString());
      }
    }
    return _hash;
  }

  Future<String> Presale(String pKey) async {
    String _hash;
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      // final hash = await contract.Presale(_amountController.text, pKey);
      // if (hash != null) {
      //   // _hash = hash;
      // }
    } catch (e) {
      Navigator.pop(context);
      // print(e.message);

      if (e.message.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Transaction failed',
            'Something went wrong with your transaction.');
        // await customDialog('Opps', e.message.toString());
      }
    }

    return _hash;
  }

  Future<void> approveAndPresale() async {
    final contract = Provider.of<ContractProvider>(context, listen: false);

    await dialogBox().then((value) async {
      final res = await getPrivateKey(value);

      if (res != null) {
        dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");
        final approveHash = await approve(res);

        print('Approve: $approveHash');

        if (approveHash != null) {
          // await Future.delayed(Duration(seconds: 10));
          final approveStatus = await contract.getPending(approveHash, nodeClient: contract.bscClient);
          print(' approve stat: $approveStatus');

          if (approveStatus) {
            final resAllow = await ContractProvider().checkAllowance();
            print(resAllow);

            if (resAllow.toString() != '0') {
              final PresaleHash = await Presale(res);

              if (PresaleHash != null) {
                final isSuccess = await contract.getPending(PresaleHash, nodeClient: contract.bscClient);

                if (isSuccess) {
                  Navigator.pop(context);
                  enableAnimation( 'Presaleped ${_model.amountController.text} of SEL v1 to SEL v2.', 'Go to wallet', () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Home.route, ModalRoute.withName('/'));
                  });
                  _model.amountController.text = '';
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
  }


  Future<void> confirmFunction() async {
    dialogLoading(context);
    final res = await ContractProvider().checkAllowance();

    print(res);

    if (res.toString() == '0') {
      Navigator.pop(context);
      approveAndPresale();
    } else {
      Navigator.pop(context);
      print('Presale without approve');
      // PresaleWithoutAp();
    }
  }

  Future<String> getPrivateKey(String pin) async {
    String privateKey;
    final encrytKey = await StorageServices().readSecure('private');
    try {
      privateKey = await ApiProvider.keyring.store.decryptPrivateKey(encrytKey, pin);
    } catch (e) {
      await customDialog('Opps', 'PIN verification failed');
    }

    return privateKey;
  }

  void validatePresale() async {
    // Loading
    dialogLoading(context);

    final contract = Provider.of<ContractProvider>(context, listen: false);

    if (double.parse(_model.amountController.text) >
            double.parse(contract.listContract[0].balance) ||
        double.parse(contract.listContract[0].balance) == 0) {
      // Close Loading
      Navigator.pop(context);
      customDialog(
          'Insufficient Balance', 'Your loaded balance is not enough to Presale.');
    } else {
      Navigator.pop(context);
      // confirmDialog(_model.amountController.text, Presale);
    }
  }

  Future enableAnimation(
      String operationText, String btnText, Function onPressed) async {
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

  // After Presale
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
                            backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                            foregroundColor: MaterialStateProperty.all(hexaCodeToColor(AppColors.secondary)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                              )
                          ),
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
                          onPressed: onPressed,
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

  void rateChange(int index){
    _model.rateIndex = index;
    if (index == 1){
      _model.rate = "10";
    } else if (index == 2){
      _model.rate = "20";
    } else {
      _model.rate = "30";
    }

    setState((){});
  }

  void onChanged(String value){
    if (_model.amountController.text.isNotEmpty){
      _model.canSubmit = true;
    } else if (_model.canSubmit){
      _model.canSubmit = false;
    }
  }

  void submitPresale() async {
    if (_model.canSubmit == false){
      snackBar(context, "Please fill out all field");
    } else {
      // await Component
    }
  }

  @override
  void initState() {
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
      body: BodyPresale(
        model: _model,
        onChanged: onChanged,
        rateChange: rateChange,
        submitPresale: submitPresale
      ),
    );
  }
}
