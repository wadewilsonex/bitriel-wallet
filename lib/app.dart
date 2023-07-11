import 'index.dart';

class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {

    Provider.of<AssetProvider>(context, listen: false).downloadFirstAsset();

    Provider.of<SDKProvier>(context, listen: false).connectNetwork();

    Provider.of<MarketProvider>(context, listen: false).listMarketCoin();
    
    return MaterialApp(
      title: 'Bitriel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: hexaCodeToColor(AppColors.white), 
          background: hexaCodeToColor(AppColors.white),
        ),
        useMaterial3: true,
        fontFamily: 'TitilliumWeb',
      ),
      // routeInformationParser: AppRouter().router.routeInformationParser,
      // routeInformationProvider: AppRouter().router.routeInformationProvider,
      // routerDelegate: AppRouter().router.routerDelegate,
      routes: AppRouter.router,
      initialRoute: "/",
    );
  }
}
