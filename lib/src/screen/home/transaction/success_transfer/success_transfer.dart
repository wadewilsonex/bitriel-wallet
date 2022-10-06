import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/transaction/success_transfer/body_success_transfer.dart';

class SuccessTransfer extends StatefulWidget {
  const SuccessTransfer({Key? key}) : super(key: key);

  @override
  State<SuccessTransfer> createState() => _SuccessTransferState();
}

class _SuccessTransferState extends State<SuccessTransfer> {
  @override
  Widget build(BuildContext context) {
    return SuccessTransferBody();
  }
}