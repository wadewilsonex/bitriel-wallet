import 'package:wallet_apps/index.dart';

class ImportAccountModel {

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;
  ApiProvider? _api;

  Timer? _timer;

  String? loadingMgs;
  AnimationController? animationController;
  Animation<double>? animation;
  
  double? value = 0.0;
  String? average = "0/4";

}