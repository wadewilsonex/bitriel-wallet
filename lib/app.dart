import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'src/route/router.dart' as router;

final RouteObserver<PageRoute>? routeObserver = RouteObserver<PageRoute>();

class App extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {

  @override
  void initState() {
    MarketProvider().fetchTokenMarketPrice(context);
    readTheme();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
      await initApi();

      clearOldBtcAddr();
    });

    super.initState();
  }

  Future<void> initApi() async {
    
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    final contractProvider = await Provider.of<ContractProvider>(context, listen: false);
    await contractProvider.setSavedList().then((value) async {
      // If Data Already Exist
      if (value){

        // Sort After MarketPrice Filled Into Asset
        await Provider.of<ContractProvider>(context, listen: false).sortAsset();

        contractProvider.setReady();
      }
    });
    
    await apiProvider.initApi(context: context).then((value) async {

      if (ApiProvider.keyring.keyPairs.isNotEmpty) {
        
        await apiProvider.getAddressIcon();
        await apiProvider.getCurrentAccount();
        
        await ContractsBalance().getAllAssetBalance(context: context);
      }
    });
  }

  // void selV2() async {
  //   Provider.of<ContractProvider>(context, listen: false).getBscV2Balance();
  //   Provider.of<WalletProvider>(context, listen: false).addTokenSymbol(
  //     'SEL v2 (BEP-20)',
  //   );
  // }

  void readTheme() async {
    final res = await StorageServices.fetchData(DbKey.themeMode);

    if (res != null) {
      Provider.of<ThemeProvider>(context, listen: false).changeMode();
    }
  }

  Future<void> getSavedContractToken() async {
    
    final contractProvider = Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData(DbKey.contactList);

    if (res != null) {
      for (final i in res) {
        final symbol = await contractProvider.query(i.toString(), 'symbol', []);
        final decimal = await contractProvider.query(i.toString(), 'decimals', []);
        final balance = await contractProvider.query(i.toString(), 'balanceOf', [EthereumAddress.fromHex(contractProvider.ethAdd)]);

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
          decimal: decimal![0].toString(),
          symbol: symbol![0].toString(),
          balance: balance![0].toString(),
          org: 'ERC-20',
        ));
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('${symbol[0]} (ERC-20)');
      }
    }
  }

  clearOldBtcAddr() async {
    final res = await StorageServices.fetchData('btcaddress');
    if (res != null) {
      await StorageServices.removeKey('btcaddress');
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
                    debugShowCheckedModeBanner: false,
                    routes: {
                      Home.route: (_) => Home(),
                    },
                    initialRoute: AppString.splashScreenView,
                    builder: (context, widget) => ResponsiveWrapper.builder(
                      BouncingScrollWrapper.builder(context, widget!),
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
