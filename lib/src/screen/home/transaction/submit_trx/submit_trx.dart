import 'dart:math';
import 'dart:ui';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/assets/assets.dart';
import 'package:wallet_apps/src/screen/home/transaction/submit_trx/functional_trx.dart';
import 'package:wallet_apps/src/service/submit_trx_s.dart';

class SubmitTrx extends StatefulWidget {
  final String? _walletKey;
  final String? asset;
  final List<dynamic>? _listPortfolio;
  final bool? enableInput;

  const SubmitTrx(
      // ignore: avoid_positional_boolean_parameters
      this._walletKey,
      // ignore: avoid_positional_boolean_parameters
      this.enableInput,
      this._listPortfolio,
      {this.asset});

  @override
  State<StatefulWidget> createState() {
    return SubmitTrxState();
  }
}

class SubmitTrxState extends State<SubmitTrx> {

  TrxFunctional? trxFunc;

  final ModelScanPay _scanPayM = ModelScanPay();

  FlareControls flareController = FlareControls();

  ContractProvider? _contractProvider;

  AssetInfoC c = AssetInfoC();

  bool disable = false;
  final bool _loading = false;

  @override
  void initState() {
    _contractProvider = Provider.of<ContractProvider>(context, listen: false);
    if (widget.asset != null){
      _scanPayM.asset = widget.asset;
    } else {
      _scanPayM.asset = Provider.of<ContractProvider>(context, listen: false).sortListContract[0].symbol;
      _scanPayM.assetValue = 0;
    }

    AppServices.noInternetConnection(_scanPayM.globalKey);

    _scanPayM.controlReceiverAddress.text = widget._walletKey!;
    _scanPayM.portfolio = widget._listPortfolio!;

    // Initalize Functional Of Trx
    trxFunc = TrxFunctional.init(
      context: context,
      enableAnimation: enableAnimation,
      validateAddress: validateAddress
    );

    trxFunc!.txInfo = TransactionInfo(
      coinSymbol: _scanPayM.asset,
      amount: _scanPayM.controlAmount.text,
      gasPrice: '',
      feeNetworkSymbol: '',
      gasPriceUnit: '',
      maxGas: '',
      gasFee: '',
      totalAmt: '',
      estAmountPrice: '',
      estTotalPrice: '',
      estGasFeePrice: '',
    );

    trxFunc!.contract = Provider.of<ContractProvider>(context, listen: false);

    super.initState();
  }

  void removeAllFocus() {
    _scanPayM.nodeAmount.unfocus();
    _scanPayM.nodeMemo.unfocus();
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

  Future<bool> validateAddress(String address) async {
    final res = await Provider.of<ApiProvider>(context, listen: false).validateAddress(address);
    return res;
  }

  String onChanged(String value) {

    enableButton();
    return value;
  }

  String? validateField(String value) {
    if (value == '' || double.parse(value.toString()) <= 0 || value == '-0') {
      return 'Please fill in valid amount';
    }

    return null;
  }

  void onSubmit(BuildContext context) async {

    try {

      if (_scanPayM.nodeReceiverAddress.hasFocus) {
        FocusScope.of(context).requestFocus(_scanPayM.nodeAmount);
      } else if (_scanPayM.nodeAmount.hasFocus) {
        FocusScope.of(context).requestFocus(_scanPayM.nodeMemo);
      } else {
        if (_scanPayM.enable == true) await sendTrx(trxFunc!.txInfo!, context: context);
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error onSubmit $e");
    }
  }

  void enableButton() {
    if (_scanPayM.controlAmount.text != '' && _scanPayM.asset != null) {
      setState(() => _scanPayM.enable = true);
    } else if (_scanPayM.enable) {
      setState(() => _scanPayM.enable = false);
    }
  }

  Future enableAnimation() async {

    await ContractsBalance().getAllAssetBalance(context: context);
    // Close Dialog Loading
    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
      disable = true;
    });
    flareController.play('Checkmark');

    await successDialog(context, "transferred the funds.");
    // Timer(const Duration(milliseconds: 2500), () async {
    //   await successDialog(context, "transferred the funds.");

    //   // Navigator.pushNamedAndRemoveUntil(
    //   //     context, Home.route, ModalRoute.withName('/'));
    // });
  }

  void onChangeDropDown(String data) {
    setState(() {
      _scanPayM.assetValue = int.parse(data);
    });
    enableButton();
  }

