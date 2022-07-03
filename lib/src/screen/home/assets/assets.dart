import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/assets/body_asset.dart';

class AssetsPage extends StatefulWidget {

  final HomePageModel? homePageModel;
  final bool? isTrx;
  const AssetsPage({ Key? key, required this.homePageModel, this.isTrx }) : super(key: key);

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> with SingleTickerProviderStateMixin {

  AssetPageModel _model = AssetPageModel();

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
    print("initState ${widget.homePageModel!.pageController.page}");
    _model.tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    /// If Do transaction We need to refetch All Asset's Data.
    if (widget.isTrx == true){
      Provider.of<ContractsBalance>(context, listen: false).refetchContractBalance(context: context);
    }
    
    _model.assetFilter(context);

    // _model.tabController!.addListener(() {
    //   print("listening");
    //   _onTapCategories(_model.tabController!.index);
    // });
    super.initState();
  }

  void _onTapCategories(int index, {bool? isTap}){
    print("index: $index");
    setState(() {
      _model.categoryIndex = index;
      // if (isTap != null) widget.homePageModel!.pageController.jumpToPage(index);
      // else 
      if (isTap != null) _model.tabController!.animateTo(index);
    //   // if (_model.pageController!.page == 3.0) widget.homePageModel!.pageController.jumpToPage(2);
    });
  }

  // Drag Horizontal Left And Right
  void _onHorizontalChanged(DragEndDetails details){
    
    // From Right To Left = Scroll To Home Page
    if (details.primaryVelocity!.toDouble() < 0 && _model.tabController!.index == 3) {

      widget.homePageModel!.pageController.jumpToPage(2);
    }

    // From Left To Right = Scroll To Discover Page
    else if (details.primaryVelocity!.toDouble() > 0 && _model.tabController!.index == 0) {

      widget.homePageModel!.pageController.jumpToPage(0);
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: RefreshIndicator(
        onRefresh: () async => await scrollRefresh(),
        child: AssetsPageBody(
          homePageModel: widget.homePageModel!,
          model: _model,
          onTapCategories: _onTapCategories,
          onHorizontalChanged: _onHorizontalChanged
        )
      ),
    );
  }
}