import 'index.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const App());
}