import 'dart:math';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/service/contract.dart';
import 'package:wallet_apps/src/service/native.dart';

class TrxFunctional {

  ApiProvider? api;
  String? pin;
  String? encryptKey;
  String? privateKey;
  ContractProvider? contract;
  TransactionInfo? txInfo;
  final BuildContext? context;
  final Function? enableAnimation;
  final Function? validateAddress;

  TrxFunctional.init({this.context, this.enableAnimation, this.validateAddress});

  /*  ---------------Message-------------- */
  Future<void> customDialog(String text1, String text2) async {
    await showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: hexaCodeToColor(isDarkMode ? AppColors.darkBgd : AppColors.lightColorBg),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: MyText(
              fontSize: 20,
              text: text1,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: MyText(
              text: text2,
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const MyText(
                text: 'Close',
                fontWeight: FontWeight.bold,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //  customDialog(
  //         'Insufficient Balance', 'Your loaded balance is not enough to swap.');

  /* --------------Local Storage----------------- */

  Future<dynamic>? getPrivateKey(String pin, {@required BuildContext? context}) async {
    privateKey = null;
    try {
      privateKey = await Provider.of<ApiProvider>(context!, listen: false).decryptPrivateKey(encryptKey!, pin);
    } catch (e) {
      // Navigator.pop(context);
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print('Error getPrivateKey $e');
        }
      }
      // await customDialog('Opps', 'PIN verification failed');
    }

    return privateKey!;
  }

  Future<void> saveTxHistory(TxHistory txHistory) async {
    await StorageServices.addTxHistory(txHistory, DbKey.txtHistory);
  }

  /* ------------------Transaction--------------- */

  Future<void> sendTxBnb(String reciever, String amount, {required int? chainDecimal}) async {
    try{
      if (privateKey != null) {

        final hash = await contract!.getBnb.sendTx(
          TransactionInfo(
            chainDecimal: chainDecimal,
            privateKey: privateKey,
            receiver: contract!.getEthAddr(reciever),
            amount: amount
          )
        );

        // final hash = await contract.sendTxBnb(privateKey, reciever, amount);

        if (hash != null) {
          // final status = await contract.bnb.listenTransfer(hash);
          // if (!status) {
          //   Navigator.pop(context);
          //   await customDialog('Transaction failed',
          //       'Something went wrong with your transaction.');
          // } else {
          //   enableAnimation();
          // }
        } else {
          // Close Dialog
          Navigator.pop(context!);
          await customDialog("Oops", "The PIN you entered is incorrect");
        }
      }
    } catch (e) {
      
      if (kDebugMode) {
        print("err sendTxBnb $e");
      }
    }
  }

  // Future<void> sendTxBtc(String to, String amount) async {
  //   final resAdd = await api!.validateBtcAddr(to);

  //   if (resAdd) {
  //     final res = await api!.sendTxBtc(
  //         context!, api!.btcAdd, to, double.parse(amount), privateKey!);
  //     if (res == 200) {
  //       enableAnimation!();
  //     } else {
  //       Navigator.pop(context!);
  //       await customDialog('Opps', 'Something went wrong!');
  //     }
  //   } else {
  //     Navigator.pop(context!);
  //     await customDialog('Opps', 'Invalid Address');
  //   }
  // }

  Future<void> sendTxEther(String reciever, String amount, {required int? chainDecimal}) async {

    try {
      if (privateKey != null) {
        final txInfo = TransactionInfo(
          chainDecimal: chainDecimal,
          privateKey: privateKey,
          receiver: contract!.getEthAddr(reciever),
          amount: amount
        );
        final hash = await contract!.getEth.sendTx(txInfo);
        if (hash != null) {
          final status = await contract!.getEth.listenTransfer(hash);

          if (!status!) {
            Navigator.pop(context!);
            await customDialog('Transaction failed',
                'Something went wrong with your transaction.');
          } else {
            enableAnimation!();
          }
        } else {
          Navigator.pop(context!);
          await customDialog('Opps', 'Something went wrong!');
        }
      }
    } catch (e) {
      Navigator.pop(context!);
      if (e.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Opps', e.toString());
      }
    }
  }

  Future<dynamic> sendTxEvm(NativeService coinService, TransactionInfo txInfo) async {
    if (txInfo.privateKey != null) {
      try {
        final hash = await coinService.sendTx(txInfo);

        // if (hash != null) {
        //   txInfo.hash = hash;
        //   txInfo.timeStamp = DateFormat('yyyy-MM-dd HH:mm:ss a').format(DateTime.now());
        //   await navigateAssetInfo(txInfo, nativeService: coinService);
        // }
        return hash;
      } catch (e) {
        if (ApiProvider().isDebug == true) {
          if (kDebugMode) {
            print('Err sendTxEvm $e');
          }
        }
        if (e.toString().contains('insufficient funds for gas * price + value')) {
          await customDialog('Opps', 'Insufficient funds for gas');
        } else {
          await customDialog('Opps', e.toString());
        }
      }
    }
  }

  Future<dynamic> sendTxErc20(ContractService tokenService, TransactionInfo txInfo) async {
    
    if (txInfo.privateKey != null) {
      try {
        String? hash = await tokenService.sendToken(txInfo);
        // if (hash != null) {
        //   txInfo.hash = hash;
        //   txInfo.scanUrl = ApiProvider().isMainnet ? AppConfig.networkList[3].scanMn! : AppConfig.networkList[3].scanTN! + txInfo.hash!;
        //   txInfo.timeStamp = DateFormat('yyyy-MM-dd HH:mm:ss a').format(DateTime.now());

          // await navigateAssetInfo(txInfo, tokenService: tokenService);
        // }
        return hash;
      } catch (e) {
        // Navigator.pop(context);
        if (ApiProvider().isDebug == true) {
          if (kDebugMode) {
            print('Error sendTxBep20 $e');
          }
        }
        if (e.toString().contains('insufficient funds for gas * price + value')) {
          await customDialog('Opps', 'Insufficient funds for gas');
        } else {
          await customDialog('Opps', e.toString());
        }
        throw Exception(e);
      }
    }
  }

  Future<dynamic> sendTxBep20(ContractService tokenService, TransactionInfo txInfo) async {
    
    if (txInfo.privateKey != null) {
      try {
        String? hash = await tokenService.sendToken(txInfo);
        // if (hash != null) {
        //   txInfo.hash = hash;
        //   txInfo.scanUrl = ApiProvider().isMainnet ? AppConfig.networkList[3].scanMn! : AppConfig.networkList[3].scanTN! + txInfo.hash!;
        //   txInfo.timeStamp = DateFormat('yyyy-MM-dd HH:mm:ss a').format(DateTime.now());

          // await navigateAssetInfo(txInfo, tokenService: tokenService);
        // }
        return hash;
      } catch (e) {
        // Navigator.pop(context);
        if (ApiProvider().isDebug == true) {
          if (kDebugMode) {
            print('Error sendTxBep20 $e');
          }
        }
        if (e.toString().contains('insufficient funds for gas * price + value')) {
          await customDialog('Opps', 'Insufficient funds for gas');
        } else {
          await customDialog('Opps', e.toString());
        }
        throw Exception(e);
      }
    }
  }

  // void navigateNativeInfo() {
  //   switch ()
  // }

  Future<void> navigateAssetInfo(TransactionInfo info, {ContractService? tokenService, NativeService? nativeService}) async {
    try {
      switch (info.coinSymbol) {
        case "SEL":
          await contract!.addListActivity(info, 0, contractService: tokenService);

          // Navigator.push(
          //   context,
          //   RouteAnimation(
          //     enterPage: AssetInfo(
          //       index: 0,
          //       scModel: contract.listContract[0],
          //       // id: contract.listContract[0].id,
          //       // assetLogo: contract.listContract[0].logo,
          //       // balance:
          //       //     contract.listContract[0].balance ?? AppString.loadingPattern,
          //       // tokenSymbol: contract.listContract[0].symbol ?? '',
          //       // org: contract.listContract[0].org,
          //       // marketData: contract.listContract[0].marketData,
          //       // marketPrice: contract.listContract[0].marketPrice,
          //       // transactionInfo:
          //       //     contract.listContract[0].listActivity.reversed.toList(),
          //       // priceChange24h: contract.listContract[0].change24h,
          //       // showActivity: true,
          //     ),
          //   ),
          // );
          break;
        case "SEL (v2)":
          await contract!.addListActivity(info, 1, contractService: tokenService);

          // Navigator.push(
          //   context,
          //   RouteAnimation(
          //     enterPage: AssetInfo(
          //       index: 1,
          //       scModel: contract.listContract[1]
          //       // id: contract.listContract[1].id,
          //       // assetLogo: contract.listContract[1].logo,
          //       // balance:
          //       //     contract.listContract[1].balance ?? AppString.loadingPattern,
          //       // tokenSymbol: contract.listContract[1].symbol ?? '',
          //       // org: contract.listContract[1].org,
          //       // marketData: contract.listContract[1].marketData,
          //       // marketPrice: contract.listContract[1].marketPrice,
          //       // transactionInfo:
          //       //     contract.listContract[1].listActivity.reversed.toList(),
          //       // priceChange24h: contract.listContract[1].change24h,
          //     ),
          //   ),
          // );

          break;

        case "KGO":
          await contract!.addListActivity(info, 2, contractService: tokenService);

          // Navigator.push(
          //   context,
          //   RouteAnimation(
          //     enterPage: AssetInfo(
          //       index: 2,
          //       scModel: contract.listContract[2]
          //       // id: contract.listContract[2].id,
          //       // assetLogo: contract.listContract[2].logo,
          //       // balance:
          //       //     contract.listContract[2].balance ?? AppString.loadingPattern,
          //       // tokenSymbol: contract.listContract[2].symbol ?? '',
          //       // org: contract.listContract[2].org,
          //       // marketData: contract.listContract[2].marketData,
          //       // marketPrice: contract.listContract[2].marketPrice,
          //       // transactionInfo:
          //       //     contract.listContract[2].listActivity.reversed.toList(),
          //       // priceChange24h: contract.listContract[2].change24h,
          //     ),
          //   ),
          // );
          break;
        case "ETH":
          await contract!.addListActivity(info, 3, nativeService: nativeService);

          // Navigator.push(
          //   context,
          //   RouteAnimation(
          //     enterPage: AssetInfo(
          //       index: 3,
          //       scModel: contract.listContract[3]
          //       // id: contract.listContract[3].id,
          //       // assetLogo: contract.listContract[3].logo,
          //       // balance:
          //       //     contract.listContract[3].balance ?? AppString.loadingPattern,
          //       // tokenSymbol: contract.listContract[3].symbol ?? '',
          //       // org: contract.listContract[3].org,
          //       // marketData: contract.listContract[3].marketData,
          //       // marketPrice: contract.listContract[3].marketPrice,
          //       // transactionInfo:
          //       //     contract.listContract[3].listActivity.reversed.toList(),
          //       // priceChange24h: contract.listContract[3].change24h,
          //     ),
          //   ),
          // );
          break;
        case "BNB":
          await contract!.addListActivity(info, 4, nativeService: nativeService);

          // Navigator.push(
          //   context,
          //   RouteAnimation(
          //     enterPage: AssetInfo(
          //       index: 4,
          //       scModel: contract.listContract[4]
          //       // id: contract.listContract[4].id,
          //       // assetLogo: contract.listContract[4].logo,
          //       // balance:
          //       //     contract.listContract[4].balance ?? AppString.loadingPattern,
          //       // tokenSymbol: contract.listContract[4].symbol ?? '',
          //       // org: contract.listContract[4].org,
          //       // marketData: contract.listContract[4].marketData,
          //       // marketPrice: contract.listContract[4].marketPrice,
          //       // transactionInfo:
          //       //     contract.listContract[4].listActivity.reversed.toList(),
          //       // priceChange24h: contract.listContract[4].change24h,
          //     ),
          //   ),
          // );
          break;
      }

      // Navigator.pushNamedAndRemoveUntil(context, Home.route, ModalRoute.withName('/'));
    } catch (e){

      if (kDebugMode) {
        print("Err navigateAssetInfo $e");
      }
    }
  }

  void updateTxStatus() {}

  // Future<void> sendTxBsc(String contractAddr, String chainDecimal,
  //     String reciever, String amount) async {
  //   try {
  //     if (privateKey != null) {
  //       final txInfo = TransactionInfo(privateKey: privateKey,receiver: contract.getEthAddr(reciever),amount: amount);
  //       final hash = await contract.g

  //       if (hash != null) {
  //         final status = await contract.getSelToken.listenTransfer(hash);
  //         if (!status) {
  //           Navigator.pop(context);
  //           await customDialog(
  //               'Transaction failed', 'insufficient funds for gas');
  //         } else {
  //           enableAnimation();
  //         }
  //       } else {
  //         Navigator.pop(context);
  //         await customDialog('Opps', 'Something went wrong!');
  //       }
  //     }
  //     // Res equal NULL
  //     else {
  //       Navigator.pop(context);
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     if (ApiProvider().isDebug == true) print(e.message.toString());
  //     if (e.message.toString() ==
  //         'insufficient funds for gas * price + value') {
  //       await customDialog('Opps', 'Insufficient funds for gas');
  //     } else {
  //       await customDialog('Opps', e.message.toString());
  //     }
  //   }
  // }

  Future<dynamic> sendTxErc(String contractAddr, String chainDecimal, String reciever, String amount) async {
    try {
      if (privateKey != null) {
        final String hash = await contract!.sendTxEthCon(
          contractAddr,
          chainDecimal,
          privateKey!,
          reciever,
          amount,
        );

        if (hash.isNotEmpty) {
          final status = await contract!.getEth.listenTransfer(hash);

          if (!status!) {
            Navigator.pop(context!);
            await customDialog('Transaction failed', 'Something went wrong with your transaction.');
          } else {
            enableAnimation!();
          }
          // await contract.getPending(hash).then((value) async {
          //   if (value == false) {
          //     // await Provider.of<ContractProvider>(context, listen: false)
          //     //     .getBscBalance();
          //     Navigator.pop(context);
          //     await customDialog('Transaction failed',
          //         'Something went wrong with your transaction.');
          //   } else {
          //     enableAnimation();
          //   }
          // });
          return hash;
        } else {
          Navigator.pop(context!);
          await customDialog('Opps', 'Something went wrong!');
        }
      }
    } catch (e) {
      Navigator.pop(context!);
      if (e.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Opps', e.toString());
      }
    }
  }

  Future<void> sendTxKmpi(String to, String amount) async {
    // dialogLoading(
    //   context,
    //   content: 'Please wait! This might be taking some time.',
    // );

    // try {
    //   final res = await ApiProvider.sdk.api.keyring.contractTransfer(
    //     ApiProvider.keyring.keyPairs[0].pubKey,
    //     to,
    //     amount,
    //     pin,
    //     Provider.of<ContractProvider>(context, listen: false).kmpi.hash,
    //   );

    //   if (res['status'] != null) {
    //     Provider.of<ContractProvider>(context, listen: false)
    //         .fetchKmpiBalance();

    //     await saveTxHistory(TxHistory(
    //       date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
    //       symbol: 'KMPI',
    //       destination: to,
    //       sender: ApiProvider.keyring.current.address,
    //       org: 'KOOMPI',
    //       amount: amount.trim(),
    //     ));

    //     await enableAnimation();
    //   }
    // } catch (e) {
    //   Navigator.pop(context);
    //   await customDialog('Opps', e.message.toString());
    // }
  }

  Future<String>? sendTx(String target, String amount, {BuildContext? context}) async {
    String? mhash;

    //final res = await validateAddress(target);

    final api = Provider.of<ApiProvider>(context!, listen: false);
    final contract = Provider.of<ContractProvider>(context, listen: false);

    final sender = TxSenderData(
      contract.listContract[api.selNativeIndex].address,
      api.getKeyring.current.pubKey,
    );

    final txInfo = TxInfoData('balances', 'transfer', sender);

    final chainDecimal = contract.listContract[api.selNativeIndex].chainDecimal;
    
    try {
      final Map hash = await api.getSdk.api.tx.signAndSend(
        txInfo,
        [
          target,
          Fmt.tokenInt(
            amount,
            chainDecimal!,
          ).toString(),
        ],
        pin!,
        onStatusChange: (status) async {}
      );

      if (hash.isNotEmpty) {
        // await saveTxHistory(TxHistory(
        //   date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
        //   symbol: 'SEL',
        //   destination: target,
        //   sender: ApiProvider.keyring.current.address,
        //   org: 'SELENDRA',
        //   amount: amount.trim(),
        // ));

        await enableAnimation!();
      } else {
        Navigator.pop(context);
        await customDialog('Opps', 'Something went wrong!');
      }
    } catch (e) {
      Navigator.pop(context);
      await customDialog('Opps', e.toString());
    }

    return mhash!;
  }

  Future<String>? sendTxDot(String target, String amount, {@required BuildContext? context}) async {
    String? mhash;
    final api = Provider.of<ApiProvider>(context!, listen: false);

    final sender = TxSenderData(
      api.getKeyring.current.address,
      api.getKeyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);

    final Map tx = txInfo.toJson();

    try {
      final Map hash = await api.signAndSendDot(
          tx, 
          jsonEncode([target, pow(double.parse(amount) * 10, 12)]), 
          pin,
          (status) async {}
        );

      if (hash.isNotEmpty) {
        await enableAnimation!();
      } else {
        Navigator.pop(context);
        await customDialog('Opps', 'Something went wrong!');
      }
    } catch (e) {
      Navigator.pop(context);

      await customDialog('Opps', e.toString());
    }

    return mhash!;
  }

  Future<bool> checkBalanceofCoin(String asset, String amount, int index) async {

    bool enough = true;
    try {

      final contract = Provider.of<ContractProvider>(context!, listen: false);

      if (double.parse(contract.sortListContract[index].balance!.replaceAll(",", "")) < double.parse(amount)) {
        enough = false;
      }

    } catch (e) {
      if (kDebugMode) {
        print("Error checkBalanceofCoin $e");
      }
    }
    return enough;
  }

  Future<bool> validateAddr(String asset, String address, {@required BuildContext? context, String? org} ) async {

    bool isValid = false;

    final apiPro = Provider.of<ApiProvider>(context!, listen: false);
    final conPro = Provider.of<ContractProvider>(context, listen: false);
    try {

      switch (asset) {

        case "SEL":
          bool res = false;
          
          if (org == 'BEP-20'){
            if (ApiProvider().isDebug == true) {
              if (kDebugMode) {
                print("Evm addr");
              }
            }
            res = await conPro.validateEvmAddr(address);
          }
          isValid = res;
          
          break;

        case "DOT":
          final res = await apiPro.validateAddress(address);
          isValid = res;
          break;

        default:
          final res = await conPro.validateEvmAddr(address);
          isValid = res;
          break;
      }

      return isValid;
    } catch (e) {
      
      if (kDebugMode) {
        print("Erorr validateAddr $e");
      }
      return isValid;
    }
  }

  Future<String>? getNetworkGasPrice(String asset, {String? network}) async {

    String? gasPrice;

    try {

      // if (asset == 'SEL (BEP-20)' || asset == 'SEL v2 (BEP-20)' || asset == 'KGO (BEP-20)' || asset == 'BNB') {
      // } else 
      if (network != null && network == "ERC-20"){
        final res = await ContractProvider().getErc20GasPrice();
        gasPrice = res!.getValueInUnit(EtherUnit.gwei).toString();
      } 
      else if (asset == 'ETH') {
        final res = await ContractProvider().getEthGasPrice();

        gasPrice = res!.getValueInUnit(EtherUnit.gwei).toString();
      } 
      else if (asset == 'BTC') {
        gasPrice = '88';
      } 
      else {
        final res = await ContractProvider().getBscGasPrice();
        gasPrice = res!.getValueInUnit(EtherUnit.gwei).toString();
      }
      // else if (asset == 'SEL') {
      //   final res = await ContractProvider().getSelGasPrice();
      //   _gasPrice = res.getValueInUnit(EtherUnit.gwei).toString();
      // }

    } catch (e){
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error getNetworkGasPrice $e");
        }
      }
    }

    return gasPrice!;
  }

