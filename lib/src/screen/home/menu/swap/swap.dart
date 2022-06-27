import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:wallet_apps/src/screen/home/menu/swap/body_swap.dart';
import 'package:wallet_apps/src/screen/home/menu/swap/des_swap.dart';

class Swap extends StatefulWidget {
  @override
  _SwapState createState() => _SwapState();
}

class _SwapState extends State<Swap> {

  SwapModel _swapModel = SwapModel();
  
  // Approve Function
  Future<String>? approve(String pKey) async {
    String? _hash;
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      _hash = await contract.approveSwap(pKey);
      print("My hash $_hash");
    } on Exception catch (e) {
      print("Error approve ${e.toString()}");
      Navigator.pop(context);
      if (e.toString() == 'RPCError: got code -32000 with msg "insufficient funds for gas * price + value"') {
        await DialogComponents().dialogCustom(context: context, titles: 'Opps', contents: 'Insufficient funds for gas'); //DialogComponents().dialogCustom(context: context, titles: , 'Insufficient funds for gas');
      } else {
        await DialogComponents().dialogCustom(context: context, titles: 'Opps', contents: e.toString()); //DialogComponents().dialogCustom(context: context, titles: 'Opps', e.toString());
      }
    }
    return _hash!;
  }

  // Swap Function 
  Future<String>? swap(String pKey) async {
    print("swap");
    String? _hash;
    final contract = Provider.of<ContractProvider>(context, listen: false);

    try {
      _hash = await contract.swap(_swapModel.amountController!.text, pKey);
    } catch (e) {
      print("Error swap $e");
      Navigator.pop(context);
      // if (ApiProvider().isDebug == true) print(e.message);

      if (e.toString() == 'RPCError: got code -32000 with msg "insufficient funds for gas * price + value"') {
        await DialogComponents().dialogCustom(context: context, titles: 'Opps', contents: 'Insufficient funds for gas');
      } else {
        await DialogComponents().dialogCustom(context: context, titles:  'Opps', contents: e.toString());
        // await DialogComponents().dialogCustom(context: context, titles: 'Opps', e.message.toString());
      }
    }

    return _hash!;
  }

  // Function That Call Approve And Then Call Swap
  Future<void> approveAndSwap() async {
    if (ApiProvider().isDebug) print("approveAndSwap");
    try {
      final contract = Provider.of<ContractProvider>(context, listen: false);

      await Navigator.push(context, Transition(child: Passcode(label: PassCodeLabel.fromSendTx), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)).then((resPin) async {
        print("resPin $resPin");
        if (resPin != null) {
          final res = await AppServices.getPrivateKey(resPin, context);
          if (res != '') {
            dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");
            final approveHash = await approve(res!);

            if (ApiProvider().isDebug) print("approveHash $approveHash");

            if (approveHash != null) {
              // await Future.delayed(Duration(seconds: 10));
              final approveStatus = await contract.getSwap.listenTransfer(approveHash);

              if (approveStatus!) {
                final resAllow = await ContractProvider().checkAllowance();

                if (resAllow.toString() == '0') {
                  final swapHash = await swap(res);

                  if (swapHash != null) {
                    final isSuccess = await contract.getSwap.listenTransfer(swapHash);

                    print("contract.getSwap.listenTransfer(swapHash) $isSuccess");

                    if (isSuccess!) {
                      Navigator.pop(context);
                      await enableAnimation(
                        'swapped ${_swapModel.amountController!.text} of SEL v1 to SEL v2.',
                        'Go to wallet', () {
                    Navigator.pushAndRemoveUntil(context, Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), ModalRoute.withName('/'));
                      });

                    } else {
                      Navigator.pop(context);
                      await DialogComponents().dialogCustom(context: context, titles: 'Transaction failed', contents: 'Something went wrong with your transaction.');
                    }
                  }

                } else {
                  Navigator.pop(context);
                  await DialogComponents().dialogCustom(context: context, titles: 'Transaction failed', contents: '$resAllow');
                }
              } else {
                Navigator.pop(context);
                await DialogComponents().dialogCustom(context: context, titles: 'Transaction failed', contents: 'Approval is $approveStatus');
              }
            }
          }
        }
      });
    } catch (e) {}
  }

  // Function That Call Swap Without Approve
  Future<void> swapWithoutAp() async {
    if (ApiProvider().isDebug) print("swapWithoutAp");

    final contract = Provider.of<ContractProvider>(context, listen: false);

    await Navigator.push(context, Transition(child: Passcode(label: PassCodeLabel.fromSendTx), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)).then((resPin) async {
      print("resPin $resPin");
      try {
        if (resPin != null) {
          final res = await AppServices.getPrivateKey(resPin, context);
          dialogLoading(context);
          final String? hash = await contract.swap(_swapModel.amountController!.text, res!);
          if (hash != null) {
            // await Future.delayed(const Duration(seconds: 7));
            final res = await contract.getSwap.listenTransfer(hash);

            if (ApiProvider().isDebug) print("contract.getSwap.listenTransfer(hash) $res");

            if (res != null) {
              if (res) {
                Navigator.pop(context);
                enableAnimation(
                  'swapped ${_swapModel.amountController!.text} of SEL v1 to SEL v2.',
                  'Go to wallet', () {
                  Navigator.pushAndRemoveUntil(context, Transition(child: HomePage(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT), ModalRoute.withName('/'));
                });
                _swapModel.amountController!.text = '';
              } else {
                Navigator.pop(context);
                await DialogComponents().dialogCustom(context: context, titles: 'Transaction failed', contents: 'Something went wrong with your transaction.');
              }
            } else {
              Navigator.pop(context);
              await DialogComponents().dialogCustom(context: context, titles: 'Transaction failed', contents: 'Something went wrong with your transaction.');
            }
          }
        }
      } catch (e) {
        Navigator.pop(context);
        await DialogComponents().dialogCustom(
          context: context, 
          titles: 'Oops', 
          contents: e.toString().contains("You do not have sufficient funds for transaction.") ? 'Ins' : e.toString()
        );
      }
    });
  }

  // Function Confirm After Check Allowance
  Future<void> confirmFunction() async {

    if (ApiProvider().isDebug) print("confirmFunction");

    try {

      dialogLoading(context);
      final res = await Provider.of<ContractProvider>(context, listen: false).checkAllowance();

      if (ApiProvider().isDebug) print("res $res");

      if (res.toString() == '0') {
        Navigator.pop(context);
        await approveAndSwap();
      } else {
        Navigator.pop(context);

        await swapWithoutAp();
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error confirmFunction $e");
    }
  }

  // Check Validation Before Swap
  void validateSwap() async {
    print("validateSwap");
    // Loading
    try {

      dialogLoading(context);

      final contract = Provider.of<ContractProvider>(context, listen: false);

      print("_swapModel.amountController!.text ${_swapModel.amountController!.text}");
      print("contract.listContract[ApiProvider().selV1Index].balance! ${contract.listContract[ApiProvider().selV1Index].balance!}");

      print("double.parse(_swapModel.amountController!.text) > double.parse(contract.listContract[ApiProvider().selV1Index].balance!) ||  double.parse(contract.listContract[ApiProvider().selV1Index].balance!) == 0 ${double.parse(_swapModel.amountController!.text) > double.parse(contract.listContract[ApiProvider().selV1Index].balance!) ||  double.parse(contract.listContract[ApiProvider().selV1Index].balance!) == 0}");

      if (double.parse(_swapModel.amountController!.text) > double.parse(contract.listContract[ApiProvider().selV1Index].balance!) ||  double.parse(contract.listContract[ApiProvider().selV1Index].balance!) == 0) {
        // Close Loading
        Navigator.pop(context);
        DialogComponents().dialogCustom(context: context, titles: 'Insufficient Balance', contents: 'Your loaded balance is not enough to swap.');
      } else {
        print("My false");
        Navigator.pop(context);
        await confirmDialog(_swapModel.amountController!.text, await swap);
      }
    } catch (e) {
      if(ApiProvider().isDebug) print("Error validateSwap $e");
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

  // After Swap
  Future<void> successDialog(String operationText, String btnText, Function onPressed) async {
    await DialogComponents().dialogCustom(context: context, 
      contents2: Container(
        //height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(
            //   height: MediaQuery.of(context).size.width * 0.08,
            // ),
            Icon(Icons.check_circle_outline_rounded, size: 20.w, color: Colors.green,),
            MyText(
              text: 'SUCCESS!',
              fontSize: 20,
              top: 10,
              color: AppColors.lowWhite,
              fontWeight: FontWeight.bold,
            ),
            MyText(
              top: 8.0,
              color: AppColors.lowWhite,
              text: 'You have successfully ' + operationText,
            ),
          ],
        ),
      ),
      btn2: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Expanded(
            child: MyGradientButton(
              textButton: btnText,
              lsColor: [ "#808080", "#808080"],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: (){
                Navigator.pop(context);
              }
            )
          ),

          SizedBox(
            width: 20,
            height: 50,
          ),

          Expanded(
            child: MyGradientButton(
              textButton: btnText,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: (){
                onPressed();
              }
            )
          )

        ],
      )
    );
  }

  Future<void> confirmDialog(String amount, Function swap) async {
    print("confirmDialog");
    await DialogComponents().dialogCustom(
      context: context, 
      contents2: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyText(
                text: 'Swapping',
                color: AppColors.lowWhite,
                //color: '#000000',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                height: 40,
              ),
              SvgPicture.asset(
                AppConfig.iconsPath+'arrow.svg',
                height: 15.w,
                width: 15.w,
                color: hexaCodeToColor(AppColors.secondary),
              ),
              MyText(
                text: 'SEL v1 to SEL v2',
                fontWeight: FontWeight.bold,
                color: AppColors.lowWhite,
                top: 40,
                bottom: 8.0,
              ),
              MyText(
                text: '$amount of SEL v1',
                color2: hexaCodeToColor(AppColors.secondary),
              ),
            ],
          ),
        ),
      ),
      btn2: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(
            height: 7.h,
            width: MediaQuery.of(context).size.width / 1.5,
            child: MyGradientButton(
              textButton: "CONFIRM",
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              action: () async {
                Navigator.pop(context);
                await confirmFunction();
              }
            ),
          )
        ],
      )
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
    // Future.delayed(Duration(seconds: 2), (){

    //   successDialog("1", "Close", (){});
    // });
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
