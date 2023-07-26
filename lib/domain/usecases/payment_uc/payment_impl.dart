import 'package:bitriel_wallet/index.dart';

class PaymentUcImpl implements PaymentUsecases {

  TextEditingController addrController = TextEditingController();
  
  TextEditingController amountController = TextEditingController();

  WalletProvider? walletProvider;

  SDKProvider? _sdkProvider;

  ValueNotifier<int> index = ValueNotifier(0);

  set setBuildContext(BuildContext context){
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _sdkProvider = Provider.of<SDKProvider>(context, listen: false);
  }

  void onChanged(String? value){
    if (value!.toLowerCase().contains( (walletProvider!.sortListContract![index.value].symbol!.substring(0, 1).toLowerCase()) )){
      print("True");
    } else {
      print("False");
    }
  }

  Future<void> submitTrx() async {
    
    if (walletProvider!.sortListContract![index.value].isBep20 == true) {
      await sendBep20();
    }
    else if (walletProvider!.sortListContract![index.value].isErc20 == true){
      await sendErc20();
    }
    else if (walletProvider!.sortListContract![index.value].isBSC == true){
      await sendBsc();
    }
    else if (walletProvider!.sortListContract![index.value].isEther == true){
      await sendEther();
    }
    else {
      sendNative();
    }
  }

  /// Send Token: BTC, SEL...
  Future<void> sendNative() async {

    if (addrController.text.toLowerCase().contains("se")){
      // Send SEL
    }
    else {
      // Send BTC
    }
  }

  /// Sen Any Bep20 contract
  Future<void> sendBep20() async {
    
    // _sdkProvider!.getSdkImpl.bscDeployedContract ??=  await _sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", controller.text);
  }

  /// Send Any Erc20 contract
  Future<void> sendErc20() async {

  }

  /// Send BNB
  Future<void> sendBsc() async {

  }

  /// Send Ethereum
  Future<void> sendEther() async {

  }
}