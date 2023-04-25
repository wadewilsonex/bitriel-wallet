import 'package:wallet_apps/index.dart';
import 'package:polkawallet_sdk/api/types/txInfoData.dart';

class SubmitTrxService {

  TxFeeEstimateResult? fee;

  /// Submit Transaction For Sel Native Or Dot
  Future<bool> sendNative(ModelScanPay scanPay, String password, BuildContext context, {@required TransactionInfo? txInfo} ) async {

    try {

      final api = Provider.of<ApiProvider>(context, listen: false);
      final contract = Provider.of<ContractProvider>(context, listen: false);

      final sender = TxSenderData(
        contract.sortListContract[scanPay.assetValue].address,
        api.getKeyring.current.pubKey,
      );

      final txInfoData = TxInfoData('balances', 'transfer', sender);

      final chainDecimal = contract.sortListContract[scanPay.assetValue].chainDecimal;
      
      if (contract.sortListContract[scanPay.assetValue].symbol == "SEL"){
        return await api.connectSELNode(context: context).then((value) async {
          fee = await SendTrx(api.getSdk.api, api.getSdk.api.service.tx).estimateFees(
            txInfoData,
            [
              scanPay.controlReceiverAddress.text,
              Fmt.tokenInt(
                scanPay.controlAmount.text,
                chainDecimal!,
              ).toString(),
            ],
          );
          // await customDialog(context, "Fee", "Estimated fee price: ${fee.partialFee}");
          
          await sendTx(api, scanPay, password, context, txInfoData, chainDecimal);
          await api.getSelNativeChainDecimal(context: context);
          return true;
        });
        
      }
      //  else {

      //   return await api.connectPolNon(context: context).then((value) async {
      //     fee = await SendTrx(api.getSdk.api, api.getSdk.api.service.tx).estimateFees(
      //       txInfoData,
      //       [
      //         scanPay.controlReceiverAddress.text,
      //         Fmt.tokenInt(
      //           scanPay.controlAmount.text,
      //           chainDecimal!,
      //         ).toString(),
      //       ],
      //     );
      //     await sendTx(api, scanPay, password, context, txInfoData, chainDecimal);
      //     await api.subscribeDotBalance(context: context);
      //     return true;
      //   });
      // }


        // if (hash != null) {
        //   // await saveTxHistory(TxHistory(
        //   //   date: DateFormat.yMEd().add_jms().format(DateTime.now()).toString(),
        //   //   symbol: 'SEL',
        //   //   destination: target,
        //   //   sender: ApiProvider.keyring.current.address,
        //   //   org: 'SELENDRA',
        //   //   amount: amount.trim(),
        //   // ));

        //   await enableAnimation();
        // } else {
        //   // Navigator.pop(context);
        //   await customDialog(context, 'Opps', 'Something went wrong!');
        // }
    } catch (e) {
      
      if (kDebugMode) {
        debugPrint("Error sendNative $e");
      }
      
      await customDialog(context, 'Opps', e.toString(), txtButton: "Close",);
    }

    return false;
  }

  Future<void> sendTx(ApiProvider api, ModelScanPay scanPay, String password, BuildContext context, TxInfoData txInfoData, int chainDecimal ) async {
    await SendTrx(api.getSdk.api, api.getSdk.api.service.tx).signAndSend(
      txInfoData,
      [
        scanPay.controlReceiverAddress.text,
        Fmt.tokenInt(
          scanPay.controlAmount.text,
          chainDecimal,
        ).toString(),
      ],
      password,
      onStatusChange: (status) async {}
    );

    // Map? hash = await SendTrx(api.getSdk.api, api.getSdk.api.service.tx).signAndSend(
    //   txInfoData,
    //   [
    //     scanPay.controlReceiverAddress.text,
    //     Fmt.tokenInt(
    //       scanPay.controlAmount.text,
    //       chainDecimal,
    //     ).toString(),
    //   ],
    //   password,
    //   onStatusChange: (status) async {}
    // );
  }
}