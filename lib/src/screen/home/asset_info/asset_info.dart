import 'package:wallet_apps/data/models/asset_info.dart';
import 'package:wallet_apps/src/screen/home/asset_info/body_asset_info.dart';
import '../../../../index.dart';

class AssetInfo extends StatefulWidget {

  final int? index;
  final SmartContractModel? scModel;
  final List<TransactionInfo>? transactionInfo;
  final bool? showActivity;

  const AssetInfo({Key? key, 
    @required this.index,
    @required this.scModel,
    this.transactionInfo,
    this.showActivity
  }) : super(key: key);

  @override
  AssetInfoState createState() => AssetInfoState();
}

class AssetInfoState extends State<AssetInfo> {
  
  final AssetInfoModel _model = AssetInfoModel();

  String onSubmit(String value) {
    return value;
  }

  void onPageChange(int index) {
    setState(() {
      _model.tabIndex = index;
    });
  }

  void onTabChange(int tabIndex) {
    _model.controller.animateToPage(
      tabIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {

    _model.globalKey = GlobalKey<ScaffoldState>();

    if (widget.showActivity != null) {
      _model.tabIndex = 1;
      _model.controller = PageController(initialPage: 1);
    }

    _model.smartContractModel = widget.scModel;

    _model.lsTxInfo = widget.transactionInfo;

    _model.index = widget.index;

    AppServices.noInternetConnection(context: context);

    super.initState();
  }

  @override
  void dispose() {
    _model.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AssetInfoBody(
      assetInfoModel: _model,
      onPageChange: onPageChange,
      onTabChange: onTabChange,
    );
  }
}
