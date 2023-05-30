import 'package:bitriel_wallet/utils/routes/router.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
