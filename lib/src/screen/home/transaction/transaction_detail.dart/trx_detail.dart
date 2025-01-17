import 'package:wallet_apps/src/screen/home/transaction/transaction_detail.dart/body_trx_detail.dart';
import 'package:wallet_apps/index.dart';

import '../../../../models/asset_info.dart';

class TransactionDetail extends StatefulWidget {
  final AssetInfoModel? assetInfoModel;

  const TransactionDetail({
    Key? key,
    this.assetInfoModel,
  }) : super(key: key);

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    return BodyTransactionDetail(assetInfoModel: widget.assetInfoModel);
  }
}