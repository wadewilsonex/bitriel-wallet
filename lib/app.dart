
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/provider/newarticle_p.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/screen/home/home/home.dart';
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

  String? dir;

  // Init firebase deep link
  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  // Future<void> initDynamicLinks() async {

  //   // Query Deep Link Routes
  //   await getDeepLinkRoutes().then((dpLink) async {

  //     dynamicLinks.onLink.listen((dynamicLinkData) async {

  //       WidgetsBinding.instance.addPostFrameCallback((_) async{
  //         await Get.toNamed(AppString.eventView, arguments: 'event');
  //       });
  //       // WidgetsBinding.instance.addPostFrameCallback((_) {
  //       //   Navigator.pushNamed(context, AppString.accountView);
  //       // });


  //     }).onError((error) {
  //       if (kDebugMode) {
          
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    
    super.initState();

    Provider.of<ContractsBalance>(context, listen: false).setContext = context;

    Provider.of<MarketProvider>(context, listen: false).setBuildContext = context;

    Provider.of<ContractProvider>(context, listen: false).context = context;

    Provider.of<AppProvider>(context, listen: false).setContext = context;

    // Query Selendra Endpoint
    getSelendraEndpoint().then((value) async {

      await Provider.of<AppProvider>(context, listen: false).downloadFirstAsset().then((value) {
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        Provider.of<AppProvider>(context, listen: false).notifyListeners();
      });

      // ignore: use_build_context_synchronously
      await Provider.of<AppProvider>(context, listen: false).downloadSecondAsset();

      // ignore: use_build_context_synchronously
      Provider.of<MarketProvider>(context, listen: false).listMarketCoin();

      // ignore: use_build_context_synchronously
      Provider.of<ArticleProvider>(context, listen: false).requestArticle();

      // Assign Data and Store Endpoint Into Local DB
      // ignore: use_build_context_synchronously
      await Provider.of<ApiProvider>(context, listen: false).initSelendraEndpoint(await json.decode(value.body));

      // await initDynamicLinks();

      await initApi();

      // clearOldBtcAddr();
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // });

  }

  Future<void> initApi() async {

    try {

      final apiProvider = Provider.of<ApiProvider>(context, listen: false);

      final contractProvider = Provider.of<ContractProvider>(context, listen: false);

      contractProvider.setSavedList().then((value) async {
        /// Fetch and Fill Market Price Into Asset
        MarketProvider.fetchTokenMarketPrice();

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
          Provider.of<ContractProvider>(context, listen: false).getBtcAddr();

          await apiProvider.getAddressIcon();

          // Get From Keyring js
          // ignore: use_build_context_synchronously
          // await apiProvider.getCurrentAccount(context: context, funcName: 'keyring');
          // Get SEL Native Chain Will Fetch also Balance
          ContractsBalance.getAllAssetBalance();

        }
      });
    } catch (e) {
      
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
      
    }
  }
  
  Future<void> downloadAsset({required String fileName}) async {

    dir ??= (await getApplicationDocumentsDirectory()).path;

    // ignore: unrelated_type_equality_checks
    if ( await Directory("$dir/${fileName.replaceAll(".zip", "")}").exists() == false ){

      await downloadAssets(fileName).then((value) async {
        
        await Permission.storage.request().then((pm) async {
          if (pm.isGranted){
            await getApplicationDocumentsDirectory().then((dir) async {

              await AppUtils.archiveFile(await File("${dir.path}/$fileName").writeAsBytes(value.bodyBytes)).then((files) async {
                
                // await readFile(fileName);
              });
            });
          }
        });
        
      });

      // ignore: use_build_context_synchronously
      Provider.of<AppProvider>(context, listen: false).dirPath = dir;
      
    } else {
      
      // ignore: use_build_context_synchronously
      Provider.of<AppProvider>(context, listen: false).dirPath = dir;
      // await readFile(fileName);
    }

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously
    Provider.of<AppProvider>(context, listen: false).notifyListeners();
  }

  // clearOldBtcAddr() async {
  //   final res = await StorageServices.fetchData(DbKey.btcAddr);
  //   if (res != null) {
  //     await StorageServices.removeKey(DbKey.btcAddr);
  //   }
  // }

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
                  return MaterialApp(
                    navigatorKey: AppUtils.globalKey,
                    title: AppString.appName,
                    theme: AppStyle.myTheme(context),
                    onGenerateRoute: router.generateRoute,
                    routes: {
                      // HomePage.route: (_) => GoogleAuthService().handleAuthState(),
                      AppString.accountView: (_) => Account(
                        argument: ModalRoute.of(context)?.settings.arguments,
                      ),
                      AppString.homeView: (_) => const HomePage()
                    },
                    initialRoute: AppString.splashScreenView,
                    builder: (context, child) => ResponsiveWrapper.builder(
                      child,
                      maxWidth: 1200,
                      minWidth: 480,
                      defaultScale: true,
                      breakpoints: const [
                        ResponsiveBreakpoint.autoScale(600),
                        ResponsiveBreakpoint.resize(480, name: MOBILE),
                        ResponsiveBreakpoint.autoScale(800, name: TABLET),
                        ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      }
    );
    // ResponsiveSizer( 
    //   builder: (context, orientation, screenType) {
    //     return AnnotatedRegion(
    //       value: darkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    //       child: LayoutBuilder(
    //         builder: (builder, constraints) {
    //           return OrientationBuilder(
    //             builder: (context, orientation) {
    //               SizeConfig().init(constraints, orientation);
    //               return MaterialApp(
    //                 navigatorKey: AppUtils.globalKey,
    //                 title: AppString.appName,
    //                 theme: AppStyle.myTheme(context),
    //                 onGenerateRoute: router.generateRoute,
    //                 routes: {
    //                   HomePage.route: (_) => GoogleAuthService().handleAuthState() // HomePage(),
    //                 },
    //                 initialRoute: AppString.splashScreenView,
    //                 // builder: (context, widget) => ResponsiveWrapper.builder(
    //                 //   BouncingScrollWrapper.builder(context, widget!),
    //                 //   maxWidth: 1200,
    //                 //   // minWidth: 800,
    //                 //   defaultScale: true,
    //                 //   breakpoints: [
    //                 //     const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
    //                 //     const ResponsiveBreakpoint.autoScale(800, name: TABLET),
    //                 //     const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
    //                 //     const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
    //                 //   ],
    //                 // ),
    //               );
    //             },
    //           );
    //         },
    //       ),
    //     );
    //   }
    // );
  }
}