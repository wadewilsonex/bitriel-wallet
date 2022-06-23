import 'dart:async';
import 'dart:math';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/IContract.dart';
import 'package:web3dart/web3dart.dart';

class ContractService implements IContractService {
  
  final Web3Client _client;
  final DeployedContract _contract;

  ContractService(this._client, this._contract);

  ContractFunction _balanceFunction() => _contract.function('balanceOf');
  ContractFunction _sendFunction() => _contract.function('transfer');
  ContractFunction _symbolFunction() => _contract.function('symbol');
  ContractFunction _decimalFunction() => _contract.function('decimals');

  Future<List> _queryContract(DeployedContract contract, ContractFunction function, List args) async {
    try {

      final res = await _client.call(
        contract: contract,
        function: function,
        params: args,
      );
      return res;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error _queryContract $e");
    }
    return [];
  }

  @override
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return await EthPrivateKey.fromHex(privateKey);//_client.credentialsFromPrivateKey(privateKey);
  }

  @override
  Future<String> getTokenSymbol() async {
    final res = await _queryContract(_contract, _symbolFunction(), []);
    return res.first.toString();
  }

  @override
  Future<BigInt> getTokenBalance(EthereumAddress from) async {
    try {
      final res = await _queryContract(_contract, _balanceFunction(), [from]);
      print(res);
      return res.first as BigInt;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error getTokenBalance $e");
    }
    return 0 as BigInt;
  }

  @override
  Future<bool>? listenTransfer(String txHash) async {
    bool? std;

    await _client
        .addedBlocks()
        .asyncMap((_) async {
          try {
            // This Method Will Run Again And Again Until we return something
            await _client.getTransactionReceipt(txHash).then((d) {
              // Give Value To std When Request Successfully
              if (d != null) {
                std = d.status;

                //subscribeEvent.cancel();
              }
            });

            // Return Value For True Value And Method GetTrxReceipt Also Terminate
            if (std != null) return std;
          } on FormatException catch (e) {
            // This Error Because can't Convert Hexadecimal number to integer.
            // Note: Transaction is 100% successfully And It's just error becuase of Failure Parse that hexa
            // Example-Error: 0xc, 0x3a, ...
            // Example-Success: 0x1, 0x2, 0,3 ...

            // return True For Facing This FormatException
            if (e.message.toString() == 'Invalid radix-10 number') {
              std = true;
              return std!;
            }
          } catch (e) {
            if (ApiProvider().isDebug == true) print("Error $e");
          }
        })
        .where((receipt) => receipt != null)
        .first;

    return std!;

    // final addedBlock = await _client.addedBlocks();

    // // ignore: unused_local_variable
    // // ignore: cancel_subscriptions
    // subscribeEvent = addedBlock.listen((event) async {
    //   try {
    //     // This Method Will Run Again And Again Until we return something
    //     await _client.getTransactionReceipt(txHash).then((d) {
    //       // Give Value To std When Request Successfully
    //       if (d != null) {
    //         std = d.status;

    //         subscribeEvent.cancel();
    //       }
    //     });

    //     if (ApiProvider().isDebug == true) print('std in try $std');

    //     // Return Value For True Value And Method GetTrxReceipt Also Terminate
    //     if (std != null) return std;
    //   } on FormatException catch (e) {
    //     // This Error Because can't Convert Hexadecimal number to integer.
    //     // Note: Transaction is 100% successfully And It's just error becuase of Failure Parse that hexa
    //     // Example-Error: 0xc, 0x3a, ...
    //     // Example-Success: 0x1, 0x2, 0,3 ...

    //     // return True For Facing This FormatException
    //     if (e.message.toString() == 'Invalid radix-10 number') {
    //       std = true;
    //       return std;
    //     }
    //   } catch (e) {
    //     if (ApiProvider().isDebug == true) print("Error $e");
    //   }
    // });

    // if (ApiProvider().isDebug == true) print('mystd: $std');
    // return std;
  }

  @override
  Future<String>? sendToken(TransactionInfo trxInfo) async {
    String? res;
    try {

      final credentials = await getCredentials(trxInfo.privateKey!);
      print("credentials $credentials");
      final txInfo = TransactionInfo(receiver: trxInfo.receiver, amount: trxInfo.amount);
      print("txInfo ${txInfo}");

      final sender = await credentials.extractAddress();
      print("sender $sender");
      final maxGas = await getMaxGas(sender, txInfo);
      print("maxGas $maxGas");

      // final decimal = await getChainDecimal();

      res = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: _contract,
          maxGas: int.parse(trxInfo.maxGas!),
          function: _sendFunction(),
          parameters: [
            trxInfo.receiver,
            BigInt.from(double.parse(trxInfo.amount!) * pow(10, 18))
          ],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
      
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err sendToken $e");
      throw Exception(e);
    }

    return res;
  }

  @override
  Future<void> dispose() async {
    await _client.dispose();
  }

  @override
  Future<BigInt> getChainDecimal() async {
    try {
      
      final res = await _queryContract(_contract, _decimalFunction(), []);
      return res.first;
    } catch (e){
      print("err getChainDecimal $e");
    }
    return 0 as BigInt;
  }

  @override
  Future<BigInt> getMaxGas(EthereumAddress sender, TransactionInfo trxInfo) async {
    print("Sender $sender");
    print("_contract.address ${trxInfo.receiver}");
    print("BigInt.from(double.parse(trxInfo.amount!) * pow(10, 18)) ${BigInt.from(double.parse(trxInfo.amount!) * pow(10, 18))}");
    final maxGas = await _client.estimateGas(
      sender: sender,
      to: _contract.address,
      data: _sendFunction().encodeCall(
        [
          trxInfo.receiver,
          BigInt.from(double.parse(trxInfo.amount!) * pow(10, 18))
        ],
      ),
    );
    print("maxGas $maxGas");
    return maxGas;
  }

  static List<Map<String, dynamic>> getConSymbol(BuildContext context, List<SmartContractModel> ls){
    List<Map<String, dynamic>> tmp = [];

    if (ls.isNotEmpty){

      ApiProvider _api = Provider.of<ApiProvider>(context, listen: false);
      
      for (int i = 0; i < ls.length; i++){
        String org = _getOrg(i, _api, ls);
        tmp.add({
          "symbol": "${ls[i].symbol} ${ org != '' ? '($org)' : ''}",
          "index": i
        });
      }
    }

    return tmp;
  }

  static String _getOrg(int i, ApiProvider _api, List<SmartContractModel> ls) => (_api.isMainnet ? ls[i].org : ls[i].orgTest)!;
}
