// import 'package:go_router/go_router.dart';
import 'package:bitriel_wallet/index.dart';

enum BitrielRouter {
  defaultRoute,
  welcomeRoute,
  multiAccRoute,
  importWalletRoute,
  createWalletRoute,
  walletRoute,
  homeRoute,
}

class AppRouter {
  
  static final Map<String, Widget Function(BuildContext)> router = {
    // "/": (context) => const SplashScreen(),
    "/": (context) => const WalletScreen(),
    "/${BitrielRouter.welcomeRoute}": (context) => const Welcome(),
    "/${BitrielRouter.multiAccRoute}": (context) => const MultiAccountScreen(),
    "/${BitrielRouter.createWalletRoute}": (context) => const CreateWalletScreen(),
    "/${BitrielRouter.importWalletRoute}": (context) => const ImportWalletScreen(),
    "/${BitrielRouter.walletRoute}": (context) => const WalletScreen(),
    "/${BitrielRouter.homeRoute}": (context) => const HomeScreen(),

  };
  //  = GoRouter(
  //   routes: [
  //     GoRoute(
  //       name: "welcome",
  //       path: "/",
  //       builder: (context, state) => const Welcome(),
  //     ),

  //     GoRoute(
  //       name: "createWallet",
  //       path: "/create-wallet",
  //       builder: (context, state) => const CreateWallet(),
  //     ),

  //     GoRoute(
  //       name: "importWallet",
  //       path: "/import-wallet",
  //       builder: (context, state) => const ImportWallet(),
  //     ),
  //   ]
  // );

  // GoRouter get router => _router;
}
// class AppRouter {
//   static final GoRouter _router = GoRouter(
//     routes: [
//       GoRoute(
//         name: "welcome",
//         path: "/",
//         builder: (context, state) => const Welcome(),
//       ),

//       GoRoute(
//         name: "createWallet",
//         path: "/create-wallet",
//         builder: (context, state) => const CreateWallet(),
//       ),

//       GoRoute(
//         name: "importWallet",
//         path: "/import-wallet",
//         builder: (context, state) => const ImportWallet(),
//       ),
//     ]
//   );

//   GoRouter get router => _router;
// }