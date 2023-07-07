import 'package:bitriel_wallet/standalone/utils/app_utils/global.dart';
import 'package:bitriel_wallet/standalone/utils/themes/colors.dart';

import 'index.dart';

class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AssetProvider>(context, listen: false).downloadFirstAsset();
    
    return MaterialApp(
      title: 'Bitriel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: hexaCodeToColor(AppColors.white), 
          background: hexaCodeToColor(AppColors.white)
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
