import 'package:wallet_apps/index.dart';

class SwapModel {

  FlareControls? flareController = FlareControls();
  final GlobalKey<FormState> swapKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  TextEditingController? amountController;

  bool success = false, enableBtn = false;
}

class SwapPageModel {

  String str = "123456";
  List<String> lsTmp = [];
  int? percentActive = 0;
  int? length;
  int? cursor = -1;
  bool? isCursor = false;
  TextEditingController? myController = TextEditingController();
  FocusNode? focusNode = FocusNode();
}