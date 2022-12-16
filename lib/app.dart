import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/provider/auth/google_auth_service.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/graphql/ql_client.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
import 'package:web3dart/web3dart.dart';
import 'src/route/router.dart' as router;

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

    MarketProvider().fetchTokenMarketPrice(context);

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

        // await apiProvider.connectPolNon(context: context).then((value) async {
        // });
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
          await ContractsBalance().getAllAssetBalance(context: context);
          
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
                  return GraphQLProvider(
                    client: GQLClient().client,
                    child: MaterialApp(
                      navigatorKey: AppUtils.globalKey,
                      title: AppString.appName,
                      theme: AppStyle.myTheme(context),
                      onGenerateRoute: router.generateRoute,
                      routes: {
                        HomePage.route: (_) => GoogleAuthService().handleAuthState() // HomePage(),
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