import 'package:wallet_apps/index.dart';

class SwapModel {

  FlareControls? flareController = FlareControls();
  final GlobalKey<FormState> swapKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  TextEditingController? amountController;

  bool success = false, enableBtn = false;
}