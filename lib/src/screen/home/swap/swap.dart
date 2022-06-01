import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/swap/body_swap.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({ Key? key }) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  @override
  Widget build(BuildContext context) {
    return SwapPageBody();
  }
}