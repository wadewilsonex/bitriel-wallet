
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/config/route/router.dart' as router;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {

  @override
  void initState() {

    Provider.of<ContractsBalance>(context, listen: false).setContext = context;

    // MarketProvider().fetchTokenMarketPrice(context);

    // readTheme();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      // Query Selendra Endpoint
      await getSelendraEndpoint().then((value) async {
        // Assign Data and Store Endpoint Into Local DB
        await Provider.of<ApiProvider>(context, listen: false).initSelendraEndpoint(await json.decode(value.body));
      });
      
      await initApi();
      
      clearOldBtcAddr();
    });

    super.initState();
  }

  Future<void> initApi() async {

    try {
    
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);

      final contractProvider = Provider.of<ContractProvider>(context, listen: false);

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

        if(kDebugMode){
          print(Provider.of<ApiProvider>(context, listen: false).getKeyring.keyPairs.isEmpty);
          print("finish initApi");
          print("print(Provider.of<ApiProvider>(context, listen: false).getKeyring.allAccounts.length); ${Provider.of<ApiProvider>(context, listen: false).getKeyring.allAccounts.length}");
        }
        
        await apiProvider.connectSELNode(context: context, endpoint: apiProvider.selNetwork);
        
        if (apiProvider.getKeyring.keyPairs.isNotEmpty) {

          if(!mounted) return;
          Provider.of<ContractProvider>(context, listen: false).getEtherAddr();

          if(!mounted) return;
          Provider.of<ContractProvider>(context, listen: false).getBtcAddr();

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
          await ContractsBalance().getAllAssetBalance();
          
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error initApi $e");
      }
    }
  }

  Future<void> readTheme() async {
    try {

      final res = await StorageServices.fetchData(DbKey.themeMode);

      if (res != null) {
        if(!mounted) return;
        await Provider.of<ThemeProvider>(context, listen: false).changeMode();
      }
    } catch (e){
      if (ApiProvider().isDebug == true) {
        if (kDebugMode) {
          print("Error readTheme $e");
        }
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
                  return AnnotatedRegion(
                    value: darkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      navigatorKey: AppUtils.globalKey,
                      title: AppString.appName,
                      theme: AppStyle.myTheme(context),
                      onGenerateRoute: router.generateRoute,
                      // routes: {
                      //   HomePage.route: (_) => GoogleAuthService().handleAuthState() // HomePage(),
                      // },
                      initialRoute: AppString.splashScreenView,
                      
                      builder: (context, child) => ResponsiveWrapper.builder(
                        // BouncingScrollWrapper.builder(context, widget!),
                          child,
                          maxWidth: 1200,
                          minWidth: 480,
                          defaultScale: true,
                          breakpoints: [
                            ResponsiveBreakpoint.resize(480, name: MOBILE),
                            ResponsiveBreakpoint.autoScale(800, name: TABLET),
                            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                          ],
                          background: Container(color: Color(0xFFF5F5F5))
                      ),

                    ),
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