  Future<dynamic>? estGasFeePrice(double? gasFee, String? asset, {int? assetIndex}) async {

    String? marketPrice;
    int? chainDecimal;

    try {

      api = Provider.of<ApiProvider>(context!, listen: false);
      final contract = Provider.of<ContractProvider>(context!, listen: false);

      await MarketProvider().fetchTokenMarketPrice(context!);
      switch (asset) {
        
        case 'BTC':
          marketPrice = contract.listContract[api!.btcIndex].marketData!.currentPrice!;
          break;
        case 'ETH':
          marketPrice = contract.listContract[api!.ethIndex].marketData!.currentPrice!;
          break;
        default:
          
          marketPrice = contract.sortListContract[assetIndex!].marketPrice;
          break;
      }
      
      marketPrice = (marketPrice == "0" || marketPrice == "") ? "1" : marketPrice!;
      chainDecimal = contract.sortListContract[assetIndex!].chainDecimal! == 0 ? 18 : contract.sortListContract[assetIndex].chainDecimal!;
      final estGasFeePrice = (gasFee! / pow(10, chainDecimal ) ) * double.parse(marketPrice);

      return estGasFeePrice;
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error estGasFeePrice $e");
        }
      }
    }
    return marketPrice!;
  }

  Future<List>? calPrice(String asset, String amount, {int? assetIndex}) async {

    String? marketPrice;
    String estPrice;

    final contract = Provider.of<ContractProvider>(context!, listen: false);
    
    // "0" For Contract That Has 0 Decimal
    marketPrice = contract.sortListContract[assetIndex!].marketPrice == "0" ? "1" : contract.sortListContract[assetIndex].marketPrice;
    marketPrice = marketPrice!.isEmpty ? "0" : marketPrice;
    estPrice = (double.parse(amount) * double.parse(marketPrice)).toStringAsFixed(2);

    return [estPrice, marketPrice]; //res.toStringAsFixed(2);
  }

  Future<String>? estMaxGas(BuildContext context, String asset, String reciever, String amount, int index, {String? network}) async {

    String? maxGas = '';
    final contractProvider = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);

    try {
      
      if (network != null && network == "ERC-20"){
        maxGas = await contractProvider.getErc20MaxGas(
          (api.isMainnet ? contractProvider.sortListContract[index].contract : contractProvider.sortListContract[index].contractTest)!, 
          reciever, 
          amount, 
          decimal: contractProvider.sortListContract[index].chainDecimal!
        );
      }
      else if (asset == 'ETH'){
        maxGas = await contractProvider.getEthMaxGas(reciever, amount);
      }
      else if ( asset == 'BNB'){
        maxGas = await contractProvider.getBnbMaxGas(reciever, amount);
      }
        
      else {
        maxGas = await contractProvider.getBep20MaxGas( 
          (api.isMainnet ? contractProvider.sortListContract[index].contract : contractProvider.sortListContract[index].contractTest)!, 
          reciever, 
          amount, 
          decimal: contractProvider.sortListContract[index].chainDecimal!
        );
      }

    } catch (e) {
      
      if (kDebugMode) {
        print("Error estMaxGas $e");
      }
    }
    return maxGas!;
  }
}