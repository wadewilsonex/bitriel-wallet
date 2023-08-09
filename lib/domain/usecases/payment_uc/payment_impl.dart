import 'dart:math';
import 'package:bitriel_wallet/index.dart';
import 'package:get/utils.dart';

class PaymentUcImpl implements PaymentUsecases {

  TextEditingController recipientController = TextEditingController();
  
  TextEditingController amountController = TextEditingController();

  WalletProvider? walletProvider;

  SDKProvider? _sdkProvider;
  BuildContext? context;

  ValueNotifier<int> index = ValueNotifier(0);

  ServiceTx get serviceTx => _sdkProvider!.getSdkImpl.getWalletSdk.api.service.tx;

  List<SmartContractModel> get lstContractDropDown => walletProvider!.sortListContract!;
  
  ValueNotifier<String> trxMessage = ValueNotifier("");

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


    try {
      
      // Check Input Not Equal 0
      // Check Input Not Less than Existing coin's balance
      if ( amountController.text.isNotEmpty && double.parse(amountController.text) >= double.parse(lstContractDropDown[index.value].balance!) ){
        
        dialogLoading(context!);

        if (walletProvider!.sortListContract![index.value].isBep20 == true) {
          if (checkFeeAndTrxAmount(double.parse(walletProvider!.listEvmNative![0].balance!), network: "BNB") == true) {

            await sendBep20();
          }
        }
        else if (walletProvider!.sortListContract![index.value].isErc20 == true){
          if (checkFeeAndTrxAmount(double.parse(walletProvider!.listEvmNative![1].balance!), network: "Ethereum") == true) {

            await sendErc20();
          }
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
      } else if (trxMessage.value.isEmpty) {
        trxMessage.value = "Balance must greater than 0";
      }

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
      // final fee = await serviceTx.estimateFees(
      //   txInfo.toJson(),
      //   jsonEncode([
      //     recipientController.text,
      //     Fmt.tokenInt(
      //       amountController.text,
      //       18,
      //     ).toString(),
      //   ]),
      // );

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

  bool checkFeeAndTrxAmount(double networkFee, {String network = ""}) {
    if (
      networkFee.isGreaterThan(0.0005)
    ){
      if ( double.parse(amountController.text) > double.parse(lstContractDropDown[index.value].balance!) ){
        trxMessage.value = "Input amount greater than your existing balance";
      }
      trxMessage.value = "Low gas fee of $network to make transaction";
      return false;
    }
    return true;
  }

  /// Sen Any Bep20 contract
  Future<void> sendBep20() async {
    print('sendBep20');
    try {
      
      // 1
      
      String encryptKey = (await SecureStorage.readData(key: DbKey.private))!;

      EthPrivateKey pkKey = _sdkProvider!.getSdkImpl.getPrivateKey(encryptKey);

      DeployedContract bscDeployedContract = await _sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", lstContractDropDown[index.value].contract!);

      // transaction fee 5 gwei, which is about $0.0005
      // 2
      BigInt networkGas = (await _sdkProvider!.getSdkImpl.getBscClient.estimateGas(
        sender: pkKey.address, //EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.evmAddress!),
        // to: EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.bscDeployedContract.address!),
        to: EthereumAddress.fromHex(lstContractDropDown[index.value].contract!),
        data: bscDeployedContract.function('transfer').encodeCall(
          [
            EthereumAddress.fromHex(recipientController.text),
            BigInt.from( double.parse(amountController.text) * pow(10, 18) )
          ],
        ),
      ));

      await _sdkProvider!.getSdkImpl.getBscClient.sendTransaction(
        pkKey,
        Transaction.callContract(
          contract: bscDeployedContract,
          // gasPrice: gasPrice,
          maxGas: networkGas.toInt(),
          function: bscDeployedContract.function('transfer'), 
          parameters: [
            EthereumAddress.fromHex(recipientController.text),
            BigInt.from( double.parse(amountController.text) * pow(10, 18) )
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

  // 2
  // BigInt networkGas = (await _sdkProvider!.getSdkImpl.getBscClient.estimateGas(
  //   sender: pkKey.address, //EthereumAddress.fromHex(_sdkProvider!.getSdkImpl.evmAddress!),
  //   to: _sdkProvider!.getSdkImpl.bscDeployedContract!.address,// Coin's Contract
  //   data: _sdkProvider!.getSdkImpl.bscDeployedContract!.function('transfer').encodeCall(
  //     [
  //       EthereumAddress.fromHex(recipientController.text),
  //       BigInt.from( double.parse(amountController.text) * pow(10, 18) )
  //     ],
  //   ),
  // ));

  // print("networkGas $networkGas");

  // hash = await _sdkProvider!.getSdkImpl.getBscClient.sendTransaction(
  //   pkKey,
  //   Transaction.callContract(
  //     contract: _sdkProvider!.getSdkImpl.bscDeployedContract!,
  //     // gasPrice: gasPrice,
  //     maxGas: networkGas.toInt(),
  //     function: _sdkProvider!.getSdkImpl.bscDeployedContract!.function('transfer'), 
  //     parameters: [
  //       EthereumAddress.fromHex(recipientController.text),
  //       BigInt.from( double.parse(amountController.text) * pow(10, 18) )
  //     ],
  //   ),
  //   chainId: null,
  //   fetchChainIdFromNetworkId: true,
  // );

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