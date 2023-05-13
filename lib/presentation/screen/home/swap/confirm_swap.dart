

import 'dart:math';
import 'dart:ui';

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/models/swap_m.dart';
import 'package:wallet_apps/presentation/components/dialog_c.dart';
import 'package:wallet_apps/constants/db_key_con.dart';
import 'package:wallet_apps/presentation/screen/home/transaction/submit_trx/functional_trx.dart';
import 'package:wallet_apps/data/service/contract.dart';
import 'package:lottie/lottie.dart';

class ConfirmSwap extends StatefulWidget {

  final SwapResponseObj? res;

  const ConfirmSwap({Key? key, this.res}) : super(key: key);

  @override
  State<ConfirmSwap> createState() => _ConfirmSwapState();
}

class _ConfirmSwapState extends State<ConfirmSwap> {

  TrxFunctional? trxFunc;
  final ModelScanPay _scanPayM = ModelScanPay();
  SwapTrxInfo? _swapTrxInfo;

  bool disable = false;
  int decimal = 0;
  final bool _loading = false;
  String? _pin;
  String? message;

  List<GetConByIndex>? lsCon;

  ContractProvider? _contractProvider;
  ApiProvider? _apiProvider;

  @override
  initState(){

    _contractProvider = Provider.of<ContractProvider>(context, listen: false);

    trxFunc = TrxFunctional.init(context: context);

    queryTrxStatus(widget.res!.transaction_id!).then((value) {

      _swapTrxInfo = SwapTrxInfo.fromJson(json.decode(value.body));
      // setState(() {
        _scanPayM.asset = _swapTrxInfo!.coin_from;
        _scanPayM.controlAmount.text = _swapTrxInfo!.deposit_amount!;
        _scanPayM.controlReceiverAddress.text = _swapTrxInfo!.deposit!;
        
        trxFunc!.txInfo = TransactionInfo(
          coinSymbol: _scanPayM.asset,
          amount: _scanPayM.controlAmount.text,
          receiver: EthereumAddress.fromHex(_swapTrxInfo!.deposit!)
        );

        findAssetIndex();
      // });
    });
    
    super.initState();
  }

  void findAssetIndex(){

    lsCon = GetConByIndex().getConSymbol(_contractProvider!.sortListContract, isOnlySymbol: true);

    final search = lsCon!.where((element) {
      if (_scanPayM.asset == element.symbol) return true;
      return false;
    }).toList();

    _scanPayM.assetValue = lsCon!.indexOf(search[0]);

    _contractProvider!.sortListContract[_scanPayM.assetValue].chainDecimal = 1;

  }

