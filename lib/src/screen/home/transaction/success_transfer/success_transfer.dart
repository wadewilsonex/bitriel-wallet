import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/transaction/success_transfer/body_success_transfer.dart';

class SuccessTransfer extends StatelessWidget {

  final String? assetLogo;
  final String? fromAddress;
  final String? toAddress;
  final String? amount;
  final String? fee;
  final String? hash;
  final String? trxDate;
  final String? assetSymbol;
  final ModelScanPay? scanPayM;
  final bool? isDebitCard;
  final num? qty;
  final num? price;

  const SuccessTransfer({
    Key? key,
    this.assetLogo,
    this.fromAddress,
    this.toAddress,
    this.amount,
    this.fee,
    this.hash,
    this.trxDate,
    this.assetSymbol,
    this.scanPayM,
    this.isDebitCard,
    this.qty,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuccessTransferBody(
      assetLogo: assetLogo,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      fee: fee,
      hash: hash,
      trxDate: trxDate,
      assetSymbol: assetSymbol,
      scanPayM: scanPayM,
      isDebitCard: isDebitCard,
      qty: qty,
      price: price
    );
  }
}