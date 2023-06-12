import 'package:bitriel_wallet/domain/state_n_provider/app_p.dart';
import 'package:bitriel_wallet/application/utils/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {

    // Provider.of<AppProvider>(context, listen: false).downloadFirstAsset();
    
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationParser: AppRouter().router.routeInformationParser,
      routeInformationProvider: AppRouter().router.routeInformationProvider,
      routerDelegate: AppRouter().router.routerDelegate,
    );
  }
}
