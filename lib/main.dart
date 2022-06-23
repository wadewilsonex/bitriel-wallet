import 'package:provider/provider.dart';
import 'package:wallet_apps/app.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/walletConnect_c.dart';
import 'package:wallet_apps/src/provider/atd_pro.dart';
import 'package:wallet_apps/src/provider/presale_p.dart';
import 'package:wallet_apps/src/provider/airdrop_p.dart';
import 'package:wallet_apps/src/provider/provider.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/provider/search_p.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Catch Error During Callback
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletProvider>(
          create: (context) => WalletProvider(),
        ),
        ChangeNotifierProvider<MarketProvider>(
          create: (context) => MarketProvider(),
        ),
        ChangeNotifierProvider<ApiProvider>(
          create: (context) => ApiProvider(),
        ),
        ChangeNotifierProvider<ContractProvider>(
          create: (context) => ContractProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<PresaleProvider>(
          create: (context) => PresaleProvider(),
        ),
        ChangeNotifierProvider<Attendance>(
          create: (context) => Attendance(),
        ),
        ChangeNotifierProvider<AirDropProvider>(
          create: (context) => AirDropProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider<SwapProvider>(
          create: (context) => SwapProvider(),
        ),
        ChangeNotifierProvider<ReceiveWalletProvider>(
          create: (context) => ReceiveWalletProvider(),
        ),
        ChangeNotifierProvider<WalletConnectComponent>(
          create: (context) => WalletConnectComponent(),
        ),
        ChangeNotifierProvider<ContractsBalance>(
          create: (context) => ContractsBalance(),
        ),
      ],
      child: App(),
    ),
  );
}