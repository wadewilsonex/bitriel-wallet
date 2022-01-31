import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/service/portfolio_s.dart';

class Home extends StatefulWidget {
  // final bool apiConnected;
  // ignore: avoid_positional_boolean_parameters
  //const Home({this.apiConnected});

  static const route = '/home';

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>  with TickerProviderStateMixin, WidgetsBindingObserver {
  MenuModel menuModel = MenuModel();
  LineChartModel lineChartModel = LineChartModel();
  final HomeModel _homeM = HomeModel();

  String status = '';

  @override
  void initState() {
    super.initState();
    _homeM.globalKey = GlobalKey<ScaffoldState>();
    _homeM.userData = {};
    event();
    // Timer(const Duration(seconds: 2), () {
    //   PortfolioServices().setPortfolio(context);
    // });

    // if (mounted){
    //   marketPriceInitializer();
    // }

    AppServices.noInternetConnection(_homeM.globalKey!);

    WidgetsBinding.instance!.addObserver(this);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<ContractProvider>(context, listen: false)
          .subscribeBscbalance(context);
      await Provider.of<ContractProvider>(context, listen: false)
          .subscribeEthbalance();
    });
  }

  Future<void> event() async {
    await StorageServices.fetchData(DbKey.event).then((value) async {
      if (value == null){

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              content: Stack(
                children: [
                  Image.asset("assets/event.png", fit: BoxFit.cover,),
                  IconButton(
                    onPressed: () async {
                      await StorageServices.storeData(true, DbKey.event);
                      Navigator.pop(context);
                    }, 
                    icon: Icon(Icons.close, color: Colors.white,)
                  )
                ],
              ),
              actions: null
              // <Widget>[
              //   // TextButton(
              //   //   onPressed: () {
              //   //     Navigator.pop(context)
              //   //   },
              //   //   child: const Text('Close'),
              //   // ),
              // ],
            );
          },
        );
      }
    });
  }

  void marketPriceInitializer() async {
    try {
      final mkPro = await Provider.of<MarketProvider>(context, listen: false);

      await StorageServices.fetchData(DbKey.marketkPrice).then((value) async {
        if (value != null) {
          mkPro.sortDataMarket = List<Map<String, dynamic>>.from(value);
          await Provider.of<WalletProvider>(context, listen: false)
              .fillWithMarketData(context);
        }
      });

      /// Fetch and Fill Market Into Asset and Also Short Market Data By Price
      await mkPro.fetchTokenMarketPrice(context);

      await Provider.of<WalletProvider>(context, listen: false)
          .fillWithMarketData(context);

      await StorageServices.storeData(mkPro.sortDataMarket, DbKey.marketkPrice);
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
      // Handle this case
      // print('resume');

      // final res = await StorageServices.fetchAsset('assetData');
      // // print('res $res');

      // debugPrint(res, wrapWidth: 1024);

      // final res1 = SmartContractModel.decode(res);

      // print(res1[2].symbol);

      // print(res1[2].marketData.id);

      // print('lineChartData: ${res1[2].lineChartData}');
      // break;
      case AppLifecycleState.inactive:
        // Handle this case
        print('inactive');

        break;
      case AppLifecycleState.paused:
        // Handle this case
        print('paused');
        onPause();

        break;
      case AppLifecycleState.detached:
        print('detached');
        break;
    }
  }

  onPause() async {
    // var contractProvider =
    //     Provider.of<ContractProvider>(context, listen: false);
    await StorageServices.storeAssetData(context);

    // final contract =
    //     Provider.of<ContractProvider>(context, listen: false).listContract;
    // final res = SmartContractModel.encode(contract);

    // print(res);

    // final res1 = SmartContractModel.decode(res);

    // print(res1[0].symbol);
    // await StorageServices.setData('Hello', 'assetData');
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    print('dispose');
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  void save() async {
    var list = jsonEncode(ContractProvider().listContract);

    await StorageServices.storeData(list, DbKey.listContract);
  }

  Future<void> toReceiveToken() async {
    await Navigator.pushNamed(context, AppString.recieveWalletView);
  }

  void openMyDrawer() {
    _homeM.globalKey!.currentState!.openDrawer();
  }

  Future<void> onClosed() async {
    await StorageServices.setUserID('claim', 'claim');
    Navigator.pop(context);
  }

  Future<void> onClaim() async {
    Navigator.pop(context);
    await StorageServices.setUserID('claim', 'claim');
    Navigator.push(context, RouteAnimation(enterPage: ClaimAirDrop()));
  }

  Future<void> handle() async {
    Navigator.of(context).pop();
    Timer(const Duration(seconds: 1), () async {
      PortfolioServices().setPortfolio(context);
      showAirdrop();
    });
  }

  Future<void> showAirdrop() async {
    Timer(const Duration(seconds: 1), () async {
      final res = await StorageServices.fetchData('claim');
      if (res == null) {
        await dialogEvent(context, 'assets/bep20.png', onClosed, onClaim);
      }
    });
  }

  Future<void> scrollRefresh() async {
    final contract = Provider.of<ContractProvider>(context, listen: false);

    contract.isReady = false;

    setState(() {});

    await PortfolioServices().setPortfolio(context);

    await ContractsBalance().refetchContractBalance(context: context);

    // To Disable Asset Loading
    contract.setReady();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      key: _homeM.globalKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Menu(_homeM.userData!),
      ),

      // AnnotatedRegion Use For System Icon Above SafeArea
      body: Column(children: [
        SafeArea(child: homeAppBar(context)),
        Divider(
          height: 2,
          color: isDarkTheme ? Colors.black : Colors.grey.shade400,
        ),
        Flexible(
          child: RefreshIndicator(
            onRefresh: () async => await scrollRefresh(),
            child: BodyScaffold(
              bottom: 0,
              isSafeArea: false,
              child: HomeBody(),
            ),
          ),
        ),
      ]),

      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: hexaCodeToColor(AppColors.secondary).withOpacity(1.0),
        onPressed: () async {
          await TrxOptionMethod.scanQR(
            context,
            _homeM.portfolioList,
          );
        },
        child: SvgPicture.asset(
          'assets/icons/qr_code.svg',
          width: 30,
          height: 30,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MyBottomAppBar(
        apiStatus: true,
        homeM: _homeM,
        toReceiveToken: toReceiveToken,
        openDrawer: openMyDrawer,
      ),
    );
  }
}
