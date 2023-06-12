import 'package:bitriel_wallet/presentation/auth/create_wallet/bloc_create.dart';
import 'package:bitriel_wallet/presentation/auth/import_wallet/bloc_import.dart';
import 'package:bitriel_wallet/presentation/welcome_ui.dart';
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