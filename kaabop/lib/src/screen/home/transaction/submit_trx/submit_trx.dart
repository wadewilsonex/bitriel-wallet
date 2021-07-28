import 'dart:math';
import 'dart:ui';
import 'package:flare_flutter/flare_controls.dart';
import 'package:intl/intl.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/transaction/submit_trx/functional_trx.dart';

class SubmitTrx extends StatefulWidget {

  final String _walletKey;
  final String asset;
  final List<dynamic> _listPortfolio;
  final bool enableInput;

  const SubmitTrx(
    // ignore: avoid_positional_boolean_parameters
    this._walletKey,
    // ignore: avoid_positional_boolean_parameters
    this.enableInput,
    this._listPortfolio,
    {this.asset}
  );
  @override
  State<StatefulWidget> createState() {
    return SubmitTrxState();
  }
}

class SubmitTrxState extends State<SubmitTrx> {

  TrxFunctional trxFunc;

  final ModelScanPay _scanPayM = ModelScanPay();

  FlareControls flareController = FlareControls();

  AssetInfoC c = AssetInfoC();

  bool disable = false;
  final bool _loading = false;

  @override
  void initState() {
    widget.asset != null ? _scanPayM.asset = widget.asset : _scanPayM.asset = "SEL";

    AppServices.noInternetConnection(_scanPayM.globalKey);

    trxFunc = TrxFunctional(context: context, enableAnimation: enableAnimation, validateAddress: validateAddress);

    _scanPayM.controlReceiverAddress.text = widget._walletKey;
    _scanPayM.portfolio = widget._listPortfolio;

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
    print("My pin $_result");
    return _result;
  }

  Future<bool> validateAddress(String address) async {
    final res = await ApiProvider.sdk.api.keyring.validateAddress(address);
    return res;
  }

  String onChanged(String value) {
    if (_scanPayM.nodeReceiverAddress.hasFocus) {
    } else if (_scanPayM.nodeAmount.hasFocus) {
      _scanPayM.formStateKey.currentState.validate();
      if (_scanPayM.formStateKey.currentState.validate()) {
        enableButton();
      } else {
        setState(() {
          _scanPayM.enable = false;
        });
      }
    }
    return value;
  }

  String validateField(String value) {
    if (value == '' || double.parse(value.toString()) < 0 || value == '-0') {
      return 'Please fill in positive amount';
    }

    return null;
  }

  void onSubmit(BuildContext context) {
    if (_scanPayM.nodeReceiverAddress.hasFocus) {
      FocusScope.of(context).requestFocus(_scanPayM.nodeAmount);
    } else if (_scanPayM.nodeAmount.hasFocus) {
      FocusScope.of(context).requestFocus(_scanPayM.nodeMemo);
    } else {
      if (_scanPayM.enable == true) clickSend();
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

    // Close Dialog Loading
    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
      disable = true;
    });
    flareController.play('Checkmark');

    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
    });
  }

  void popScreen() {
    /* Close Current Screen */
    Navigator.pop(context, null);
  }

  void resetAssetsDropDown(String data) {
    setState(() {
      _scanPayM.asset = data;
    });
    enableButton();
  }

  Future<void> clickSend() async {
    try {

      if (_scanPayM.formStateKey.currentState.validate()) {
        /* Send payment */

        await Future.delayed(const Duration(milliseconds: 100), () {
          // Unfocus All Field Input
          unFocusAllField();
        });

        final contract = Provider.of<ContractProvider>(context, listen: false);

        await dialogBox().then((value) async {
          print("Asset ${_scanPayM.asset}");

          if (value != null) {

            switch (_scanPayM.asset) {
              case "SEL":
                await trxFunc.sendTx(
                  _scanPayM.controlReceiverAddress.text,
                  _scanPayM.controlAmount.text,
                  value,
                );
                break;
              case "KMPI":
                await trxFunc.sendTxKmpi(
                  _scanPayM.controlReceiverAddress.text,
                  value,
                  _scanPayM.controlAmount.text,
                );
                break;
              case "DOT":
                await trxFunc.sendTxDot(
                  _scanPayM.controlReceiverAddress.text,
                  _scanPayM.controlAmount.text,
                  value,
                );
                break;
              case "SEL (BEP-20)":
                final chainDecimal = await ContractProvider().query(AppConfig.bscMainnetAddr, 'decimals', []);
                if (chainDecimal != null) {
                  await trxFunc.sendTxAYF(
                    AppConfig.bscMainnetAddr,
                    chainDecimal[0].toString(),
                    _scanPayM.controlReceiverAddress.text,
                    _scanPayM.controlAmount.text,
                    value,
                  );
                }
                break;
              case "KGO (BEP-20)":
                final chainDecimal = await ContractProvider().query(AppConfig.kgoAddr, 'decimals', []);
                if (chainDecimal != null) {
                  await trxFunc.sendTxAYF(
                    AppConfig.kgoAddr,
                    chainDecimal[0].toString(),
                    _scanPayM.controlReceiverAddress.text,
                    _scanPayM.controlAmount.text,
                    value,
                  );
                }
                break;

              case "BNB":
                await trxFunc.sendTxBnb(
                  contract,
                  _scanPayM.controlReceiverAddress.text,
                  _scanPayM.controlAmount.text,
                  value,
                );
                break;

              case "ETH":
                await trxFunc.sendTxEther(
                  _scanPayM.controlReceiverAddress.text,
                  _scanPayM.controlAmount.text,
                  value,
                );
                break;

              case "BTC":
                await trxFunc.sendTxBtc(_scanPayM.controlReceiverAddress.text, _scanPayM.controlAmount.text, value);
                break;

              default:
                if (_scanPayM.asset.contains('ERC-20')) {
                  final contractAddr = ContractProvider().findContractAddr(_scanPayM.asset);
                  final chainDecimal = await ContractProvider().queryEther(contractAddr, 'decimals', []);
                  await trxFunc.sendTxErc(
                    contractAddr,
                    chainDecimal[0].toString(),
                    _scanPayM.controlReceiverAddress.text,
                    _scanPayM.controlAmount.text,
                    value
                  );
                } else {
                  final contractAddr = ContractProvider().findContractAddr(_scanPayM.asset);
                  final chainDecimal = await ContractProvider().query(contractAddr, 'decimals', []);
                  await trxFunc.sendTxAYF(
                    contractAddr,
                    chainDecimal[0].toString(),
                    _scanPayM.controlReceiverAddress.text,
                    _scanPayM.controlAmount.text,
                    value,
                  );
                }

                break;
            }
          }
        });
      }
    } catch (e){
      await TrxFunctional(context: context, enableAnimation: enableAnimation, validateAddress: validateAddress).customDialog("Oops", "$e");
    }
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
            Consumer<WalletProvider>(
              builder: (context, value, child) {
                return SubmitTrxBody(
                  enableInput: widget.enableInput,
                  scanPayM: _scanPayM,
                  onChanged: onChanged,
                  onSubmit: onSubmit,
                  clickSend: clickSend,
                  validateField: validateField,
                  resetAssetsDropDown: resetAssetsDropDown,
                  list: value.listSymbol,
                );
              },
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
                        "assets/animation/check.flr",
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
