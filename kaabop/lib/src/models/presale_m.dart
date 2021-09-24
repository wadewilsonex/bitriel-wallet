import 'package:wallet_apps/index.dart';

class PresaleModel {

  FlareControls flareController = FlareControls();
  final GlobalKey<FormState> presaleKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  TextEditingController amountController = TextEditingController();

  bool success = false, enableBtn = false;

  String rate = "10";
  int rateIndex = 1;

  bool canSubmit = false;

  // Property for support token
  
}