  Future<void> initTrxInfo() async {

    dialogLoading(context);

    try {

      String? gasPrice;
      final isValid = await trxFunc!.validateAddr(
        _scanPayM.asset!, _scanPayM.controlReceiverAddress.text, 
        context: context, org: _contractProvider!.sortListContract[_scanPayM.assetValue].org
      );

      final isEnough = await trxFunc!.checkBalanceofCoin(
        _scanPayM.asset!,
        _scanPayM.controlAmount.text,
        _scanPayM.assetValue
      );

      if (!isEnough) {
        if(!mounted) return;
        Navigator.pop(context);
        await trxFunc!.customDialog('Insufficient Balance', 'You do not have sufficient funds for transaction.');
      }

      // if (isValid) {
        gasPrice = await trxFunc!.getNetworkGasPrice(
          _scanPayM.asset!, 
          contractPro: _contractProvider,
          network: ApiProvider().isMainnet ? _contractProvider!.sortListContract[_scanPayM.assetValue].org : _contractProvider!.sortListContract[_scanPayM.assetValue].orgTest//"ERC-20"
        );
      // }


      if (isEnough) {

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
            // network: ApiProvider().isMainnet ? _contractProvider!.sortListContract[_scanPayM.assetValue].org : _contractProvider!.sortListContract[_scanPayM.assetValue].orgTest
          );
    

          decimal = 18;//_contractProvider!.sortListContract[_scanPayM.assetValue].chainDecimal!;
          final gasFee = double.parse(maxGas!) * double.parse(gasPrice);
          var gasFeeToEther = (gasFee / pow(10, decimal)).toString();

    
    

          // Check BNB balance for Fee
          // if (double.parse(gasFeeToEther) >= double.parse(_contractProvider!.listContract[_apiProvider!.bnbIndex].balance!.replaceAll(",", ""))){
          //   throw ExceptionHandler("You do not have sufficient fee for transaction.");
          // }

    

          final estGasFeePrice = await trxFunc!.estGasFeePrice(gasFee, _scanPayM.asset!, assetIndex: _scanPayM.assetValue);
    
          final totalAmt = double.parse(_scanPayM.controlAmount.text) + double.parse((gasFee / pow(10, decimal)).toString());
    
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

          // ignore: use_build_context_synchronously
          await sendTrx(trxFunc!.txInfo!, context: context);

        }
      }
    } catch (e) {

      
      // Close Dialog Loading
      Navigator.pop(context);

      await DialogComponents().customDialog(
        context,
        "Oops",
        e.toString(),
        txtButton: 'Close'
        // btn2: Container(),
        // btn: null
      ).then((value) {
        Navigator.pop(context);
      });

    }
  }
  
  Future<void> confirmSwapMethod()async {
    await initTrxInfo();
  }

  Future<dynamic> sendTrx(TransactionInfo txInfo, { @required BuildContext? context}) async {
    // try {

      await StorageServices.readSecure(DbKey.pin)!.then((value) {
        _pin = value;
      });

      trxFunc!.contract = _contractProvider;

      trxFunc!.api = Provider.of<ApiProvider>(context!, listen: false);

      trxFunc!.encryptKey = await StorageServices.readSecure(_scanPayM.asset == 'btcwif' ? 'btcwif' : DbKey.private);



      // Show Dialog Fill PIN
      if(!mounted) return;
      String resPin = await Navigator.push(context, Transition(child: const Pincode(label: PinCodeLabel.fromSendTx), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

      if (resPin != _pin){
        // ignore: use_build_context_synchronously
        await DialogComponents().customDialog(context, "Oops", "Invalid PIN,\nPlease try again.", txtButton: "Close");
        
      } else if (resPin.isNotEmpty) {
        // Second: Start Loading For Sending
        if(!mounted) return;
        dialogLoading(context, content: "This processing may take a bit longer\nPlease wait a moment");

        trxFunc!.pin = resPin;

        // if (
        //   isNative() || trxFunc!.contract!.sortListContract[_scanPayM.assetValue].symbol == "DOT"
        // ){

        //   await SubmitTrxService().sendNative(_scanPayM, trxFunc!.pin!, context, txInfo: txInfo).then((value) async {
        //     if (value == true){

        //       enableAnimation();  
        //     } else {

        //       // Close Dialog
        //       Navigator.pop(context);
        //     }
        //   });
        // } else {
          
          /* ------------------Check and Get Private------------ */

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
          

                await _contractProvider!.initErc20Service(contractAddr!);
                _scanPayM.hash = await trxFunc!.sendTxErc20(_contractProvider!.getErc20, txInfo);
                
              } else {
          
                await _contractProvider!.initBep20Service(contractAddr!);
                _scanPayM.hash = await trxFunc!.sendTxBep20(_contractProvider!.getBep20, txInfo);
              }


              // Close Dialog Loading Take Too Long
              Navigator.pop(context);
              
            }
          // }


          if (_scanPayM.hash != null){
            await enableAnimation();
          }
        }
        
      }
      
      // Close Dialog Loading
      Navigator.pop(context);
      // return _scanPayM.hash;
    // } catch (e){
    //   if (kDebugMode) {
    //  
    //   }
    //   throw Exception(e);
    // }
  }

  Future enableAnimation() async {

    Navigator.pop(context);

    Navigator.pop(context);

    setState(() {
      _scanPayM.isPay = true;
      // disable = true;
    });
    // flareController.play('Checkmark');
    await Future.delayed(const Duration(seconds: 3), (){});
    
    // if(!mounted) return;
    // Navigator.pop(context);
    // await successDialog(context, "transferred the funds.", route: HomePage(activePage: 1,));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const MyText(
          text: "Confirm Transaction",
          fontSize: 18,
          color2: Colors.black,
          fontWeight: FontWeight.w600
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Iconsax.arrow_left_2,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Stack(
        children: [

          Container(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                Row(
                  children: [
                    SvgPicture.network(widget.res!.coin_from_icon!.replaceAll("\/", "\\")),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText(
                          pLeft: 8,
                          text: "You Swap",
                          fontSize: 18,
                        ),
                        MyText(
                          pLeft: 8,
                          text: "${widget.res!.deposit_amount} ${widget.res!.coin_from} (${widget.res!.coin_from_network})",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),

          
                  ],
                ),

                const SizedBox(height: 15),

                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: hexaCodeToColor(isDarkMode ? AppColors.titleAssetColor : AppColors.primaryColor)),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(Iconsax.arrow_down, color: hexaCodeToColor(AppColors.primaryColor), size: 27),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    SvgPicture.network(widget.res!.coin_to_icon!.replaceAll("\/", "\\")),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText(
                          pLeft: 8,
                          text: "You Will Get",
                          fontSize: 18,
                        ),
                        MyText(
                          pLeft: 8,
                          text: "${widget.res!.withdrawal_amount} ${widget.res!.coin_to} (${widget.res!.coin_to_network})",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),

          
                  ],
                ),

                const SizedBox(height: 20),

                _swapInfo(widget.res!),

                const Spacer(), 
                MyGradientButton(
                  textButton: "Proceed with Swap",
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  action: () async {
                    // underContstuctionAnimationDailog(context: context);
                    confirmSwapMethod();
                  },
                ),
              ],
            ),
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

  Widget _swapInfo(SwapResponseObj res) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteColorHexa),
            borderRadius: const BorderRadius.all(Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              children: [
                Row(
                  children: [
                    MyText(
                      text: "Deposit ${res.coin_from} To",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    const Spacer(),
          
                    MyText(
                      text: widget.res!.deposit!.replaceRange(6, widget.res!.deposit!.length - 6, "..."),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.res!.deposit!),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Deposit Address is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )
                  ],
                ),

                const Divider(),

                Row(
                  children: [
                    const MyText(
                      text: "Recipient Address",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    const Spacer(),
          
                    MyText(
                      text: widget.res!.withdrawal!.replaceRange(6, widget.res!.withdrawal!.length - 6, "..."),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),
                    
                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.res!.withdrawal!),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Recipient Address is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )
                  ],
                ),

                const Divider(),
          
                Row(
                  children: const [
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "Provider",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.greyCode,
                    ),
          
                    Spacer(),
          
                    MyText(
                      pTop: 5,
                      pBottom: 5,
                      text: "LetsExchange.io",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    )
                  ],
                ),

              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.whiteColorHexa),
            borderRadius: const BorderRadius.all(Radius.circular(18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              children: [
          
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText(
                          pTop: 5,
                          text: "Exchange ID",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          hexaColor: AppColors.greyCode,
                        ),
                        MyText(
                          width: MediaQuery.of(context).size.width / 2.2,
                          text: "Copy Exchange ID to check transaction status",
                          fontSize: 12,
                          hexaColor: AppColors.primaryColor,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
          
                    const Spacer(),
          
                    MyText(
                      text: res.transaction_id,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      hexaColor: AppColors.blackColor,
                    ),

                    IconButton(
                      icon: Icon(Iconsax.copy, color: hexaCodeToColor(AppColors.primaryColor)),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: res.transaction_id!),
                        );
                        /* Copy Text */
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Exchange ID is Copied to Clipboard"),
                          ),
                        );
                      },  
                    )

                    
                  ],
                ),

              ],
            ),
          ),
        ),

      ],
    );
  }

}