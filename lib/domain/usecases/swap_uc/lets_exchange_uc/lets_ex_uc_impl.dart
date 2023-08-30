import 'package:bitriel_wallet/index.dart';

class LetsExchangeUCImpl implements LetsExchangeUseCases {

  BuildContext? _context;
  
  /// Data Of Coin 1
  ValueNotifier<LetsExCoinByNetworkModel> coin1 = ValueNotifier(LetsExCoinByNetworkModel());
  /// Data Of Coin 2
  ValueNotifier<LetsExCoinByNetworkModel> coin2 = ValueNotifier(LetsExCoinByNetworkModel());

  final LetsExchangeRepoImpl _letsExchangeRepoImpl = LetsExchangeRepoImpl();

  List<LetsExchangeCoin> defaultLstCoins = [];

  ValueNotifier<List<LetsExCoinByNetworkModel>> lstLECoin = ValueNotifier([]);

  Widget? imgConversion;

  SwapModel swapModel = SwapModel();

  ValueNotifier<List<SwapResModel>> lstTx = ValueNotifier([]);

  final PaymentUcImpl _paymentUcImpl = PaymentUcImpl();
  
  CoinInfo coinInfo = CoinInfo();

  set setContext(BuildContext ctx){
    _context = ctx;
    _paymentUcImpl.setBuildContext = ctx;
  }

  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  @override
  Future<void> getLetsExchangeCoin() async {
    
    if(defaultLstCoins.isEmpty){
      defaultLstCoins = await _letsExchangeRepoImpl.getLetsExchangeCoin();
    }

    if (lstTx.value.isEmpty){

      _secureStorageImpl.readSecure(DbKey.lstTxIds)!.then( (localLstTx){

        if (localLstTx.isNotEmpty){

          lstTx.value = List<Map<String, dynamic>>.from((json.decode(localLstTx))).map((e) {
            return SwapResModel.fromJson(e);
          }).toList();
        }

      });

    }

    lstCoinExtract();
    
  }
  
  void lstCoinExtract() {

    for(int i = 0; i < defaultLstCoins.length; i++){

      for (int j = 0; j < defaultLstCoins[i].networks!.length; j++){
        addCoinByIndex(i, j);
      }

    }

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    lstLECoin.notifyListeners();

    print("lstLECoin ${lstLECoin.value.length}");
  }

  void addCoinByIndex(int i, int j) {

    if (defaultLstCoins[i].icon != null){

    //   if (lstCoins![i]['icon'].contains('svg')){
    //     imgConversion = SvgPicture.network(lstCoins![i]['icon'], width: 10);
    //   } else if (lstCoins![i]['icon'] != null){
    //     imgConversion = Image.network(lstCoins![i]['icon'], width: 10);
    //   }
    // }
    // // Null 
    // else {
    //   imgConversion = CircleAvatar(child: Container(width: 10, height: 10, color: Colors.green,),);
    }

    if (
      defaultLstCoins[i].networks![j].code == "BTC" ||
      defaultLstCoins[i].networks![j].code == "BEP20" ||
      defaultLstCoins[i].networks![j].code == "ERC20" ||
      defaultLstCoins[i].networks![j].code == "Ethereum" ||
      defaultLstCoins[i].networks![j].code == "Binance Chain"
    ){

      lstLECoin.value.add(
        LetsExCoinByNetworkModel(
          title: defaultLstCoins[i].code,
          subtitle: defaultLstCoins[i].name,
          // isActive: index2 == i ? true : false,
          image: Container(),//imgConversion!,
          network: defaultLstCoins[i].networks![j].name!,
          networkCode: defaultLstCoins[i].networks![j].code,
          balance: "0"//contractProvider!.sortListContract[i].balance,
          
        )
      );
    }

  }


  @override 
  void onDeleteTxt() {

    final formattedValue = formatCurrencyText(swapModel.amt!.value);

    swapModel.amt!.value = formattedValue;

    if (swapModel.amt!.value.isNotEmpty) {
      swapModel.amt!.value = swapModel.amt!.value.substring(0, swapModel.amt!.value.length - 1);
    }

  }

