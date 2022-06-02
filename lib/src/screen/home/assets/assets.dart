import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/assets/body_asset.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({ Key? key }) : super(key: key);

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  @override
  Widget build(BuildContext context) {
    return AssetsPageBody();
  }
}