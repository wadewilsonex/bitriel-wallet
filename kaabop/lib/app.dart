import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';
import 'src/route/router.dart' as router;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  @override
  void initState() {
    readTheme();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MarketProvider().fetchTokenMarketPrice(context);

      await initApi();
      // clearOldBtcAddr();
    });

    super.initState();
  }

  Future<void> initApi() async {
    try {
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      final contractProvider =
          Provider.of<ContractProvider>(context, listen: false);

      await Provider.of<ApiProvider>(context, listen: false)
          .initApi()
          .then((value) async {
        if (ApiProvider.keyring.keyPairs.isNotEmpty) {
          await contractProvider.getEtherAddr();

          await getSavedContractToken();
          await getEtherSavedContractToken();

          await apiProvider.getAddressIcon();
          await apiProvider.getCurrentAccount();
          await contractProvider.getKgoBalance();
          await contractProvider.getBscBalance();
          await contractProvider.getBscV2Balance();
          await isKgoContain();
          await contractProvider.getEtherBalance();
          await contractProvider.getBnbBalance();

          await isBtcContain();

          // Add BTC, DOT, SEL testnet Into listContract of Contract Provider's Property
          contractProvider.addApiProviderProperty(apiProvider);

          // Sort Contract Asset
          await Provider.of<ContractProvider>(context, listen: false)
              .sortAsset(context);

          // Ready To Display Asset Portfolio
          Provider.of<ContractProvider>(context, listen: false).setReady();
        }
        // This Method Is Also Request Dot Contract
        await apiProvider.connectPolNon();

        await Provider.of<ApiProvider>(context, listen: false)
            .connectNode()
            .then((value) async {
          if (value != null) {
            if (ApiProvider.keyring.keyPairs.isNotEmpty) {
              await Provider.of<ApiProvider>(context, listen: false)
                  .getChainDecimal();
            }
          }
        });
      });
    } catch (e) {
      print("Error init app.dart $e");
    }
  }

  void selV2() async {
    await Provider.of<ContractProvider>(context, listen: false)
        .getBscV2Balance();
    Provider.of<WalletProvider>(context, listen: false).addTokenSymbol(
      'SEL v2 (BEP-20)',
    );
  }

  void readTheme() async {
    final res = await StorageServices.fetchData('dark');

    if (res != null) {
      Provider.of<ThemeProvider>(context, listen: false).changeMode();
    }
  }

  Future<void> getSavedContractToken() async {
    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData('contractList');

    if (res != null) {
      for (final i in res) {
        final symbol = await contractProvider.query(i.toString(), 'symbol', []);
        final decimal =
            await contractProvider.query(i.toString(), 'decimals', []);
        final balance = await contractProvider.query(i.toString(), 'balanceOf',
            [EthereumAddress.fromHex(contractProvider.ethAdd)]);

        contractProvider.addContractToken(TokenModel(
          contractAddr: i.toString(),
          decimal: decimal[0].toString(),
          symbol: symbol[0].toString(),
          balance: balance[0].toString(),
          org: 'BEP-20',
        ));

        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('${symbol[0]} (BEP-20)');
      }
    }
  }

  Future<void> getEtherSavedContractToken() async {
    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData('ethContractList');
    print("getEtherSaved $res");
    if (res != null) {
      for (final i in res) {
        final symbol =
            await contractProvider.queryEther(i.toString(), 'symbol', []);
        final decimal =
            await contractProvider.queryEther(i.toString(), 'decimals', []);
        final balance = await contractProvider.queryEther(i.toString(),
            'balanceOf', [EthereumAddress.fromHex(contractProvider.ethAdd)]);

        contractProvider.addContractToken(TokenModel(
          contractAddr: i.toString(),
          decimal: decimal[0].toString(),
          symbol: symbol[0].toString(),
          balance: balance[0].toString(),
          org: 'ERC-20',
        ));
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('${symbol[0]} (ERC-20)');
      }
    }
  }

  Future<void> isBtcContain() async {
    final res = await StorageServices.fetchData('bech32');

    if (res != null) {
      Provider.of<ApiProvider>(context, listen: false)
          .isBtcAvailable('contain');

      Provider.of<ApiProvider>(context, listen: false)
          .setBtcAddr(res.toString());
      Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BTC');
      await Provider.of<ApiProvider>(context, listen: false)
          .getBtcBalance(res.toString());
    }
  }

  clearOldBtcAddr() async {
    final res = await StorageServices.fetchData('btcaddress');
    if (res != null) {
      await StorageServices.removeKey('btcaddress');
    }
  }

  Future<void> isKgoContain() async {
    try {
      await Provider.of<ContractProvider>(context, listen: false)
          .getKgoDecimal()
          .then((value) async {
        await Provider.of<ContractProvider>(context, listen: false)
            .getKgoBalance();
      });
    } catch (e) {
      // print("Error KGO $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<ThemeProvider>(context).isDark;
    return AnnotatedRegion(
      value: darkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: LayoutBuilder(
        builder: (builder, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return Consumer<ThemeProvider>(
                builder: (context, value, child) {
                  return MaterialApp(
                    navigatorKey: AppUtils.globalKey,
                    title: AppString.appName,
                    theme: AppStyle.myTheme(context),
                    onGenerateRoute: router.generateRoute,
                    routes: {
                      Home.route: (_) => Home(),
                    },
                    initialRoute: AppString.splashScreenView,
                    builder: (context, widget) => ResponsiveWrapper.builder(
                      BouncingScrollWrapper.builder(context, widget),
                      maxWidth: 1200,
                      defaultScale: true,
                      breakpoints: [
                        const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
                        const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                        const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                        const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