  String formatCurrencyText(String value) {
    return value;
  }

  @override
  void formatDouble(String value) {

    if (swapModel.amt!.value.replaceAll(".", "").length < 10){
      // Value Equal Empty & Not Contains "."
      if (value.contains(".") && !(swapModel.amt!.value.contains(".")) && swapModel.amt!.value.isEmpty){

        swapModel.amt!.value = "0.";

      } 
      // Prevent Add "." Multiple Time.
      // Reject Input "." Evertime
      else if ( !(value.contains("."))) {

        swapModel.amt!.value = swapModel.amt!.value + value;

      }
      // Add "." For Only one time.
      else if ( !(swapModel.amt!.value.contains(".")) ){

        swapModel.amt!.value = swapModel.amt!.value + value;
      }
    }

  }

  void setCoin(BuildContext context, bool isFrom){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectSwapToken(itemLE: lstLECoin.value))
    ).then((res) {

      if (res != null){

        if (isFrom == true){

          coin1.value = lstLECoin.value[res];
          swapModel.from = coin1.value.title;
          swapModel.networkFrom = coin1.value.network;

        } else {
          
          coin2.value = lstLECoin.value[res];
          swapModel.to = coin1.value.title;
          swapModel.networkTo = coin1.value.network;
        }
        
      }
    });
  }

  @override
  Future<void> swap() async {

    print("swap");
    print(swapModel.toJson());
    
    try {

      dialogLoading(_context!);

      await _letsExchangeRepoImpl.swap(swapModel.toJson()).then((value) async {
        
        if (value.statusCode == 401){
          throw json.decode(value.body)['error'];
        }
        // Unprocessable entity
        else if (value.statusCode == 422) {
          throw (json.decode(value.body)['error']['validation'].containsKey("coin_from") 
            ? "The selected first coin is not active." 
            : "The selected second coin is not active." 
          );
        }

        else if (value.statusCode == 200) {

          lstTx.value.add(SwapResModel.fromJson(json.decode(value.body)));
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          lstTx.notifyListeners();

          print("value ${value.body}");
          
          await SecureStorageImpl().writeSecure(DbKey.lstTxIds, json.encode(SwapResModel().toJson(lstTx.value)));


          // Close Dialog
          Navigator.pop(_context!);

          await QuickAlert.show(
            context: _context!,
            type: QuickAlertType.success,
            showCancelBtn: true,
            cancelBtnText: "Close",
            cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
            text: 'Swap Successfully!',
          );
        } else {
          throw json.decode(value.body);
        }
      });

    } catch (e) {

      print(e);

      // Close Dialog
      Navigator.pop(_context!);
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        text: '$e',
      );
    }
  }

  // Index Of List
  Future<void> paySwap(int index) async {

    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => const PincodeScreen(title: '', label: PinCodeLabel.fromSendTx,))
    ).then((value) async {

      _paymentUcImpl.recipientController.text = lstTx.value[index].deposit!;
      _paymentUcImpl.amountController.text = lstTx.value[index].deposit_amount!;

      if (value != null){
        await _paymentUcImpl.sendBep20();
      }
    });

    // await QuickAlert.show(
    //   context: _context!,
    //   type: QuickAlertType.warning,
    //   showCancelBtn: true,
    //   cancelBtnText: "Close",
    //   cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
    //   text: 'Under maintenance',
    // );

  }

  @override
  Future<void> confirmSwap(SwapResModel swapResModel) async {
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => ConfirmSwapExchange(swapResModel: swapResModel, confirmSwap: swapping,))
    );
  }

  @override
  Future<void> swapping(SwapResModel swapResModel) async {
    await queryContractById(swapResModel.coin_from!);
  }

  @override
  Future<void> queryContractById(String id) async {
    try {

      await HttpRequestImpl().getContractById(id).then((value) {
        coinInfo = CoinInfo.fromJson(value);
        print(coinInfo.platforms);
      });

    } catch (e) {
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        showCancelBtn: true,
        cancelBtnText: "Close",
        cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
        text: 'Coin not found',
      );
    }
  }

}