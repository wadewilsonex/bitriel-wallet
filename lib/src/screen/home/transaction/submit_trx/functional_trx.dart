import 'dart:math';

import 'package:intl/intl.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/service/contract.dart';
import 'package:wallet_apps/src/service/native.dart';
import 'package:web3dart/web3dart.dart';

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: MyText(
              text: text1,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(
              text2,
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
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

  Future<String>? getBtcPrivateKey(String pin, {@required BuildContext? context}) async {
    // String privateKey;

    try {
      privateKey = await Provider.of<ApiProvider>(context!, listen: false).decryptPrivateKey(encryptKey!, pin);
    } catch (e) {
      // Navigator.pop(context);
      // print('1');
      // await customDialog('Opps', 'PIN verification failed');
    }

    return privateKey!;
  }

  Future<String>? getPrivateKey(String pin, {@required BuildContext? context}) async {
    try {
      privateKey = await Provider.of<ApiProvider>(context!, listen: false).decryptPrivateKey(encryptKey!, pin);
    } catch (e) {
      // Navigator.pop(context);
      // print('2');
      // await customDialog('Opps', 'PIN verification failed');
    }

    return privateKey!;
  }

  Future<void> saveTxHistory(TxHistory txHistory) async {
    await StorageServices.addTxHistory(txHistory, 'txhistory');
  }

  /* ------------------Transaction--------------- */

  Future<void> sendTxBnb(String reciever, String amount) async {
    try{
      if (privateKey != null) {

        final hash = await contract!.getBnb.sendTx(
          TransactionInfo(
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
      print("err sendTxBnb $e");
    }
  }

  Future<void> sendTxBtc(String to, String amount) async {
    final resAdd = await api!.validateBtcAddr(to);

    if (resAdd) {
      final res = await api!.sendTxBtc(
          context!, api!.btcAdd, to, double.parse(amount), privateKey!);
      if (res == 200) {
        enableAnimation!();
      } else {
        Navigator.pop(context!);
        await customDialog('Opps', 'Something went wrong!');
      }
    } else {
      Navigator.pop(context!);
      await customDialog('Opps', 'Invalid Address');
    }
  }

  Future<void> sendTxEther(String reciever, String amount) async {
    try {
      if (privateKey != null) {
        final txInfo = TransactionInfo(
            privateKey: privateKey,
            receiver: contract!.getEthAddr(reciever),
            amount: amount);
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

  Future<void> sendTxEvm(NativeService coinService, TransactionInfo txInfo) async {
    if (txInfo.privateKey != null) {
      try {
        final hash = await coinService.sendTx(txInfo);

        if (hash != null) {
          txInfo.hash = hash;
          txInfo.timeStamp = DateFormat('yyyy-MM-dd HH:mm:ss a').format(DateTime.now());
          await navigateAssetInfo(txInfo, nativeService: coinService);
        }
      } catch (e) {
        print('Err sendTxEvm $e');
        if (e.toString() == 'insufficient funds for gas * price + value') {
          await customDialog('Opps', 'Insufficient funds for gas');
        } else {
          await customDialog('Opps', e.toString());
        }
      }
    }
  }

  Future<void> sendTxBep20(ContractService tokenService, TransactionInfo txInfo) async {

    try {

      if (txInfo.privateKey != null) {
        try {
          final hash = await tokenService.sendToken(txInfo);

          if (hash != null) {
            txInfo.hash = hash;
            txInfo.scanUrl = AppConfig.networkList[3].scanMn! + txInfo.hash!;
            txInfo.timeStamp = DateFormat('yyyy-MM-dd HH:mm:ss a').format(DateTime.now());

            await navigateAssetInfo(txInfo, tokenService: tokenService);
          }
        } catch (e) {
          // Navigator.pop(context);
          print('Error sendTxBep20 $e');
          if (e.toString() == 'insufficient funds for gas * price + value') {
            await customDialog('Opps', 'Insufficient funds for gas');
          } else {
            await customDialog('Opps', e.toString());
          }
        }
      }
    } catch (e) {
      print("Error sendTxBep20 $e");
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
      print("Err navigateAssetInfo $e");
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
  //     print(e.message.toString());
  //     if (e.message.toString() ==
  //         'insufficient funds for gas * price + value') {
  //       await customDialog('Opps', 'Insufficient funds for gas');
  //     } else {
  //       await customDialog('Opps', e.message.toString());
  //     }
  //   }
  // }

  Future<void> sendTxErc(String contractAddr, String chainDecimal,
      String reciever, String amount) async {
    try {
      if (privateKey != null) {
        final String? hash = await contract!.sendTxEthCon(
          contractAddr,
          chainDecimal,
          privateKey!,
          reciever,
          amount,
        );

        if (hash != null) {
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

    final _api = Provider.of<ApiProvider>(context!, listen: false);

    final sender = TxSenderData(
      _api.getKeyring.current.address,
      _api.getKeyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);

    final chainDecimal =
        Provider.of<ApiProvider>(context, listen: false).nativeM.chainDecimal;
    try {
      final Map? hash = await _api.getSdk.api.tx.signAndSend(
          txInfo,
          [
            target,
            Fmt.tokenInt(
              amount.trim(),
              int.parse(chainDecimal!),
            ).toString(),
          ],
          pin!,
          onStatusChange: (status) async {});

      if (hash != null) {
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
    final _api = Provider.of<ApiProvider>(context!, listen: false);

    final sender = TxSenderData(
      _api.getKeyring.current.address,
      _api.getKeyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);

    final Map tx = txInfo.toJson();

    try {
      final Map? hash = await _api.signAndSendDot(
          tx, 
          jsonEncode([target, pow(double.parse(amount) * 10, 12)]), 
          pin,
          (status) async {}
        );

      if (hash != null) {
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

    bool _enough = true;
    try {
      final contract = Provider.of<ContractProvider>(context!, listen: false);
      // switch (asset) {
      //   case "SEL":
      //     final withoutComma = api.nativeM.balance.replaceAll(RegExp(','), '');
      //     if (double.parse(withoutComma) < double.parse(amount)) {
      //       _enough = false;
      //     }
      //     break;
      //   case "DOT":
      //     final withoutComma = contract.listContract[5].balance.replaceAll(RegExp(','), '');
      //     if (double.parse(withoutComma) < double.parse(amount)) {
      //       _enough = false;
      //     }

      //     break;
      //   case "BTC":
      //     if (double.parse(contract.listContract[6].balance) < double.parse(amount)) {
      //       _enough = false;
      //     }

      //     break;
      //   case "SEL (BEP-20)":
      //     if (double.parse(contract.listContract[0].balance) <
      //         double.parse(amount)) {
      //       _enough = false;
      //     }

      //     break;
      //   case "SEL v2 (BEP-20)":
      //     if (double.parse(contract.listContract[1].balance) <
      //         double.parse(amount)) {
      //       _enough = false;
      //     }

      //     break;
      //   case "KGO (BEP-20)":
      //     if (double.parse(contract.listContract[2].balance) <
      //         double.parse(amount)) {
      //       _enough = false;
      //     }

      //     break;
      //   case "ETH":
      //     if (double.parse(contract.listContract[3].balance) <
      //         double.parse(amount)) {
      //       _enough = false;
      //     }

      //     break;

      //   case "BNB":
      //     if (double.parse(contract.listContract[4].balance) < double.parse(amount)) {
      //       _enough = false;
      //     }

      //     break;

      //   default:
      //     if (asset.contains('ERC-20')) {
      //       final contractAddr = ContractProvider().findContractAddr(asset);
      //       final balance = await ContractProvider().queryEther(contractAddr, 'balanceOf', []);

      //       if (double.parse(balance.first) < double.parse(amount)) {
      //         _enough = false;
      //       }
      //     } else {

      //       print("BEP-20 ${contract.sortListContract[index].address}");
      //       // final contractAddr = ContractProvider().findContractAddr(asset);
      //       // print("Found $contractAddr");
      //       dynamic balance = await ContractProvider().query(contract.sortListContract[index].address, 'balanceOf', [EthereumAddress.fromHex(contract.ethAdd)]);
            
      //       print("Balance $balance");
      //       print(contract.sortListContract[index].chainDecimal.toString());
      //       balance = Fmt.bigIntToDouble(
      //         balance[0] as BigInt,
      //         int.parse(contract.sortListContract[index].chainDecimal.toString()),
      //       ).toString();

      //       print("After Balance $balance");
      //       if (double.parse(balance) < double.parse(amount)) {
      //         _enough = false;
      //       }
      //     }

      //     break;
      // }
      if (double.parse(contract.sortListContract[index].balance!) < double.parse(amount)) {
        _enough = false;
      }
    } catch (e) {
      print("Error checkBalanceofCoin $e");
    }
    return _enough;
  }

  Future<bool> validateAddr(String asset, String address, {@required BuildContext? context, String? org} ) async {

    bool _isValid = false;

    final apiPro = Provider.of<ApiProvider>(context!, listen: false);
    final conPro = Provider.of<ContractProvider>(context, listen: false);
    try {

      switch (asset) {
        case "SEL":
          bool res = false;
          if (org == 'BEP-20'){
            res = await conPro.validateEvmAddr(address);
          } else {
            res = await apiPro.validateAddress(address);
          }
          _isValid = res;

          break;
        case "DOT":
          final res = await apiPro.validateAddress(address);
          _isValid = res;
          break;
        case "BTC":
          final res = await apiPro.validateBtcAddr(address);
          _isValid = res;
          break;

        default:
          final res = await conPro.validateEvmAddr(address);
          _isValid = res;
          break;
      }

      return _isValid;
    } catch (e) {
      print("Erorr validateAddr $e");
      return _isValid;
    }
  }

  Future<String>? getNetworkGasPrice(String asset) async {

    String? _gasPrice;

    try {

      // if (asset == 'SEL (BEP-20)' || asset == 'SEL v2 (BEP-20)' || asset == 'KGO (BEP-20)' || asset == 'BNB') {
      // } else 
      if (asset == 'ETH') {
        final res = await ContractProvider().getEthGasPrice();

        _gasPrice = res.getValueInUnit(EtherUnit.gwei).toString();
      } else if (asset == 'BTC') {
        _gasPrice = '88';
      } else {

        final res = await ContractProvider().getBscGasPrice();

        _gasPrice = res!.getValueInUnit(EtherUnit.gwei).toString();
      }
      // else if (asset == 'SEL') {
      //   final res = await ContractProvider().getSelGasPrice();
      //   _gasPrice = res.getValueInUnit(EtherUnit.gwei).toString();
      // }

    } catch (e){
      print("Error getNetworkGasPrice $e");
    }

    return _gasPrice!;
  }

  Future<dynamic>? estGasFeePrice(double gasFee, String asset) async {

    String? marketPrice;
    try {


      final contract = Provider.of<ContractProvider>(context!, listen: false);

      await MarketProvider().fetchTokenMarketPrice(context!);

      switch (asset) {
        
        case 'BTC':
          marketPrice = contract.listContract[6].marketData!.currentPrice!;
          break;
        case 'ETH':
          marketPrice = contract.listContract[3].marketData!.currentPrice!;
          break;
        // case 'SEL':
        //   marketPrice = null;
        //   break;
        default:
          marketPrice = contract.listContract[4].marketData!.currentPrice!;
          break;
      }

      final estGasFeePrice = (gasFee / pow(10, 9)) * double.parse(marketPrice);

      return estGasFeePrice;
    } catch (e) {
      print("Error estGasFeePrice $e");
    }
    return marketPrice!;
  }

  Future<List>? calPrice(String asset, String amount) async {
    String? marketPrice;
    var estPrice;

    final contract = Provider.of<ContractProvider>(context!, listen: false);

    await MarketProvider().fetchTokenMarketPrice(context!);

    switch (asset) {
      
      case 'KGO (BEP-20)':
        marketPrice = contract.listContract[2].marketData!.currentPrice!;
        break;
      case 'ETH':
        marketPrice = contract.listContract[3].marketData!.currentPrice!;
        break;
      case 'BNB':
        marketPrice = contract.listContract[4].marketData!.currentPrice!;
        break;
      case 'DOT':
        marketPrice = contract.listContract[5].marketData!.currentPrice!;
        break;
      case 'BTC':
        marketPrice = contract.listContract[6].marketData!.currentPrice!;
        break;
      default:
        estPrice = '\$0.00';
        break;
    }

    if (marketPrice != null)
      estPrice = (double.parse(amount) * double.parse(marketPrice)).toStringAsFixed(2);

    return [estPrice, marketPrice ?? '0']; //res.toStringAsFixed(2);
  }

  Future<String>? estMaxGas(BuildContext context, String asset, String reciever, String amount, int index) async {


    String? maxGas;
    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = ApiProvider();
    
    try {

      switch (asset) {
        case 'BTC':
          maxGas = await api.calBtcMaxGas();
          break;
        case 'ETH':
          maxGas = await contract.getEthMaxGas(reciever, amount);
          break;
        case 'SEL (BEP-20)':

          //  final contract = await AppUtils.contractfromAssets(
          //   AppConfig.bep20Path, '0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030');
          // maxGas = await contract.getBep20MaxGas(
          //     contract.listContract[0].address, reciever, amount);

          maxGas = await contract.getBep20MaxGas('0xa7f2421fa3d3f31dbf34af7580a1e3d56bcd3030', reciever, amount);

          break;
        case 'SEL v2 (BEP-20)':
          maxGas = await contract.getBep20MaxGas(contract.listContract[1].address!, reciever, amount);
          break;
        case 'KGO (BEP-20)':
          maxGas = await contract.getBep20MaxGas(contract.listContract[2].address!, reciever, amount);
          break;
        case 'BNB':
          maxGas = await contract.getBnbMaxGas(reciever, amount);
          break;
        default:
          maxGas = await contract.getBep20MaxGas(contract.sortListContract[index].address!, reciever, amount);
          break;
      }
    } catch (e) {
      print("Error estMaxGas $e");
    }
    return maxGas!;
  }
}
