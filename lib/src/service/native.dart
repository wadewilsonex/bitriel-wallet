import 'dart:math';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/inative.dart';

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
  Future<EthPrivateKey> getCredentials(String privateKey) async {
    return EthPrivateKey.fromHex(privateKey);//_client.credentialsFromPrivateKey(privateKey.substring(2));
  }

  @override
  Future<bool>? listenTransfer(String txHash) async {
    bool? std;
    // StreamSubscription subscribeEvent;

    // ignore: unused_local_variable
    // ignore: cancel_subscriptions
    await _client.addedBlocks().asyncMap((_) async {
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
          return std;
        }
      } catch (e) {
        
        if (kDebugMode) {
          print("Error listenTransfer $e");
        }
      }
    })
    .where((receipt) => receipt != null)
    .first;

    return std!;
  }

  @override
  Future<String>? sendTx(TransactionInfo trxInfo) async {
    print("sendTx native.dart");
    String? res;
    try {

      final credentials = await getCredentials(trxInfo.privateKey!);
      print("await _client.getBalance(credentials.address) ${await _client.getBalance(credentials.address)}");
      final maxGas = await getMaxGas(credentials.address, trxInfo);

      print("credentials ${credentials.address}");
      print("maxGas ${maxGas}");
      print("trxInfo.receiver ${trxInfo.receiver}");
      print("trxInfo.gasPrice ${trxInfo.gasPrice}");
      print("EtherAmount.inWei(BigInt.one) ${EtherAmount.inWei(BigInt.one)}");
      print("trxInfo.amount! ${trxInfo.amount!}");
      print("EtherAmount.inWei(BigInt.from(double.parse(trxInfo.amount!) * pow(10, trxInfo.chainDecimal!))) ${EtherAmount.inWei(BigInt.from(double.parse(trxInfo.amount!) * pow(10, trxInfo.chainDecimal!)))}");
      print("trxInfo.chainDecimal! ${trxInfo.chainDecimal!}");
      res = await _client.sendTransaction(
        credentials,
        Transaction(
          maxGas: maxGas.toInt(),
          to: trxInfo.receiver,
          value: EtherAmount.inWei(BigInt.from(double.parse(trxInfo.amount!) * pow(10, trxInfo.chainDecimal!))),
        ),
        chainId: 1,
        // fetchChainIdFromNetworkId: true,
      );

      print("Res $res");

    } catch (e){

      if (kDebugMode) {
        print("Err sendTx $e");
      }
    }

    return res!;
  }
  
  @override
  Future<BigInt> getMaxGas(EthereumAddress sender, TransactionInfo trxInfo) async {
    print("sender ${sender.hex}");
    print("_client.estimateGas ${await _client.getBalance(EthereumAddress.fromHex(sender.hex))}");
    final maxGas = await _client.estimateGas(
      sender: sender,
      to: trxInfo.receiver,
      value: EtherAmount.inWei(BigInt.from(double.parse(trxInfo.amount!) * pow(10, trxInfo.chainDecimal!))),
    );

    return maxGas;
  }
}
