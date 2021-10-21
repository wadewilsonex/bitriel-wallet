import 'dart:math';

import 'package:intl/intl.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

class TrxFunctional {
  ApiProvider api;

  String pin;

  String encryptKey;

  String privateKey;

  ContractProvider contract;

  final BuildContext context;

  final Function enableAnimation;

  final Function validateAddress;

  TrxFunctional.init(
      {this.context, this.enableAnimation, this.validateAddress});

  /*  ---------------Message-------------- */
  Future<void> customDialog(String text1, String text2) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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

  Future<String> getBtcPrivateKey(String pin) async {
    // String privateKey;

    try {
      privateKey =
          await ApiProvider.keyring.store.decryptPrivateKey(encryptKey, pin);
    } catch (e) {
      // Navigator.pop(context);
      // print('1');
      // await customDialog('Opps', 'PIN verification failed');
    }

    return privateKey;
  }

  Future<String> getPrivateKey(String pin) async {
    try {
      privateKey =
          await ApiProvider.keyring.store.decryptPrivateKey(encryptKey, pin);
    } catch (e) {
      // Navigator.pop(context);
      // print('2');
      // await customDialog('Opps', 'PIN verification failed');
    }

    return privateKey;
  }

  Future<void> saveTxHistory(TxHistory txHistory) async {
    await StorageServices.addTxHistory(txHistory, 'txhistory');
  }

  /* ------------------Transaction--------------- */

  Future<void> sendTxBnb(String reciever, String amount) async {
    try {
      if (privateKey != null) {
        final hash = await contract.sendTxBnb(privateKey, reciever, amount);

        if (hash != null) {
          await contract
              .getPending(hash, nodeClient: contract.bscClient)
              .then((value) async {
            if (value == false) {
              await Provider.of<ContractProvider>(context, listen: false)
                  .getBscBalance();
              Navigator.pop(context);
              await customDialog('Transaction failed',
                  'Something went wrong with your transaction.');
            } else {
              enableAnimation();
            }
          });
        } else {
          throw hash;
        }
      } else {
        // Close Dialog
        Navigator.pop(context);
        await customDialog("Oops", "The PIN you entered is incorrect");
      }
    } catch (e) {
      print("sendTxBnb $e");
    }
  }

  Future<void> sendTxBtc(String to, String amount) async {
    final resAdd = await api.validateBtcAddr(to);

    if (resAdd) {
      final res = await api.sendTxBtc(
          context, api.btcAdd, to, double.parse(amount), privateKey);
      if (res == 200) {
        enableAnimation();
      } else {
        Navigator.pop(context);
        await customDialog('Opps', 'Something went wrong!');
      }
    } else {
      Navigator.pop(context);
      await customDialog('Opps', 'Invalid Address');
    }
  }

  Future<void> sendTxEther(String reciever, String amount) async {
    try {
      if (privateKey != null) {
        final hash = await contract.sendTxEther(privateKey, reciever, amount);
        if (hash != null) {
          await contract.getEthPending(hash).then((value) async {
            if (value == false) {
              Navigator.pop(context);
              await customDialog('Transaction failed',
                  'Something went wrong with your transaction.');
            } else {
              enableAnimation();
            }
          });
        } else {
          Navigator.pop(context);
          await customDialog('Opps', 'Something went wrong!');
        }
      }
    } catch (e) {
      Navigator.pop(context);
      if (e.message.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Opps', e.message.toString());
      }
    }
  }

  Future<void> sendTxBsc(String contractAddr, String chainDecimal,
      String reciever, String amount) async {
    try {
      if (privateKey != null) {
        final hash = await contract.sendTxBsc(
          contractAddr,
          chainDecimal,
          privateKey,
          reciever,
          amount,
        );

        if (hash != null) {
          await contract
              .getPending(hash, nodeClient: contract.bscClient)
              .then((value) async {
            if (value == false) {
              await Provider.of<ContractProvider>(context, listen: false)
                  .getBscBalance();
              Navigator.pop(context);
              await customDialog(
                  'Transaction failed', 'insufficient funds for gas');
            } else {
              enableAnimation();
            }
          });
        } else {
          Navigator.pop(context);
          await customDialog('Opps', 'Something went wrong!');
        }
      }
      // Res equal NULL
      else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
      print(e.message.toString());
      if (e.message.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Opps', e.message.toString());
      }
    }
  }

