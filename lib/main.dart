import 'index.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AssetProvider>(
          create: (context) => AssetProvider(),
        ),
        ChangeNotifierProvider<ImportWalletProvider>(
          create: (context) => ImportWalletProvider(),
        ),
        ChangeNotifierProvider<SDKProvier>(
          create: (context) => SDKProvier(),
        ),
      ],
      child: const App()
    )
  );
}

