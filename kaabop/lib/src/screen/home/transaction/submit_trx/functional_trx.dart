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
    if (privateKey != null) {
      final hash = await contract.sendTxBnb(privateKey, reciever, amount);

      if (hash != null) {
        await Provider.of<ContractProvider>(context, listen: false)
            .getBnbBalance();
        await enableAnimation();
      } else {
        throw hash;
      }
    } else {
      // Close Dialog
      Navigator.pop(context);
      await customDialog("Oops", "The PIN you entered is incorrect");
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
          enableAnimation();
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
          //  await Provider.of<ContractProvider>(context, listen: false).getBscBalance();

          enableAnimation();
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
          enableAnimation();
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

    try {
      final res = await ApiProvider.sdk.api.keyring.contractTransfer(
        ApiProvider.keyring.keyPairs[0].pubKey,
        to,
        amount,
        pin,
        Provider.of<ContractProvider>(context, listen: false).kmpi.hash,
      );

      if (res['status'] != null) {
        Provider.of<ContractProvider>(context, listen: false)
            .fetchKmpiBalance();

        await saveTxHistory(TxHistory(
          date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
          symbol: 'KMPI',
          destination: to,
          sender: ApiProvider.keyring.current.address,
          org: 'KOOMPI',
          amount: amount.trim(),
        ));

        await enableAnimation();
      }
    } catch (e) {
      Navigator.pop(context);
      await customDialog('Opps', e.message.toString());
    }
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
        Provider.of<ApiProvider>(context, listen: false).selNative.chainDecimal;
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

      print('myhash: $hash');
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
        print(api.selNative.balance);
        final withoutComma = api.selNative.balance.replaceAll(RegExp(','), '');
        if (double.parse(withoutComma) < double.parse(amount)) {
          print('not enough');
          _enough = false;
        }

        //if(api.selNative.balance < _scanPayM.controlAmount.text)
        break;
      case "DOT":
        print(api.dot.balance);
        final withoutComma = api.dot.balance.replaceAll(RegExp(','), '');
        if (double.parse(withoutComma) < double.parse(amount)) {
          print('not enough');
          _enough = false;
        }

        break;
      case "BTC":
        print(api.btc.balance);
        if (double.parse(api.btc.balance) < double.parse(amount)) {
          print('not enough');
          _enough = false;
        }

        break;
      case "SEL (BEP-20)":
        print(contract.selBsc.balance);
        if (double.parse(contract.selBsc.balance) < double.parse(amount)) {
          print('not enough');
          _enough = false;
        }

        break;
      case "SEL v2 (BEP-20)":
        print(contract.selBscV2.balance);
        if (double.parse(contract.selBscV2.balance) < double.parse(amount)) {
          print('not enough');
          _enough = false;
        }

        break;
      case "KGO (BEP-20)":
        print(contract.kgoBsc.balance);
        if (double.parse(contract.kgoBsc.balance) < double.parse(amount)) {
          print('not enough');
          _enough = false;
        }

        break;
      case "BNB":
        print(contract.bnbSmartChain.balance);
        if (double.parse(contract.bnbSmartChain.balance) <
            double.parse(amount)) {
          print('not enough');
          _enough = false;
        }

        break;
      case "ETH":
        print(contract.etherNative.balance);
        if (double.parse(contract.etherNative.balance) < double.parse(amount)) {
          print('not enough');
          _enough = false;
        }

        break;

      default:
        if (asset.contains('ERC-20')) {
          final contractAddr = ContractProvider().findContractAddr(asset);
          final balance = await ContractProvider()
              .queryEther(contractAddr, 'balanceOf', []);
          print(balance.first);
          if (double.parse(balance.first) < double.parse(amount)) {
            print('not enough');
            _enough = false;
          }
        } else {
          final contractAddr = ContractProvider().findContractAddr(asset);
          final balance =
              await ContractProvider().query(contractAddr, 'balanceOf', []);
          print(balance);

          if (double.parse(balance.first) < double.parse(amount)) {
            print('not enough');
            _enough = false;
          }
        }

        break;
    }
    return _enough;
  }

  Future<bool> validateAddr(String asset, String address) async {
    bool _isValid = false;
    print('va;idate address');
    switch (asset) {
      case "SEL":
        final res = await ApiProvider.sdk.api.keyring.validateAddress(address);
        _isValid = res;

        // if (res) {
        //   _isValid = res;
        // } else {
        //   final res = await ContractProvider().validateEvmAddr(address);
        //   _isValid = res;
        // }
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
      print('Fee $res');

      _gasPrice = res.getValueInUnit(EtherUnit.gwei).toString();
    } else if (asset == 'ETH') {
      final res = await ContractProvider().getEthGasPrice();

      print('ethergasprice $res');
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
        marketPrice = contract.etherNative.marketData.currentPrice;
        break;
      // case 'SEL':
      //   marketPrice = null;
      //   break;
      default:
        marketPrice = contract.bnbSmartChain.marketData.currentPrice;
        break;
    }

    final estGasFeePrice = (gasFee / pow(10, 9)) * double.parse(marketPrice);

    print('gasfeeprice: $estGasFeePrice');

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
      case 'ETH':
        marketPrice = contract.etherNative.marketData.currentPrice;
        break;
      case 'KGO (BEP-20)':
        marketPrice = contract.kgoBsc.marketData.currentPrice;
        break;
      case 'BNB':
        marketPrice = contract.bnbSmartChain.marketData.currentPrice;
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
    print(marketPrice);
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
        maxGas =
            await contract.getBep20MaxGas(AppConfig.oSEL, reciever, amount);
        break;
      case 'SEL v2 (BEP-20)':
        maxGas = await contract.getBep20MaxGas(
            AppConfig.selv2MainnetAddr, reciever, amount);
        break;
      case 'KGO (BEP-20)':
        maxGas =
            await contract.getBep20MaxGas(AppConfig.kgoAddr, reciever, amount);
        break;
      case 'BNB':
        maxGas = await contract.getBnbMaxGas(reciever, amount);
        break;
    }
    return maxGas;
  }
}
