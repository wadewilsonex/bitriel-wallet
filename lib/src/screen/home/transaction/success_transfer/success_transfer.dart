import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/transaction/success_transfer/body_success_transfer.dart';

class SuccessTransfer extends StatefulWidget {

  final String? assetLogo;
  final String? fromAddress;
  final String? toAddress;
  final String? amount;
  final String? fee;
  final String? hash;
  final String? trxDate;
  final String? assetSymbol;
  final ModelScanPay? scanPayM;

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
  }) : super(key: key);

  @override
  State<SuccessTransfer> createState() => _SuccessTransferState();
}

class _SuccessTransferState extends State<SuccessTransfer> {
  @override
  Widget build(BuildContext context) {
    return SuccessTransferBody(
      assetLogo: widget.assetLogo,
      fromAddress: widget.fromAddress,
      toAddress: widget.toAddress,
      amount: widget.amount,
      fee: widget.fee,
      hash: widget.hash,
      trxDate: widget.trxDate,
      assetSymbol: widget.assetSymbol,
      scanPayM: widget.scanPayM,
    );
  }
}