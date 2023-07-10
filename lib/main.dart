import 'package:bitriel_wallet/data/repository/market_repo/market_repo.dart';

import 'index.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AssetProvider>(
          create: (context) => AssetProvider(),
        ),
        ChangeNotifierProvider<SDKProvier>(
          create: (context) => SDKProvier(),
        ),
        ChangeNotifierProvider<MarketProvider>(
          create: (context) => MarketProvider(),
        ),
      ],
      child: const App()
    )
  );
}

