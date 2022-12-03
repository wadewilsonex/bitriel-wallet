import 'dart:math';
import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dialog_c.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/screen/home/bottom/home/home.dart';
import 'package:wallet_apps/src/screen/home/transaction/submit_trx/functional_trx.dart';
import 'package:wallet_apps/src/screen/home/transaction/success_transfer/success_transfer.dart';
import 'package:wallet_apps/src/service/exception_handler.dart';
import 'package:wallet_apps/src/service/submit_trx_s.dart';

class SubmitTrx extends StatefulWidget {
  
  // final int? assetIndex;
  final String? _walletKey;
  final String? asset;
  final List<dynamic>? _listPortfolio;
  final bool? enableInput;
  final SmartContractModel? scModel;

  const SubmitTrx(
    this._walletKey,
    this.enableInput,
    this._listPortfolio,
    {Key? key, 
      this.asset,
      this.scModel
    }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SubmitTrxState();
  }
}

class SubmitTrxState extends State<SubmitTrx> {

  TrxFunctional? trxFunc;
  int decimal = 0;

  final ModelScanPay _scanPayM = ModelScanPay();

  ContractProvider? _contractProvider;
  ApiProvider? _apiProvider;

  bool disable = false;
  final bool _loading = false;
  
  String? _pin;

  String? message;

  @override
  void initState() {

    _contractProvider = Provider.of<ContractProvider>(context, listen: false);
    _apiProvider = Provider.of<ApiProvider>(context, listen: false);

    /// Occure when user tap on Asset from Assets Detail Page.
    if (widget.scModel != null){
      
      _scanPayM.asset = widget.scModel!.symbol;
      _scanPayM.balance = widget.scModel!.balance;
      _scanPayM.assetValue = _contractProvider!.sortListContract.indexOf(widget.scModel!);
      // _scanPayM.assetValue = widget.assetIndex!;
    }

    /// Occure when user tap on Asset from Assets Page.
    else {
      _scanPayM.asset = _contractProvider!.sortListContract[_scanPayM.assetValue].symbol;
      _scanPayM.balance = _contractProvider!.sortListContract[_scanPayM.assetValue].balance;
      _scanPayM.logo = _contractProvider!.sortListContract[_scanPayM.assetValue].logo;
      _scanPayM.assetValue = 0;

    }

    AppServices.noInternetConnection(context: context);

    _scanPayM.controlReceiverAddress.text = widget._walletKey!;
    _scanPayM.portfolio = widget._listPortfolio!;

    StorageServices().readSecure(DbKey.passcode)!.then((value) {
      _pin = value;
    });

    // Initialize Functional Of Trx
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
      chainDecimal: 0
    );
    
    // _scanPayM.controlReceiverAddress.text = "0x6871EB5dB4554dB54276D5E5d24f17B9E9dF95F3";
    // _scanPayM.controlAmount.text = "1";
    // _scanPayM.enable= true;

    trxFunc!.contract = Provider.of<ContractProvider>(context, listen: false);

