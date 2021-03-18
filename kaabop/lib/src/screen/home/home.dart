import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

class Home extends StatefulWidget {
  final CreateAccModel sdkModel;
  const Home({this.sdkModel});

  static const route = '/home';

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  MenuModel menuModel = MenuModel();
  final HomeModel _homeM = HomeModel();
  final PortfolioM _portfolioM = PortfolioM();
  BuildContext dialogContext;

  String status = '';

  @override
  void initState() {
    if (widget.sdkModel.apiConnected) {
      status = null;
      Timer(const Duration(seconds: 3), () {
        setPortfolio();
      });
    }

    if (!widget.sdkModel.apiConnected) {
      startNode();
    }

    super.initState();
  }

  Future<void> handleDialog() async {
    if (!Provider.of<ApiProvider>(context, listen: false).isConnected) {
      startNode();
    }
  }

  Future<void> startNode() async {
    await Future.delayed(
      const Duration(milliseconds: 50),
      () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            dialogContext = context;
            return disableNativePopBackButton(
              AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Column(
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(
                        hexaCodeToColor(
                          AppColors.secondary,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.red,
                      highlightColor: Colors.yellow,
                      child: const Align(
                        child: MyText(
                          text: "\nConnecting to Remote Node...",
                          color: "#000000",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                content: const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: MyText(
                    text: "Please wait ! this might take a bit longer",
                    color: "#000000",
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> toReceiveToken() async {
    await Navigator.pushNamed(context, ReceiveWallet.route);
  }

  void openMyDrawer() {
    _homeM.globalKey.currentState.openDrawer();
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 300)).then((value) {
      setPortfolio();
    });
  }

  void setPortfolio() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.clearPortfolio();

    final contract = Provider.of<ContractProvider>(context, listen: false);

    final api = Provider.of<ApiProvider>(context, listen: false);
    if (contract.kmpi.isContain) {
      walletProvider.addAvaibleToken({
        'symbol': contract.kmpi.symbol,
        'balance': contract.kmpi.balance,
      });
    }

    if (contract.atd.isContain) {
      walletProvider.addAvaibleToken({
        'symbol': contract.atd.symbol,
        'balance': contract.atd.balance,
      });
    }

    walletProvider.addAvaibleToken({
      'symbol': api.nativeM.symbol,
      'balance': api.nativeM.balance,
    });

    if (!contract.kmpi.isContain && !contract.atd.isContain) {
      Provider.of<WalletProvider>(context, listen: false).resetDatamap();
    }

    Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  }

  Future<void> handle() async {
    if (widget.sdkModel.apiConnected) {
      await Future.delayed(const Duration(milliseconds: 200), () {
        status = null;
      });

      Navigator.of(dialogContext).pop();
      Timer(const Duration(seconds: 3), () {
        setPortfolio();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status != null) handle();
    return Scaffold(
      key: _homeM.globalKey,
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Menu(_homeM.userData),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: HomeBody(
            sdkModel: widget.sdkModel,
            setPortfolio: setPortfolio,
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          backgroundColor: hexaCodeToColor(AppColors.secondary)
              .withOpacity(!widget.sdkModel.apiConnected ? 0.3 : 1.0),
          onPressed: () async {
            await TrxOptionMethod.scanQR(
              context,
              _homeM.portfolioList,
              widget.sdkModel,
            );
          },
          child: SvgPicture.asset(
            'assets/icons/qr_code.svg',
            width: 30,
            height: 30,
            color: !widget.sdkModel.apiConnected
                ? Colors.white.withOpacity(0.2)
                : Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MyBottomAppBar(
        apiStatus: widget.sdkModel.apiConnected,
        homeM: _homeM,
        portfolioM: _portfolioM,
        // Bottom Center Button
        toReceiveToken: toReceiveToken,
        openDrawer: openMyDrawer,
        sdkModel: widget.sdkModel,
      ),
    );
  }
}