  // First Execute
  Future<void> validateSubmit() async {
    print("validateSubmit");
    final contract = Provider.of<ContractProvider>(context, listen: false);
    _scanPayM.asset = contract.sortListContract[_scanPayM.assetValue!].symbol;
    try {

      var gasPrice;
      dialogLoading(context);
      final isValid = await trxFunc!.validateAddr(_scanPayM.asset!, _scanPayM.controlReceiverAddress.text, context: context, org: contract.sortListContract[_scanPayM.assetValue!].org);
      
      if ( isNative() || contract.sortListContract[_scanPayM.assetValue!].symbol == "DOT"){

        print("isNative");
        // Close Dialog
        Navigator.pop(context);
        
        await sendTrx(trxFunc!.txInfo!, context: context);
      } else {

        if (!isValid) {
          Navigator.pop(context);
          await trxFunc!.customDialog('Oops', 'Invalid Reciever Address.');
        } else {

          final isEnough = await trxFunc!.checkBalanceofCoin(
            _scanPayM.asset!,
            _scanPayM.controlAmount.text,
            _scanPayM.assetValue!
          );

          if (!isEnough && isValid) {
            if (isValid) {
              Navigator.pop(context);
            }
            await trxFunc!.customDialog('Insufficient Balance', 'You do not have sufficient balance for transaction.');
          }

          if (isValid) {
            gasPrice = await trxFunc!.getNetworkGasPrice(_scanPayM.asset!);
          }

          if (isValid && isEnough) {

            if (gasPrice != null) {

              final estAmtPrice = await trxFunc!.calPrice(
                _scanPayM.asset!,
                _scanPayM.controlAmount.text,
              );

              final maxGas = await trxFunc!.estMaxGas(
                context,
                _scanPayM.asset!,
                _scanPayM.controlReceiverAddress.text,
                _scanPayM.controlAmount.text,
                _scanPayM.assetValue!
              );

              final gasFee = double.parse(maxGas!) * double.parse(gasPrice);

              var gasFeeToEther = double.parse((gasFee / pow(10, 9)).toString());

              final estGasFeePrice = await trxFunc!.estGasFeePrice(gasFee, _scanPayM.asset!);

              final totalAmt = double.parse(_scanPayM.controlAmount.text) + double.parse((gasFee / pow(10, 9)).toString());

              final estToSendPrice = totalAmt * double.parse(estAmtPrice!.last);

              final estTotalPrice = estGasFeePrice! + estToSendPrice;

              trxFunc!.txInfo = TransactionInfo(
                coinSymbol: _scanPayM.asset,
                receiver: AppUtils.getEthAddr(_scanPayM.controlReceiverAddress.text),
                amount: _scanPayM.controlAmount.text,
                gasPrice: gasPrice,
                feeNetworkSymbol: _scanPayM.asset!.contains('BEP-20') || _scanPayM.asset == 'BNB'
                  ? 'BNB'
                  : 'ETH',
                gasPriceUnit: _scanPayM.asset == 'BTC' ? 'Satoshi' : 'Gwei',
                maxGas: maxGas,
                gasFee: gasFee.toInt().toString(),
                totalAmt: totalAmt.toString(),
                estAmountPrice: estAmtPrice.first.toString(),
                estTotalPrice: estTotalPrice.toStringAsFixed(2),
                estGasFeePrice: estGasFeePrice.toStringAsFixed(2),
              );

              Navigator.pop(context);

              await Navigator.push(
                context,
                Transition(
                  child: ConfirmationTx(
                    trxInfo: trxFunc!.txInfo,
                    sendTrx: sendTrx,
                    gasFeetoEther: gasFeeToEther.toStringAsFixed(8),
                  ),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                ),
              );
            } else {

              Navigator.pop(context);
              await sendTrx(trxFunc!.txInfo!, context: context);
            }
          }

        }
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err validateSubmit $e");
    }
  }

  // Second Execute
  Future<void>  sendTrx(TransactionInfo txInfo, { @required BuildContext? context}) async {

    print("sendTrx");
    try {
      // Unfocus All Field Input
      await Future.delayed(const Duration(milliseconds: 100), () {
        unFocusAllField();
      });

      // Start Loading Before Dialog Pin
      // Init member variables of Trx Functional
      trxFunc!.contract = Provider.of<ContractProvider>(context!, listen: false);

      trxFunc!.api = Provider.of<ApiProvider>(context, listen: false);

      trxFunc!.encryptKey = await StorageServices().readSecure(_scanPayM.asset == 'btcwif' ? 'btcwif' : DbKey.private);

      // Show Dialog Fill PIN
      // await  dialogBox().then((String? resPin) async {
      await Navigator.push(context, Transition(child: Passcode(label: PassCodeLabel.fromSendTx), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)).then((resPin) async {
        print("resPin $resPin");
        if (resPin != null) {

          // Second: Start Loading For Sending
          dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");

          trxFunc!.pin = resPin;

          if (
            isNative() || trxFunc!.contract!.sortListContract[_scanPayM.assetValue!].symbol == "DOT"
          ){
            print("Send native");
            await SubmitTrxService().sendNative(_scanPayM, trxFunc!.pin!, context, txInfo: txInfo).then((value) async {
              if (value == true){
                print("after send trx $value");
                // await ContractsBalance().refetchContractBalance(context: context);
                enableAnimation();  
              } else {

                // Close Dialog
                Navigator.pop(context);
              }
            });
          } else {
            print("Send ERC-20 || BEP-20");
            /* ------------------Check and Get Private------------ */
            // Get Private Key Only BTC Contract
            if (_scanPayM.asset == 'BTC') {
              trxFunc!.privateKey = await trxFunc!.getBtcPrivateKey(resPin, context: context);
            } 
            // Get Private Key For Other Contract
            else {
              trxFunc!.privateKey = await trxFunc!.getPrivateKey(resPin, context: context);
            }

            /* ------------------Check PIN------------ */
            // Pin Incorrect And Private Key Response NULL
            if (trxFunc!.privateKey == null) {
              // Close Second Dialog
              Navigator.pop(context);

              await trxFunc!.customDialog('Opps', 'PIN verification failed');
            }

            // Pin Correct And Response With Private Key
            else if (trxFunc!.privateKey != null) {

              trxFunc!.txInfo!.coinSymbol = _scanPayM.asset;
              trxFunc!.txInfo!.privateKey = trxFunc!.privateKey;
              trxFunc!.txInfo!.amount = _scanPayM.controlAmount.text;
              trxFunc!.txInfo!.receiver = trxFunc!.contract!.getEthAddr(
                _scanPayM.controlReceiverAddress.text,
              );

              SmartContractModel contractM = _contractProvider!.sortListContract[_scanPayM.assetValue!];

              /* -------------Processing Transaction----------- */
              if (contractM.symbol == "SEL"){
                if (contractM.org == 'BEP-20'){

                  await trxFunc!.sendTxBep20(trxFunc!.contract!.getSelToken, txInfo);
                } else {
                  //trxFunc!.sendTx(_scanPayM.controlReceiverAddress.text, _scanPayM.controlAmount.text);
                }
              } else if (contractM.symbol == "SEL (v2)"){

                await trxFunc!.sendTxBep20(trxFunc!.contract!.getSelv2, txInfo);
              } else if (contractM.symbol == "BNB"){

                await trxFunc!.sendTxEvm(trxFunc!.contract!.getBnb, txInfo);
              } else if (contractM.symbol == "ETH"){

                await trxFunc!.sendTxEvm(trxFunc!.contract!.getEth, txInfo);
              } else if (contractM.symbol == "BTC"){

                // await trxFunc!.sendTxBtc(_scanPayM.controlReceiverAddress.text, _scanPayM.controlAmount.text);
              } else if (contractM.symbol == "KGO"){

                await trxFunc!.sendTxBep20(trxFunc!.contract!.getKgo, txInfo);
              } else {
                if (_scanPayM.asset!.contains('ERC-20')) {

                  final contractAddr = ContractProvider().findContractAddr(_scanPayM.asset!);
                  final chainDecimal = await ContractProvider().queryEther(contractAddr, 'decimals', []);
                  await trxFunc!.sendTxErc(
                    contractAddr,
                    chainDecimal![0].toString(),
                    _scanPayM.controlReceiverAddress.text,
                    _scanPayM.controlAmount.text
                  );
                  
                } else {
                  
                  final contractAddr = trxFunc!.contract!.sortListContract[_scanPayM.assetValue!].address; //ContractProvider().findContractAddr(_scanPayM.asset);
                  await Provider.of<ContractProvider>(context, listen: false).initBep20Service(contractAddr!);
                  await trxFunc!.sendTxBep20(trxFunc!.contract!.getBep20, txInfo);
                }
              }
            }

            await ContractsBalance().refetchContractBalance(context: context);
            enableAnimation();
          }
        }
      });
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err sendTrx $e");
      //Close Dialog
      Navigator.pop(context!);

      // Condition For RPCError
      await trxFunc!.customDialog("Oops", "${e.runtimeType.toString() == 'RPCError' ? 'insufficient funds for gas' : e}");
    }
  }

  bool isNative(){
    return trxFunc!.contract!.sortListContract[_scanPayM.assetValue!].symbol == "SEL" && (ApiProvider().isMainnet ? trxFunc!.contract!.sortListContract[_scanPayM.assetValue!].org : trxFunc!.contract!.sortListContract[_scanPayM.assetValue!].orgTest) == (ApiProvider().isMainnet ? "Selendra Chain" : "Testnet") ;
  }

  void unFocusAllField() {
    _scanPayM.nodeAmount.unfocus();
    _scanPayM.nodeMemo.unfocus();
    _scanPayM.nodeReceiverAddress.unfocus();
  }

  PopupMenuItem item(List list) {
    /* Display Drop Down List */
    return PopupMenuItem(
      value: list,
      child: Align(
        child: Text(
          list.toString(),
        ),
      ),
    );
  }

  void pasteText() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    _scanPayM.controlReceiverAddress.text = cdata!.text!;
    setState(() {});
  }

  
  bool pushReplacement = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scanPayM.globalKey,
      body: _loading
      ? const Center(
        child: CircularProgressIndicator(),
      )
      : Stack(
        children: <Widget>[
          SubmitTrxBody(
            pushRepleacement: pushReplacement,
            enableInput: widget.enableInput,
            scanPayM: _scanPayM,
            pasteText: pasteText,
            onChanged: onChanged,
            onSubmit: onSubmit,
            validateSubmit: validateSubmit, //sendTrx,
            validateField: (String? value){
              return validateField(value!)!;
            },
            onChangeDropDown: onChangeDropDown,
          ),
          if (_scanPayM.isPay == false)
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
                      AppConfig.animationPath+"check.flr",
                      "Checkmark",
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
