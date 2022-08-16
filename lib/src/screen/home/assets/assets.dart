import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/assets/body_asset.dart';

class AssetsPage extends StatefulWidget {

  final HomePageModel? homePageModel;
  final bool? isTrx;
  const AssetsPage({ Key? key, required this.homePageModel, this.isTrx = false }) : super(key: key);

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> with SingleTickerProviderStateMixin {

  int changeVertical = 0;

  AssetPageModel _model = AssetPageModel();

  Future<void> scrollRefresh() async {

    final contract = Provider.of<ContractProvider>(context, listen: false);

    contract.isReady = false;

    setState(() {});
      _model.indicator!.currentState!.show();
      await Future.delayed(Duration(seconds: 1), (){});

    // await PortfolioServices().setPortfolio(context);
    if (_model.tabController!.index == 0 || _model.tabController!.index == 1){

      await ContractsBalance().refetchContractBalance(context: context);
    } else if (_model.tabController!.index == 2){
      _model.indicator!.currentState!.show();
      await Future.delayed(Duration(seconds: 1), (){});
      _model.bep20Assets = AppServices().sortAsset(_model.bep20Assets!);
    } else if (_model.tabController!.index == 3){
      _model.indicator!.currentState!.show();
      await Future.delayed(Duration(seconds: 1), (){});
      _model.erc20Assets = AppServices().sortAsset(_model.erc20Assets!);

    } 

    // To Disable Asset Loading
    contract.setReady();
  } 

  @override
  void initState() {
    
    _model.tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    _model.assetLength = Provider.of<ContractProvider>(context, listen: false).sortListContract.length;
    _model.indicator = GlobalKey<RefreshIndicatorState>();
    _model.scrollController = ScrollController();
    /// If Do transaction We need to refetch All Asset's Data.
    if (widget.isTrx == true){
      Provider.of<ContractsBalance>(context, listen: false).refetchContractBalance(context: context);
    }
    
    _model.assetFilter(context);

    AppServices.noInternetConnection(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _model.scrollController!.dispose();
    super.dispose();
  }

  void _onTapCategories(int index, {bool? isTap}){
    setState(() {
      _model.categoryIndex = index;
      // if (isTap != null) widget.homePageModel!.pageController.jumpToPage(index);
      // else 
      if (isTap != null) _model.tabController!.animateTo(index);

      if (index == 0) _model.assetLength = Provider.of<ContractProvider>(context, listen: false).sortListContract.length;
      else if (index == 1) _model.assetLength = _model.nativeAssets!.length;// > 5 ? _model.nativeAssets!.length : 5;
      else if (index == 2) _model.assetLength = _model.bep20Assets!.length;// > 5 ? _model.bep20Assets!.length : 5;
      else if (index == 3) _model.assetLength = _model.erc20Assets!.length;// > 5 ? _model.erc20Assets!.length : 5;
    });
  }

  // Drag Horizontal Left And Right
  void _onHorizontalChanged(DragEndDetails details){
    // From Right To Left = Scroll To Home Page
    if (details.primaryVelocity!.toDouble() < 0 && _model.tabController!.index == 3) {
      widget.homePageModel!.pageController!.jumpToPage(2);
    }

    // From Left To Right = Scroll To Discover Page
    else if (details.primaryVelocity!.toDouble() > 0 && _model.tabController!.index == 0) {
      widget.homePageModel!.pageController!.jumpToPage(0);
    }
    
    // Scroll Forward InSide Asset Page
    else if (details.primaryVelocity!.toDouble() < 0) {

      _onTapCategories(_model.tabController!.index+1);
      _model.tabController!.animateTo(_model.tabController!.index+1);
      // homePageModel!.pageController.jumpTo(2);
    }
    
    // Scroll Backward InSide Asset Page
    else if (details.primaryVelocity!.toDouble() > 0) {
      _onTapCategories(_model.tabController!.index-1);
      _model.tabController!.animateTo(_model.tabController!.index-1);
      // homePageModel!.pageController.jumpTo(2);
    }
  }

  // Drag Horizontal Left And Right
  void _onVerticalUpdate(DragUpdateDetails details) async {
    _model.scrollController!.jumpTo(_model.scrollController!.offset + (details.primaryDelta! * (-1)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: RefreshIndicator(
        key: _model.indicator,
        onRefresh: () async => await scrollRefresh(),
        child: AssetsPageBody(
          homePageModel: widget.homePageModel!,
          model: _model,
          onTapCategories: _onTapCategories,
          onHorizontalChanged: _onHorizontalChanged,
          onVerticalUpdate: _onVerticalUpdate,
        )
      ),
    );
  }
}