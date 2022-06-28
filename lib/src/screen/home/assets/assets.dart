import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/assets/body_asset.dart';

class AssetsPage extends StatefulWidget {

  final bool? isTrx;
  const AssetsPage({ Key? key, this.isTrx }) : super(key: key);

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {

  Future<void> scrollRefresh() async {
    final contract = Provider.of<ContractProvider>(context, listen: false);

    contract.isReady = false;

    setState(() {});

    // await PortfolioServices().setPortfolio(context);

    await ContractsBalance().refetchContractBalance(context: context);

    // To Disable Asset Loading
    contract.setReady();
  } 

  @override
  void initState() {
    /// If Do transaction We need to refetch All Asset's Data.
    if (widget.isTrx == true){
      Provider.of<ContractsBalance>(context, listen: false).refetchContractBalance(context: context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await scrollRefresh(),
      child: AssetsPageBody()
    );
  }
}