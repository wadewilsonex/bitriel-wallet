import 'package:wallet_apps/index.dart';
import 'body_multiple_wallet.dart';

class MultipleWallets extends StatefulWidget {
  const MultipleWallets({Key? key}) : super(key: key);

  @override
  State<MultipleWallets> createState() => _MultipleWalletsState();
}

class _MultipleWalletsState extends State<MultipleWallets> {
  @override
  Widget build(BuildContext context) {
    return const BodyMultipleWallets();
  }
}