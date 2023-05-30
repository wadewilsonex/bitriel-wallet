import 'package:bitriel_wallet/features/create_wallet/presentation/pages/create_wallet.dart';
import 'package:bitriel_wallet/features/import_wallet/presentation/pages/import_wallet.dart';
import 'package:bitriel_wallet/features/welcome/presentation/pages/welcome.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        name: "welcome",
        path: "/",
        builder: (context, state) => const Welcome(),
      ),

      GoRoute(
        name: "createWallet",
        path: "/create-wallet",
        builder: (context, state) => const CreateWallet(),
      ),

      GoRoute(
        name: "importWallet",
        path: "/import-wallet",
        builder: (context, state) => const ImportWallet(),
      ),
    ]
  );

  GoRouter get router => _router;
}