    super.initState();
  }
  
  bool isNotEmpty(){
    if (_scanPayM.controlReceiverAddress.text.isEmpty || _scanPayM.controlAmount.text.isEmpty){
      return true;
    }
    return false;
  }

  String validateAddress(String address) {
    // value == null ? 'Please fill in receiver address' : null
    print("validate");
    if (address == ""){
      return "Please fill in receiver address";
    } else if (address != null){
      Provider.of<ApiProvider>(context, listen: false).validateAddress(address).then((value) {

      if (value == false) {
        message = "Invalid address";
      } else {
        message = null;
      }
      });
    }
    

    return message!;
  }

  String onChanged(String value) {

    enableButton();
    return value;
  }

  String? validateField(String value) {
    if (value == "0"){
      return 'Amount mustn\'t equal 0';
    } else if (value == '' || double.parse(value.toString()) <= 0 || value == '-0') {
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
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error onSubmit $e");
        }
      }
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

    Navigator.pop(context);
    setState(() {
      _scanPayM.isPay = true;
      // disable = true;
    });
    // flareController.play('Checkmark');
    await Future.delayed(const Duration(seconds: 1), (){});
    
    if(!mounted) return;
    Navigator.pushAndRemoveUntil(context, Transition(child: const HomePage(activePage: 1, isTrx: true,)), ModalRoute.withName('/'));
    // await successDialog(context, "transferred the funds.", route: HomePage(activePage: 1,));
  }

  void onChangeDropDown(String data) {
    setState(() {
      _scanPayM.assetValue = int.parse(data);
      _scanPayM.balance = _contractProvider!.sortListContract[_scanPayM.assetValue].balance;
      _scanPayM.logo = _contractProvider!.sortListContract[_scanPayM.assetValue].logo;
    });

    enableButton();
  }

  // First Execute
  Future<void> validateSubmit() async {

    // Navigator.push(
    //   context,
    //   Transition(
    //     child: SuccessTransfer(
    //       fromAddress: "seYeRoPMUTEd5vvCiAUjweDrroTdvrfWLsmUQRtbJ4xbKByGM",
    //       toAddress: _scanPayM.controlReceiverAddress.text,
    //       amount: _scanPayM.controlAmount.text,
    //       fee: "0.0001",
    //       hash: "0x56c6e1c6ec896c7cfb6e2f5a4326e4fcc209848bd435acf2dc44398dd45a903a",
    //       trxDate: DateTime.now().toLocal().toString(),
    //       assetLogo: _scanPayM.logo,
    //       assetSymbol: _scanPayM.asset,
    //       scanPayM: _scanPayM,
    //     ),
    //     transitionEffect: TransitionEffect.RIGHT_TO_LEFT
    //   ),
    // );

    unFocusAllField();

    if (double.parse(_scanPayM.controlAmount.text) == 0){
      await trxFunc!.customDialog('Message', 'Amount mustn\'t equal 0');
    }
    else if (isNotEmpty()){
      await trxFunc!.customDialog('Message', 'Your fields cannot empty!');
    }
    else if ( double.parse(_scanPayM.controlAmount.text) > double.parse(_contractProvider!.sortListContract[_scanPayM.assetValue].balance!.replaceAll(",", "")) ){

      await trxFunc!.customDialog('Message', 'Your input balance must less than available balances');
    } else {

      _scanPayM.asset = _contractProvider!.sortListContract[_scanPayM.assetValue].symbol;

      try {

        String? gasPrice;
        dialogLoading(context, content: "Estimating Fee...");
        final isValid = await trxFunc!.validateAddr(_scanPayM.asset!, _scanPayM.controlReceiverAddress.text, context: context, org: _contractProvider!.sortListContract[_scanPayM.assetValue].org);
        
        if ( isNative() || _contractProvider!.sortListContract[_scanPayM.assetValue].symbol == "DOT"){
          // Close Dialog
          if(!mounted) return;
          Navigator.pop(context);
          
          await sendTrx(trxFunc!.txInfo!, context: context).then((value) async {
            if (value != null){
              await enableAnimation();
            }
          });
        } else {
          if (!isValid) {
            if(!mounted) return;
            Navigator.pop(context);
            await trxFunc!.customDialog('Oops', 'Invalid Reciever Address.');
          } else {

            final isEnough = await trxFunc!.checkBalanceofCoin(
              _scanPayM.asset!,
              _scanPayM.controlAmount.text,
              _scanPayM.assetValue
            );

            if (!isEnough && isValid) {
              if (isValid) {
                if(!mounted) return;
                Navigator.pop(context);
              }
              await trxFunc!.customDialog('Insufficient Balance', 'You do not have sufficient funds for transaction.');
            }

            if (isValid) {
              gasPrice = await trxFunc!.getNetworkGasPrice(
                _scanPayM.asset!, 
                network: ApiProvider().isMainnet ? _contractProvider!.sortListContract[_scanPayM.assetValue].org : _contractProvider!.sortListContract[_scanPayM.assetValue].orgTest//"ERC-20"
              );
            }
            if (isValid && isEnough) {

              if (gasPrice != null) {
                
                final estAmtPrice = await trxFunc!.calPrice(
                  _scanPayM.asset!,
                  _scanPayM.controlAmount.text,
                  assetIndex: _scanPayM.assetValue
                );

                // _contractProvider!.sortListContract[_scanPayM.assetValue].marketPrice;
                if(!mounted) return;
                final maxGas = await trxFunc!.estMaxGas(
                  context,
                  _scanPayM.asset!,
                  _scanPayM.controlReceiverAddress.text,
                  _scanPayM.controlAmount.text,
                  _scanPayM.assetValue, 
                  network: ApiProvider().isMainnet ? _contractProvider!.sortListContract[_scanPayM.assetValue].org : _contractProvider!.sortListContract[_scanPayM.assetValue].orgTest
                );
                decimal = _contractProvider!.sortListContract[_scanPayM.assetValue].chainDecimal!;
                final gasFee = double.parse(maxGas!) * double.parse(gasPrice);
                var gasFeeToEther = (gasFee / pow(10, 18)).toString();

                // Check BNB balance for Fee
                if (double.parse(gasFeeToEther) >= double.parse(_contractProvider!.listContract[_apiProvider!.bnbIndex].balance!.replaceAll(",", ""))){
                  throw ExceptionHandler("You do not have sufficient fee for transaction.");
                }

                final estGasFeePrice = await trxFunc!.estGasFeePrice(gasFee, _scanPayM.asset!, assetIndex: _scanPayM.assetValue);
                final totalAmt = double.parse(_scanPayM.controlAmount.text) + double.parse((gasFee / pow(10, 18)).toString());
                final estToSendPrice = totalAmt * double.parse(estAmtPrice!.last == "0" ? "1" : estAmtPrice.last);

                final estTotalPrice = estGasFeePrice! + estToSendPrice;
                
                trxFunc!.txInfo = TransactionInfo(
                  chainDecimal: decimal,
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

              }

              if(!mounted) return;
              Navigator.pop(context);
              
              await Navigator.push(
                context,
                Transition(
                  child: ConfirmationTx(
                    trxInfo: trxFunc!.txInfo,
                    sendTrx: sendTrx,
                    scanPayM: _scanPayM
                    // gasFeetoEther: gasFeeToEther.toStringAsFixed(8),
                  ),
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT
                ),
              );
            }

          }
        }
      } on ExceptionHandler catch (e){

        // Close Dialog Estimating Fee
        Navigator.pop(context);
        if (ApiProvider().isDebug == true) {
          if (kDebugMode) {
            print("Err validateSubmit ExceptionHandler $e");
          }
        }
        await trxFunc!.customDialog("Oops", e.cause);
      }
      catch (e) {
        
        // Close Dialog Estimating Fee
        Navigator.pop(context);
        if (ApiProvider().isDebug == true) print("Err validateSubmit $e");
        // await trxFunc!.customDialog("Oops", e.toString());
      }
    }
  }

  // Second Execute
  Future<dynamic> sendTrx(TransactionInfo txInfo, { @required BuildContext? context}) async {
    try {

      trxFunc!.contract = _contractProvider;

      trxFunc!.api = Provider.of<ApiProvider>(context!, listen: false);

      trxFunc!.encryptKey = await StorageServices().readSecure(_scanPayM.asset == 'btcwif' ? 'btcwif' : DbKey.private);

      // Show Dialog Fill PIN
      // await  dialogBox().then((String? resPin) async {
      if(!mounted) return;
      String resPin = await Navigator.push(context, Transition(child: const Passcode(label: PassCodeLabel.fromSendTx), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
      if (resPin != _pin){
        await DialogComponents().dialogCustom(context: context, titles: "Oops", contents: "Invalid PIN,\nPlease try again.");
        
      } else if (resPin.isNotEmpty) {
        // Second: Start Loading For Sending
        if(!mounted) return;
        dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");

        trxFunc!.pin = resPin;

        if (
          isNative() || trxFunc!.contract!.sortListContract[_scanPayM.assetValue].symbol == "DOT"
        ){

          await SubmitTrxService().sendNative(_scanPayM, trxFunc!.pin!, context, txInfo: txInfo).then((value) async {
            if (value == true){

              enableAnimation();  
            } else {

              // Close Dialog
              Navigator.pop(context);
            }
          });
        } else {
          
          /* ------------------Check and Get Private------------ */
          // Get Private Key Only BTC Contract
          // if (_scanPayM.asset == 'BTC') {
          //   trxFunc!.privateKey = await trxFunc!.getBtcPrivateKey(resPin, context: context);
          // } 
          // // Get Private Key For Other Contract
          // else {
          // }

          trxFunc!.privateKey = await trxFunc!.getPrivateKey(resPin, context: context);

          /* ------------------Check PIN------------ */
          // Pin Incorrect And Private Key Response NULL
          if (trxFunc!.privateKey == null) {
            // Close Second Dialog
            // Navigator.pop(context);

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

            SmartContractModel contractM = _contractProvider!.sortListContract[_scanPayM.assetValue];

            /* -------------Processing Transaction----------- */
            if (contractM.symbol == "SEL"){
              if (contractM.org == 'BEP-20'){

                await trxFunc!.sendTxBep20(_contractProvider!.getSelToken, txInfo);
              } else {
                //trxFunc!.sendTx(_scanPayM.controlReceiverAddress.text, _scanPayM.controlAmount.text);
              }
            } 
            else if (contractM.symbol == "SEL (v2)" || contractM.symbol == "SEL (v1)"){

              _scanPayM.hash = await trxFunc!.sendTxBep20(contractM.symbol!.contains('v2') ? _contractProvider!.getSelv2 : _contractProvider!.getSelToken, txInfo);
            } 
            else if (contractM.symbol == "BNB"){
              _scanPayM.hash = await trxFunc!.sendTxEvm(_contractProvider!.getBnb, txInfo);
            } 
            else if (contractM.symbol == "ETH"){

              _scanPayM.hash = await trxFunc!.sendTxEvm(trxFunc!.contract!.getEth, txInfo);
            } 
            else if (contractM.symbol == "BTC"){

              // await trxFunc!.sendTxBtc(_scanPayM.controlReceiverAddress.text, _scanPayM.controlAmount.text);
            } 
            else if (contractM.symbol == "KGO"){

              _scanPayM.hash = await trxFunc!.sendTxBep20(_contractProvider!.getKgo, txInfo);
            } 
            else {
              final contractAddr = ApiProvider().isMainnet ? trxFunc!.contract!.sortListContract[_scanPayM.assetValue].contract : trxFunc!.contract!.sortListContract[_scanPayM.assetValue].contractTest;
              if (contractM.org!.contains('ERC-20')) {

                // final contractAddr = ContractProvider().findContractAddr(_scanPayM.asset!);
                // final chainDecimal = await ContractProvider().queryEther(contractAddr!, 'decimals', []);

                await _contractProvider!.initErc20Service(contractAddr!);
                _scanPayM.hash = await trxFunc!.sendTxErc20(_contractProvider!.getErc20, txInfo);
                // print("contractAddr ${contractAddr}");
                // print("chainDecimal![0].toString() ${chainDecimal![0].toString()}");
                // print("_scanPayM.controlReceiverAddress.text ${_scanPayM.controlReceiverAddress.text}");
                // print("_scanPayM.controlAmount.tex ${_scanPayM.controlAmount.text}");

                // _scanPayM.hash = await trxFunc!.sendTxErc(
                //   contractAddr,
                //   chainDecimal[0].toString(),
                //   _scanPayM.controlReceiverAddress.text,
                //   _scanPayM.controlAmount.text
                // );
                
              } else {
                await _contractProvider!.initBep20Service(contractAddr!);
                _scanPayM.hash = await trxFunc!.sendTxBep20(_contractProvider!.getBep20, txInfo);
              }
            }
          }
        }
      }
      if (resPin == _pin) return _scanPayM.hash;
    } catch (e){
      throw Exception(e);
    }
  }

  bool isNative(){
    return trxFunc!.contract!.sortListContract[_scanPayM.assetValue].symbol == "SEL" && (ApiProvider().isMainnet ? trxFunc!.contract!.sortListContract[_scanPayM.assetValue].org : trxFunc!.contract!.sortListContract[_scanPayM.assetValue].orgTest) == (ApiProvider().isMainnet ? "Selendra Chain" : "Testnet") ;
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

  void scanQR() async {
   
    await Navigator.push(context, Transition(child: const QrScanner(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)).then((value) async {
      if (value != null){
        setState(() {
          _scanPayM.controlReceiverAddress.text = value;
          
        });
      }
    });
  }
  
  bool pushReplacement = false;

  Future<dynamic> routeSuccess(){
    return  Navigator.push(
      context,
      Transition(
        child: SuccessTransfer(),
        transitionEffect: TransitionEffect.RIGHT_TO_LEFT
      ),
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scanPayM.globalKey,
      backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: hexaCodeToColor(isDarkMode ? AppColors.whiteColorHexa : AppColors.blackColor)
        ),
        backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
        title: const MyText(
          text: "Sent",
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
      ),
      body: Stack(
        children: [
          if(_loading) const Center(
            child: CircularProgressIndicator(),
          )
          else SubmitTrxBody(
            pushRepleacement: pushReplacement,
            enableInput: widget.enableInput,
            scanPayM: _scanPayM,
            pasteText: pasteText,
            onChanged: onChanged,
            onSubmit: onSubmit,
            validateSubmit: validateSubmit, //sendTrx,
            validateAddress: validateAddress,
            validateField: (String? value){
              return validateField(value!)!;
            },
            onChangeDropDown: onChangeDropDown,
            scanQR: scanQR,
          ),

          if (_scanPayM.isPay == true) 
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
          )
        ],
      ),
    );
  }
}