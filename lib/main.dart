import 'index.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AssetProvider>(
          create: (context) => AssetProvider(),
        ),
      ],
      child: const App()
    )
  );
}