import 'package:bitriel_wallet/index.dart';

class LetsExchangeUCImpl implements LetsExchangeUseCases {

  BuildContext? _context;
  
  /// Data Of Coin 1
  ValueNotifier<LetsExCoinByNetworkModel> coin1 = ValueNotifier(LetsExCoinByNetworkModel());
  /// Data Of Coin 2
  ValueNotifier<LetsExCoinByNetworkModel> coin2 = ValueNotifier(LetsExCoinByNetworkModel());
  
  ValueNotifier<bool> isLstCoinReady = ValueNotifier(false);

  final LetsExchangeRepoImpl _letsExchangeRepoImpl = LetsExchangeRepoImpl();

  List<LetsExchangeCoin> defaultLstCoins = [];

  Widget? imgConversion;

  SwapModel swapModel = SwapModel();

  CoinInfo coinInfo = CoinInfo();

  final PaymentUcImpl _paymentUcImpl = PaymentUcImpl();

  ValueNotifier<List<LetsExCoinByNetworkModel>> lstLECoin = ValueNotifier([]);

  ValueNotifier<List<SwapResModel?>> lstTx = ValueNotifier([]);

  int? index;

  ValueNotifier<bool> isReady = ValueNotifier(false);

  set setContext(BuildContext ctx){
    _context = ctx;
    _paymentUcImpl.setBuildContext = ctx;

    lstTx.value.length = 1;
    print(lstTx.value.length);
    print(lstTx.value[0]);
  }

  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  @override
  Future<void> getLetsExchangeCoin() async {
    
    if(defaultLstCoins.isEmpty){
      defaultLstCoins = await _letsExchangeRepoImpl.getLetsExchangeCoin();
    }

    _secureStorageImpl.readSecure(DbKey.lstTxIds)!.then( (localLstTx){

      print("localLstTx $localLstTx");

      if (localLstTx.isNotEmpty){

        lstTx.value.clear();

        lstTx.value = List<Map<String, dynamic>>.from((json.decode(localLstTx))).map((e) {
          return SwapResModel.fromJson(e);
        }).toList();
      }

    });

    lstCoinExtract();
    
  }
  
  void lstCoinExtract() {

    for(int i = 0; i < defaultLstCoins.length; i++){

      for (int j = 0; j < defaultLstCoins[i].networks!.length; j++){
        addCoinByIndex(i, j);
      }

    }

    isLstCoinReady.value = true;

    print(isLstCoinReady.value);
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

    if (Validator.swapValidator(swapModel.from!, swapModel.to!, swapModel.amt!.value) == true){
      isReady.value = true;
    } else if (isReady.value == true){
      isReady.value = false;
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
          swapModel.networkFrom = coin1.value.networkCode;

        } else {
          
          coin2.value = lstLECoin.value[res];
          swapModel.to = coin2.value.title;
          swapModel.networkTo = coin2.value.networkCode;
        }

        swapModel.withdrawal = Provider.of<SDKProvider>(context, listen: false).getSdkImpl.evmAddress;
        
        if (Validator.swapValidator(swapModel.from!, swapModel.to!, swapModel.amt!.value) == true){
          isReady.value = true;
        } else if (isReady.value == false) {
          isReady.value = false;
        }
        
      }
    });
  }

  @override
  Future<void> swap() async {
    
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

      _paymentUcImpl.recipientController.text = lstTx.value[index]!.deposit!;
      _paymentUcImpl.amountController.text = lstTx.value[index]!.deposit_amount!;

      if (value != null){
        await _paymentUcImpl.sendBep20();
      }
    });

  }

  @override
  Future<void> confirmSwap(int indx) async {
    index = indx;
    Navigator.push(
      _context!,
      MaterialPageRoute(builder: (context) => ConfirmSwapExchange(swapResModel: lstTx.value[index!], confirmSwap: swapping, getStatus: getStatus))
    );
  }

  @override
  Future<void> swapping(SwapResModel swapResModel) async {
    
    int index = Provider.of<WalletProvider>(_context!, listen: false).sortListContract!.indexWhere((model) {
      
      if ( swapResModel.coin_from!.toLowerCase() == model.symbol!.toLowerCase() ){
        isReady.value = true;
        return true;
      }

      return false;

    });

    if (index != -1){

      await Navigator.pushReplacement(
        _context!,
        MaterialPageRoute(builder: (context) => TokenPayment(index: index, address: swapResModel.withdrawal, amt: swapResModel.deposit_amount,))
      );
      
    } else {
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.warning,
        showCancelBtn: true,
        cancelBtnText: "Close",
        cancelBtnTextStyle: TextStyle(fontSize: 14, color: hexaCodeToColor(AppColors.primaryBtn)),
        text: '${swapResModel.coin_from!} (${swapResModel.coin_from_network}) is not found. Please add contract token !',
        confirmBtnText: 'Add Contract',
        onConfirmBtnTap: (){
          Navigator.pushReplacement(
            _context!, 
            MaterialPageRoute(builder: (context) => AddAsset(index: swapResModel.coin_from_network == "BEP20" ? 0 : 1,))
          );
        }
      );

    }
  }

  /// This function for update status inside details
  Future<void> getStatus() async {
    
    dialogLoading(_context!, content: "Checking Status");

    await _letsExchangeRepoImpl.getLetsExStatusByTxId(lstTx.value[index!]!.transaction_id!).then((value) {
      print("value.body ${value.body}");
      lstTx.value[index!] = SwapResModel.fromJson(json.decode(value.body));

    });

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    lstTx.notifyListeners();

    await SecureStorageImpl().writeSecure(DbKey.lstTxIds, json.encode(SwapResModel().toJson(lstTx.value)));

    // Close Dialog
    Navigator.pop(_context!);
  }

}