import 'package:wallet_apps/data/models/asset_info.dart';
import 'package:wallet_apps/presentation/screen/home/transaction/transaction_detail.dart/body_trx_detail.dart';
import 'package:wallet_apps/index.dart';

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