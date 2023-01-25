import 'dart:math';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/icontract.dart';

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

      if (kDebugMode) {
        print("Error _queryContract $e");
      }
    }
    return [];
  }

  @override
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return EthPrivateKey.fromHex(privateKey);//_client.credentialsFromPrivateKey(privateKey);
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
      return res.first as BigInt;
    } catch (e) {
      
      if (kDebugMode) {
        print("Error getTokenBalance $e");
      }
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
            
            if (kDebugMode) {
              print("Error $e");
            }
          }
        })
        .where((receipt) => receipt != null)
        .first;

    return std!;
  }

  @override
  Future<String>? sendToken(TransactionInfo trxInfo) async {
    String? res;
    try {

      final credentials = await getCredentials(trxInfo.privateKey!);
      final txInfo = TransactionInfo(receiver: trxInfo.receiver, amount: trxInfo.amount, chainDecimal: trxInfo.chainDecimal);
      final sender = await credentials.extractAddress();
      final maxGas = await getMaxGas(sender, txInfo);

      res = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: _contract,
          maxGas: maxGas.toInt(),
          function: _sendFunction(),
          parameters: [
            trxInfo.receiver,
            BigInt.from(double.parse(trxInfo.amount!) * pow(10, trxInfo.chainDecimal!))
          ],
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
      
    } catch (e) {
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Err sendToken $e");
        }
      }
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
      if (ApiProvider().isDebug) {
        if (kDebugMode) {
          print("err getChainDecimal $e");
        }
      }
    }
    return 0 as BigInt;
  }

  @override
  Future<BigInt> getMaxGas(EthereumAddress sender, TransactionInfo trxInfo) async {
    final maxGas = await _client.estimateGas(
      sender: sender,
      to: _contract.address,
      data: _sendFunction().encodeCall(
        [
          trxInfo.receiver,
          BigInt.from(double.parse(trxInfo.amount!) * pow(10, trxInfo.chainDecimal!))
        ],
      ),
    );
    return maxGas;
  }

  static List<Map<String, dynamic>> getConSymbol(BuildContext context, List<SmartContractModel> ls){
    List<Map<String, dynamic>> tmp = [];

    if (ls.isNotEmpty){
      
      for (int i = 0; i < ls.length; i++){
        String org = _getOrg(i, ls);
        tmp.add({
          "symbol": "${ls[i].symbol}${ org != '' ? ' ($org)' : ''}",
          "index": i
        });
      }
    }

    return tmp;
  }

  static String _getOrg(int i, List<SmartContractModel> ls) => (ApiProvider().isMainnet ? ls[i].org : ls[i].orgTest)!;
}
