import 'dart:math';

import 'package:bitriel_wallet/index.dart';

class PaymentUcImpl implements PaymentUsecases {

  TextEditingController recipientController = TextEditingController();
  
  TextEditingController amountController = TextEditingController();

  WalletProvider? walletProvider;

  SDKProvider? _sdkProvider;
  BuildContext? context;

  ValueNotifier<int> index = ValueNotifier(0);

  ServiceTx get serviceTx => _sdkProvider!.getSdkImpl.getWalletSdk.api.service.tx;

  List<SmartContractModel> get lstContractDropDown => walletProvider!.sortListContract!;

  set setBuildContext(BuildContext ctx){
    context = ctx;
    walletProvider = Provider.of<WalletProvider>(ctx, listen: false);
    _sdkProvider = Provider.of<SDKProvider>(ctx, listen: false);
  }

  void onChanged(String? value){
    if (value!.toLowerCase().contains( (walletProvider!.sortListContract![index.value].symbol!.substring(0, 1).toLowerCase()) )){
      print("True");
    } else {
      print("False");
    }
  }

  Future<void> submitTrx() async {

    dialogLoading(context!);

    try {

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
        await sendNative();
      }

      // Close Dialog Loading
      Navigator.pop(context!);

      await QuickAlert.show(
        context: context!,
        type: QuickAlertType.success,
        text: 'Transaction Completed Successfully!',
      );

    } catch (e) {

      // Close Dialog Loading
      Navigator.pop(context!);
      
      await QuickAlert.show(
        context: context!,
        type: QuickAlertType.error,
        text: 'Transaction failed',
      );
    }
    
  }

  /// Send Token: BTC, SEL...
  Future<void> sendNative() async {

    if (recipientController.text.toLowerCase().contains("se")){
      // Send SEL

      // 1. Assign Sender indentity.
      final sender = TxSenderData(
        _sdkProvider!.getSdkImpl.getKeyring.current.address,
        _sdkProvider!.getSdkImpl.getKeyring.current.pubKey
      );

      final txInfo = TxInfoData('balances', 'transfer', sender);

      // 2. Estimate Gas Fee
      final fee = await serviceTx.estimateFees(
        txInfo.toJson(),
        jsonEncode([
          recipientController.text,
          Fmt.tokenInt(
            amountController.text,
            18,
          ).toString(),
        ]),
      );

      // 3. Start Sign And Send Transaction
      await serviceTx.signAndSend(
        txInfo.toJson(), 
        jsonEncode([
          recipientController.text,
          Fmt.tokenInt(
            amountController.text,
            18,
          ).toString(),
        ]), 
        "111111", 
        (p0) => null
      );

    }
    else {
      // Send BTC
    }
  }

  /// Sen Any Bep20 contract
  Future<void> sendBep20() async {
    
    try {
      // 1
      _sdkProvider!.getSdkImpl.bscDeployedContract ??=  await _sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", lstContractDropDown[index.value].contract!);

      
      String encryptKey = (await SecureStorage.readData(key: DbKey.private))!;

      EthPrivateKey pkKey = _sdkProvider!.getSdkImpl.getPrivateKey(encryptKey);

      // 2
      BigInt networkGas = (await _sdkProvider!.getSdkImpl.getBscClient.estimateGas(
        sender: pkKey.address,
        to: _sdkProvider!.getSdkImpl.bscDeployedContract!.address,
        data: _sdkProvider!.getSdkImpl.bscDeployedContract!.function('transfer').encodeCall(
          [
            EthereumAddress.fromHex(recipientController.text),
            BigInt.from( double.parse(amountController.text) * pow(10, 18 ) )
          ],
        ),
      ));

      print("networkGas $networkGas");

      // 3. Estimate Market Price with amount of send
      // BigInt networkGas = (await _sdkProvider!.getSdkImpl.getBscClient.estimateGas());

      // 4.
      // dynamic maxGas;// = (await _sdkProvider!.getSdkImpl.getBscClient.getM);

      await _sdkProvider!.getSdkImpl.getBscClient.sendTransaction(
        pkKey,
        Transaction.callContract(
          contract: _sdkProvider!.getSdkImpl.bscDeployedContract!,
          maxGas: networkGas.toInt(),
          function: _sdkProvider!.getSdkImpl.bscDeployedContract!.function('transfer'), 
          parameters: [
            recipientController.text,
            BigInt.from( double.parse(amountController.text) * pow(10, 18 ) )
          ],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      ).then((value) {
        print("value $value");
      });
    } catch (e) {
      print("error sendBep20 ${e}");
    }
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