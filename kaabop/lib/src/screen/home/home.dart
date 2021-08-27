import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/lineChart_m.dart';
import 'package:wallet_apps/src/service/portfolio_s.dart';

class Home extends StatefulWidget {
  final bool apiConnected;
  // ignore: avoid_positional_boolean_parameters
  const Home({this.apiConnected});

  static const route = '/home';

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {

  MenuModel menuModel = MenuModel();
  LineChartModel lineChartModel = LineChartModel();
  final HomeModel _homeM = HomeModel();

  String status = '';

  @override
  void initState() {
    // processingDialog(context, true, false, false);
    Timer(const Duration(seconds: 2), () {
      PortfolioServices().setPortfolio(context);
    });

    AppServices.noInternetConnection(_homeM.globalKey);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContractProvider>(context, listen: false).subscribeBscbalance(context);
      Provider.of<ContractProvider>(context, listen: false).subscribeEthbalance();
    });

    super.initState();
    
  }

  @override
  dispose(){
    super.dispose();
  }

  Future<void> toReceiveToken() async {
    await Navigator.pushNamed(context, AppText.recieveWalletView);
  }

  void openMyDrawer() {
    _homeM.globalKey.currentState.openDrawer();
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
    final api = Provider.of<ApiProvider>(context, listen: false);
    final market = Provider.of<MarketProvider>(context, listen: false);
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    contract.isReady = false;
    setState(() {});

    await PortfolioServices().setPortfolio(context);
      
    if (contract.listContract[0].isContain) {
      await contract.getBscBalance();
    }

    if (contract.listContract[1].isContain) {
      await contract.getBscV2Balance();
    }

    if (contract.listContract[2].isContain) {
      await Provider.of<ContractProvider>(context, listen: false).getKgoDecimal().then((value) async {
        await Provider.of<ContractProvider>(context, listen: false).getKgoBalance();
      });
    }

    if (contract.listContract[3].isContain) {
      await contract.getEtherBalance();
    }

    if (contract.listContract[4].isContain) {
      await contract.getBnbBalance();
    }

    if (api.btc.isContain) {
      await api.getBtcBalance(api.btcAdd);
    }

    // Sort Each Asset Portfolio
    await contract.sortAsset();

    if (contract.token.isNotEmpty) {
      await contract.fetchNonBalance();
      await contract.fetchEtherNonBalance();
    }

    // To Disable Asset Loading
    contract.setReady();
    
    /* -----------------------Pie Chart----------------------- */
    // Fetch 5 Asset From Market
    await market.fetchTokenMarketPrice(context);

    // Fill 5 Asset Into Pie Chart
    await wallet.fillWithMarketData(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Scaffold(
      key: _homeM.globalKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Menu(_homeM.userData),
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
              onRefresh: () async {
                await scrollRefresh();
              },
              child: BodyScaffold(
                bottom: 0,
                isSafeArea: false,
                child: HomeBody(),
              ),
            ),
          ),
        ]),

      floatingActionButton: Container(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          elevation: 0,
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
