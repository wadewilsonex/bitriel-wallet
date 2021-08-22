import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/screen_wrapper.dart';
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

class HomeState extends State<Home>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  MenuModel menuModel = MenuModel();
  final HomeModel _homeM = HomeModel();

  String status = '';

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      PortfolioServices().setPortfolio(context);
    });

    AppServices.noInternetConnection(_homeM.globalKey);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContractProvider>(context, listen: false)
          .subscribeBscbalance();
      Provider.of<ContractProvider>(context, listen: false)
          .subscribeEthbalance();
    });
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      Provider.of<ContractProvider>(context, listen: false)
          .unsubscribeNetwork();
      // went to Background
    }
    if (state == AppLifecycleState.resumed) {
      Provider.of<ContractProvider>(context, listen: false)
          .subscribeBscbalance();
      // came back to Foreground
    }
  }

  Future<void> toReceiveToken() async {
    await Navigator.pushNamed(context, AppString.recieveWalletView);
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

    await Future.delayed(const Duration(milliseconds: 300)).then((value) async {
      PortfolioServices().setPortfolio(context);
      market.fetchTokenMarketPrice(context);
      if (contract.bnbSmartChain.isContain) {
        contract.getBnbBalance();
      }
      if (contract.selBsc.isContain) {
        contract.getBscBalance();
      }

      if (contract.selBscV2.isContain) {
        contract.getBscV2Balance();
      }

      if (contract.etherNative.isContain) {
        contract.getEtherBalance();
      }

      if (contract.kgoBsc.isContain) {
        contract.getKgoBalance();
      }

      if (api.btc.isContain) {
        api.getBtcBalance(api.btcAdd);
      }

      if (contract.token.isNotEmpty) {
        contract.fetchNonBalance();
        contract.fetchEtherNonBalance();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return ScreenWrapper(
      routeName: "/home",
      onLeaveScreen: () => Provider.of<ContractProvider>(context, listen: false)
          .unsubscribeNetwork(),
      child: Scaffold(
        key: _homeM.globalKey,
        drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: Menu(_homeM.userData),
        ),
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
            backgroundColor:
                hexaCodeToColor(AppColors.secondary).withOpacity(1.0),
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
      ),
    );
  }
}
