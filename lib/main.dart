import 'package:wallet_apps/app.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/airdrop_p.dart';
import 'package:wallet_apps/src/provider/atd_pro.dart';
import 'package:wallet_apps/src/provider/presale_p.dart';
import 'package:wallet_apps/src/provider/search_p.dart';
import 'package:wallet_apps/src/provider/transaction_p.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await initHiveForFlutter();

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
        ChangeNotifierProvider<TrxProvider>(
          create: (context) => TrxProvider(),
        ),
      ],
      child: App(),
    ),
  );
}
