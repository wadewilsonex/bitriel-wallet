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
        ChangeNotifierProvider<WalletProvider>(
          create: (context) => WalletProvider(),
        ),
      ],
      child: const App()
    )
  );
}

