import 'dart:async';
import 'dart:math';

import 'package:wallet_apps/src/models/INative.dart';
import 'package:web3dart/credentials.dart';
import 'package:wallet_apps/src/models/trx_info.dart';
import 'package:web3dart/web3dart.dart';

class NativeService implements INativeService {
  final Web3Client _client;

  NativeService(this._client);
  @override
  Future<void> dispose() async {
    await _client.dispose();
  }

  @override
  Future<num> getBalance(EthereumAddress from) async {
    final balance = await _client.getBalance(from);

    return balance.getValueInUnit(EtherUnit.ether);
  }

  @override
  Future<Credentials> getCredentials(String privateKey) {
    return _client.credentialsFromPrivateKey(privateKey.substring(2));
  }

  @override
  Future<bool> listenTransfer(String txHash) async {
    bool std;
    StreamSubscription subscribeEvent;

    print('myhash $txHash');

    // ignore: unused_local_variable
    // ignore: cancel_subscriptions
    await _client
        .addedBlocks()
        .asyncMap((_) async {
          try {
            // This Method Will Run Again And Again Until we return something
            await _client.getTransactionReceipt(txHash).then((d) {
              print('my stt ${d.status}');
              // Give Value To std When Request Successfully
              if (d != null) {
                std = d.status;

                print('my status $std ');
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
              return std;
            }
          } catch (e) {
            print("Error $e");
          }
        })
        .where((receipt) => receipt != null)
        .first;

    return std;
  }

  @override
  Future<String> sendTx(TransactionInfo trxInfo) async {
    print('sendTx');
    final credentials = await getCredentials(trxInfo.privateKey);

    final sender = await credentials.extractAddress();

    print('sender $sender');

    final maxGas = await getMaxGas(sender, trxInfo);

    print('mG $maxGas');

    final res = await _client.sendTransaction(
      credentials,
      Transaction(
        maxGas: maxGas.toInt(),
        to: trxInfo.receiver,
        value: EtherAmount.inWei(
            BigInt.from(double.parse(trxInfo.amount) * pow(10, 18))),
      ),
      fetchChainIdFromNetworkId: true,
    );

    print('res: $res');

    return res;
  }

  @override
  Future<BigInt> getMaxGas(
      EthereumAddress sender, TransactionInfo trxInfo) async {
    final maxGas = await _client.estimateGas(
      sender: sender,
      to: trxInfo.receiver,
      value: EtherAmount.inWei(
          BigInt.from(double.parse(trxInfo.amount) * pow(10, 18))),
    );

    return maxGas;
  }
}