  Future<void> sendTxErc(String contractAddr, String chainDecimal,
      String reciever, String amount) async {
    try {
      if (privateKey != null) {
        final hash = await contract.sendTxEthCon(
          contractAddr,
          chainDecimal,
          privateKey,
          reciever,
          amount,
        );

        if (hash != null) {
          await contract.getEthPending(hash).then((value) async {
            if (value == false) {
              await Provider.of<ContractProvider>(context, listen: false)
                  .getBscBalance();
              Navigator.pop(context);
              await customDialog('Transaction failed',
                  'Something went wrong with your transaction.');
            } else {
              enableAnimation();
            }
          });
        } else {
          Navigator.pop(context);
          await customDialog('Opps', 'Something went wrong!');
        }
      }
    } catch (e) {
      Navigator.pop(context);
      if (e.message.toString() ==
          'insufficient funds for gas * price + value') {
        await customDialog('Opps', 'Insufficient funds for gas');
      } else {
        await customDialog('Opps', e.message.toString());
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

  Future<String> sendTx(String target, String amount) async {
    String mhash;

    //final res = await validateAddress(target);

    final sender = TxSenderData(
      ApiProvider.keyring.current.address,
      ApiProvider.keyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);

    final chainDecimal =
        Provider.of<ApiProvider>(context, listen: false).nativeM.chainDecimal;
    try {
      final hash = await ApiProvider.sdk.api.tx.signAndSend(
          txInfo,
          [
            target,
            Fmt.tokenInt(
              amount.trim(),
              int.parse(chainDecimal),
            ).toString(),
          ],
          pin,
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

        await enableAnimation();
      } else {
        Navigator.pop(context);
        await customDialog('Opps', 'Something went wrong!');
      }
    } catch (e) {
      Navigator.pop(context);

      print(e.message.toString());
      await customDialog('Opps', e.message.toString());
    }

    return mhash;
  }

  Future<String> sendTxDot(String target, String amount) async {
    String mhash;

    final sender = TxSenderData(
      ApiProvider.keyring.current.address,
      ApiProvider.keyring.current.pubKey,
    );
    final txInfo = TxInfoData('balances', 'transfer', sender);

    try {
      final hash = await ApiProvider.sdk.api.tx.signAndSendDot(
          txInfo, [target, pow(double.parse(amount) * 10, 12)], pin,
          onStatusChange: (status) async {});

      if (hash != null) {
        await enableAnimation();
      } else {
        Navigator.pop(context);
        await customDialog('Opps', 'Something went wrong!');
      }
    } catch (e) {
      Navigator.pop(context);

      await customDialog('Opps', e.message.toString());
    }

    return mhash;
  }

  Future<bool> checkBalanceofCoin(String asset, String amount) async {
    bool _enough = true;
    final api = Provider.of<ApiProvider>(context, listen: false);
    final contract = Provider.of<ContractProvider>(context, listen: false);
    switch (asset) {
      case "SEL":
        final withoutComma = api.nativeM.balance.replaceAll(RegExp(','), '');
        if (double.parse(withoutComma) < double.parse(amount)) {
          _enough = false;
        }
        break;
      case "DOT":
        final withoutComma = api.dot.balance.replaceAll(RegExp(','), '');
        if (double.parse(withoutComma) < double.parse(amount)) {
          _enough = false;
        }

        break;
      case "BTC":
        if (double.parse(api.btc.balance) < double.parse(amount)) {
          _enough = false;
        }

        break;
      case "SEL (BEP-20)":
        if (double.parse(contract.listContract[0].balance) <
            double.parse(amount)) {
          _enough = false;
        }

        break;
      case "SEL v2 (BEP-20)":
        if (double.parse(contract.listContract[1].balance) <
            double.parse(amount)) {
          _enough = false;
        }

        break;
      case "KGO (BEP-20)":
        if (double.parse(contract.listContract[2].balance) <
            double.parse(amount)) {
          _enough = false;
        }

        break;
      case "BNB":
        if (double.parse(contract.listContract[4].balance) <
            double.parse(amount)) {
          _enough = false;
        }

        break;
      case "ETH":
        if (double.parse(contract.listContract[3].balance) <
            double.parse(amount)) {
          _enough = false;
        }

        break;

      default:
        if (asset.contains('ERC-20')) {
          final contractAddr = ContractProvider().findContractAddr(asset);
          final balance = await ContractProvider()
              .queryEther(contractAddr, 'balanceOf', []);

          if (double.parse(balance.first) < double.parse(amount)) {
            _enough = false;
          }
        } else {
          final contractAddr = ContractProvider().findContractAddr(asset);
          final balance =
              await ContractProvider().query(contractAddr, 'balanceOf', []);

          if (double.parse(balance.first) < double.parse(amount)) {
            _enough = false;
          }
        }

        break;
    }
    return _enough;
  }

  Future<bool> validateAddr(String asset, String address) async {
    bool _isValid = false;

    switch (asset) {
      case "SEL":
        final res = await ApiProvider.sdk.api.keyring.validateAddress(address);
        _isValid = res;

        break;
      case "DOT":
        final res = await ApiProvider.sdk.api.keyring.validateAddress(address);
        _isValid = res;
        break;
      case "BTC":
        final res = await ApiProvider().validateBtcAddr(address);
        _isValid = res;
        break;

      default:
        final res = await ContractProvider().validateEvmAddr(address);
        _isValid = res;
        break;
    }

    return _isValid;
  }

  Future<String> getNetworkGasPrice(String asset) async {
    String _gasPrice;
    if (asset == 'SEL (BEP-20)' ||
        asset == 'SEL v2 (BEP-20)' ||
        asset == 'KGO (BEP-20)' ||
        asset == 'BNB') {
      final res = await ContractProvider().getBscGasPrice();

      _gasPrice = res.getValueInUnit(EtherUnit.gwei).toString();
    } else if (asset == 'ETH') {
      final res = await ContractProvider().getEthGasPrice();

      _gasPrice = res.getValueInUnit(EtherUnit.gwei).toString();
    } else if (asset == 'BTC') {
      _gasPrice = '88';
    }
    // else if (asset == 'SEL') {
    //   final res = await ContractProvider().getSelGasPrice();
    //   _gasPrice = res.getValueInUnit(EtherUnit.gwei).toString();
    // }

    return _gasPrice;
  }

  Future<double> estGasFeePrice(double gasFee, String asset) async {
    String marketPrice;

    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);

    await MarketProvider().fetchTokenMarketPrice(context);

    switch (asset) {
      case 'BTC':
        marketPrice = api.btc.marketData.currentPrice;
        break;
      case 'ETH':
        marketPrice = contract.listContract[3].marketData.currentPrice;
        break;
      // case 'SEL':
      //   marketPrice = null;
      //   break;
      default:
        marketPrice = contract.listContract[4].marketData.currentPrice;
        break;
    }

    final estGasFeePrice = (gasFee / pow(10, 9)) * double.parse(marketPrice);

    return estGasFeePrice;
  }

  Future<List> calPrice(String asset, String amount) async {
    String marketPrice;
    var estPrice;

    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);

    await MarketProvider().fetchTokenMarketPrice(context);

    switch (asset) {
      case 'BTC':
        marketPrice = api.btc.marketData.currentPrice;
        break;
      case 'KGO (BEP-20)':
        marketPrice = contract.listContract[2].marketData.currentPrice;
        break;
      case 'ETH':
        marketPrice = contract.listContract[3].marketData.currentPrice;
        break;
      case 'BNB':
        marketPrice = contract.listContract[4].marketData.currentPrice;
        break;
      case 'DOT':
        marketPrice = api.dot.marketData.currentPrice;
        break;
      default:
        estPrice = '\$0.00';
        break;
    }

    //print(contract.)

    if (marketPrice != null)
      estPrice =
          (double.parse(amount) * double.parse(marketPrice)).toStringAsFixed(2);

    return [estPrice, marketPrice ?? '0']; //res.toStringAsFixed(2);
  }

  Future<String> estMaxGas(String asset, String reciever, String amount) async {
    String maxGas;
    final contract = ContractProvider();
    final api = ApiProvider();

    switch (asset) {
      case 'BTC':
        maxGas = await api.calBtcMaxGas();
        break;
      case 'ETH':
        maxGas = await contract.getEthMaxGas(reciever, amount);
        break;
      case 'SEL (BEP-20)':
        maxGas = await contract.getBep20MaxGas(
            contract.listContract[0].address, reciever, amount);
        break;
      case 'SEL v2 (BEP-20)':
        maxGas = await contract.getBep20MaxGas(
            contract.listContract[1].address, reciever, amount);
        break;
      case 'KGO (BEP-20)':
        maxGas = await contract.getBep20MaxGas(
            contract.listContract[2].address, reciever, amount);
        break;
      case 'BNB':
        maxGas = await contract.getBnbMaxGas(reciever, amount);
        break;
    }
    return maxGas;
  }
}
