import 'package:wallet_apps/index.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';

class ImportAccAnimationModel {

  bool? status;
  int? currentVersion;
  bool? enable = false;
  String? tempMnemonic;
  bool? isAddNew = false;
  ApiProvider? _api;

  Timer? _timer;

  String? loadingMgs;
  AnimationController? animationController;
  Animation<double>? animation;
  
  double? value = 0.0;
  String? average = "0/4";

}

class ImportAccModel {

  BuildContext? context;

  ApiProvider? apiProvider;
  KeyType? keyType;
  
  /// Key means "Seeds, KeyStore(Json), Raw"
  TextEditingController? usrName= TextEditingController();
  TextEditingController? key= TextEditingController();
  TextEditingController? pwCon= TextEditingController();
  FocusNode? usrNameNode= FocusNode();
  FocusNode? keyNode= FocusNode();
  FocusNode? pwNode= FocusNode();

  set setBuildContext (BuildContext ct) {
    context = ct;
  }

  BuildContext? get getBuildCt => context;

  void initImportState({required ApiProvider? apiPro, KeyType? keyTp = KeyType.mnemonic}){

    apiProvider = apiPro;
    keyType = keyTp;

    usrName = TextEditingController(text: 'User');
    key = TextEditingController();
    pwCon = TextEditingController();
    
    usrNameNode = FocusNode();
    keyNode = FocusNode();
    pwNode = FocusNode();
  }
}