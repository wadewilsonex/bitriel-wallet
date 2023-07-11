// import 'package:go_router/go_router.dart';

import '../../../index.dart';

class AppRouter {
  static final Map<String, Widget Function(BuildContext)> router = {
    "/": (context) => const HomeScreen()
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