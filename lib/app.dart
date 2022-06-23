import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/api/api.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:web3dart/web3dart.dart';
import 'src/route/router.dart' as router;
import 'package:http/http.dart' as _http;

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
    // readTheme();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
      await initApi();

      clearOldBtcAddr();
    });

    super.initState();
  }

  Future<void> initApi() async {
    
    // Fetch Name and Symbol Coin
    await StorageServices.fetchData(DbKey.coinData).then((value) {
      if (value == null){

        _http.get(Uri.parse("https://api.coingecko.com/api/v3/coins/list")).then((value) async {
          dynamic data = await json.decode(value.body);
          await StorageServices.storeData(data, DbKey.coinData);
          Provider.of<MarketProvider>(context, listen: false).setLsCoin = data;
        });
      } else {
        Provider.of<MarketProvider>(context, listen: false).setLsCoin = value;
      }
    });

    try {
    
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      final contractProvider = await Provider.of<ContractProvider>(context, listen: false);

      contractProvider.setSavedList().then((value) async {
        // If Data Already Exist
        // Setup Cache
        if (value){
          // Sort After MarketPrice Filled Into Asset
          await Provider.of<ContractProvider>(context, listen: false).sortAsset();

          contractProvider.setReady();
        }
      });
      
      await apiProvider.initApi(context: context).then((value) async {

        // await apiProvider.connectPolNon(context: context).then((value) async {
        // });
        await apiProvider.connectSELNode(context: context);
        if (apiProvider.getKeyring.keyPairs.isNotEmpty) {
          print("apiProvider.getKeyring.keyPairs.isNotEmpty ${apiProvider.getKeyring.keyPairs.isNotEmpty}");
          /// Cannot connect Both Network On the Same time
          /// 
          /// It will be wrong data of that each connection. 
          /// 
          /// This Function Connect Polkadot Network And then Connect Selendra Network
          // await apiProvider.getDotChainDecimal(con5text: context);
          // await apiProvider.subscribeDotBalance(context: context);

          // await apiProvider.connectSELNode(context: context);
          await apiProvider.getAddressIcon();
          // Get From Keyring js
          await apiProvider.getCurrentAccount(context: context, funcName: 'keyring');
          // Get SEL Native Chain Will Fetch also Balance
          await ContractsBalance().getAllAssetBalance(context: context);
          
        }
      });
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error initApi $e");
    }
  }

  // Future<void> downloadFile() async {

  //   var dir = await getApplicationDocumentsDirectory();
  // }

  Future<void> readTheme() async {
    try {

      final res = await StorageServices.fetchData(DbKey.themeMode);

      if (res != null) {
        await Provider.of<ThemeProvider>(context, listen: false).changeMode();
      }
    } catch (e){
      if (ApiProvider().isDebug == true) print("Error readTheme $e");
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

        Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('${symbol[0]} (BEP-20)');
      }
    }
  }

  Future<void> getEtherSavedContractToken() async {
    final contractProvider = Provider.of<ContractProvider>(context, listen: false);
    final res = await StorageServices.fetchData(DbKey.ethContractList);
    if (res != null) {
      
      for (final i in res) {

        final symbol = await contractProvider.queryEther(i.toString(), 'symbol', []);
        final decimal = await contractProvider.queryEther(i.toString(), 'decimals', []);
        final balance = await contractProvider.queryEther(i.toString(), 'balanceOf', [EthereumAddress.fromHex(contractProvider.ethAdd)]);

        contractProvider.addContractToken(TokenModel(
          contractAddr: i.toString(),
          decimal: decimal![0].toString(),
          symbol: symbol![0].toString(),
          balance: balance![0].toString(),
          org: 'ERC-20',
        ));
        Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('${symbol[0]} (ERC-20)');
      }
    }
  }

  clearOldBtcAddr() async {
    final res = await StorageServices.fetchData(DbKey.btcAddr);
    if (res != null) {
      await StorageServices.removeKey(DbKey.btcAddr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = Provider.of<ThemeProvider>(context).isDark;
    return ResponsiveSizer( 
      builder: (context, orientation, screenType) {
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
                        // debugShowCheckedModeBanner: false,
                        routes: {
                          HomePage.route: (_) => HomePage(),
                        },
                        initialRoute: AppString.splashScreenView,
                        // builder: (context, widget) => ResponsiveWrapper.builder(
                        //   BouncingScrollWrapper.builder(context, widget!),
                        //   maxWidth: 1200,
                        //   // minWidth: 800,
                        //   defaultScale: true,
                        //   breakpoints: [
                        //     const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
                        //     const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                        //     const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                        //     const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                        //   ],
                        // ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      }
    );
  }
}