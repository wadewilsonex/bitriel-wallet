import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/constants/db_key_con.dart';
import 'package:wallet_apps/data/provider/provider.dart';
import 'package:wallet_apps/data/provider/verify_seed_p.dart';
import 'package:wallet_apps/presentation/screen/home/wallet/body_wallet.dart';

class WalletPage extends StatefulWidget {

  final HomePageModel? homePageModel;
  final bool? isTrx;
  const WalletPage({ Key? key, required this.homePageModel, this.isTrx = false }) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with SingleTickerProviderStateMixin {


  final TextEditingController? searchController = TextEditingController();

  ContractProvider? contract;
  int changeVertical = 0;

  final AssetPageModel _model = AssetPageModel();

  // Future<void> scrollRefresh() async {

  //   contract!.isReady = false;

  //   setState(() {});
  //     _model.indicator!.currentState!.show();
  //     await Future.delayed(const Duration(seconds: 1), (){});

  //   // await PortfolioServices().setPortfolio(context);
  //   if (_model.tabController!.index == 0 || _model.tabController!.index == 1){
      
  //     if(!mounted) return;
  //     await ContractsBalance().refetchContractBalance(context: context);
  //   } else if (_model.tabController!.index == 2){
  //     _model.indicator!.currentState!.show();
  //     await Future.delayed(const Duration(seconds: 1), (){});
  //     _model.bep20Assets = AppServices().sortAsset(_model.bep20Assets!);
  //   } else if (_model.tabController!.index == 3){
  //     _model.indicator!.currentState!.show();
  //     await Future.delayed(const Duration(seconds: 1), (){});
  //     _model.erc20Assets = AppServices().sortAsset(_model.erc20Assets!);

  //   } 

  //   // To Disable Asset Loading
  //   contract!.setReady();
  // }

  @override
  void initState() {
    
    _model.tabController = TabController(initialIndex: 1, length: 4, vsync: this);
    _model.assetLength = Provider.of<ContractProvider>(context, listen: false).sortListContract.length;
    _model.indicator = GlobalKey<RefreshIndicatorState>();
    _model.scrollController = ScrollController();
    contract = Provider.of<ContractProvider>(context, listen: false);
    /// If Do transaction We need to refetch All Asset's Data.
    if (widget.isTrx == true){
      Provider.of<ContractsBalance>(context, listen: false).refetchContractBalance(context: context);
    }
    
    _model.assetFilter(context);

    StorageServices.readSecure(DbKey.privateList)!.then((value) {
      setState(() {
        Provider.of<VerifySeedsProvider>(context, listen: false).getPrivateList = jsonDecode(value);
      });
      
    });

    AppServices.noInternetConnection(context: context);
    super.initState();
  }

  Future<void> dismiss(List<SmartContractModel> lsAsset, index) async {
    debugPrint("dismiss $index");

    List found = contract!.addedContract.where((element) {
      if (element.contract == lsAsset[index].contract) return true;
      return false; 
    }).toList();

    debugPrint("found $found");
    if (found.isNotEmpty){

      contract!.addedContract.remove(found[0]);
      contract!.sortListContract.removeAt(index);

      await StorageServices.storeAssetData(context);
    }

    await Future.delayed(Duration(seconds: 1), (){});

    setState(() { });
    contract!.notifyListeners();
    
  }

  @override
  void dispose() {
    _model.scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WalletPageBody(
      homePageModel: widget.homePageModel ?? HomePageModel(),
      model: _model,
      searchController: searchController,
      dismiss: dismiss
    );
  }
}