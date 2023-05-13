import 'package:wallet_apps/index.dart';

class ModelUserInfo {

  /// msg: used for validate and show in dialog disable pwd
  String? msg;
  
  final formStateAddUserInfo = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? userData, res;

  bool? switchBio;

  bool enable = false;

  FocusNode nodeFirstName = FocusNode();
 

  TextEditingController userNameCon = TextEditingController();
  TextEditingController oldPwdCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController confirmPasswordCon = TextEditingController();
  TextEditingController changePasswordCon = TextEditingController();

  FocusNode oldPwdNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  /* File image from picker */
  File? file;

  bool isImage = false;
  bool isValidate = false;
  bool isProgress = false;
  bool isUploading = false;

  Map<String, dynamic> fetchEmail = {};
}
