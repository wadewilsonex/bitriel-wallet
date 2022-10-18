

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/explorer/selendra_explorer/body_selendra_explorer.dart';

class SelendraExplorer extends StatefulWidget {
  const SelendraExplorer({Key? key}) : super(key: key);

  @override
  State<SelendraExplorer> createState() => _SelendraExplorerState();
}

class _SelendraExplorerState extends State<SelendraExplorer> {

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelendraExplorerBody(
      controller: controller
    );
  }
}