import 'package:wallet_apps/index.dart';

class ModelUserInfo {
  final formStateAddUserInfo = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic>? userData, res;

  bool? switchBio;

  bool enable = false;

  FocusNode nodeFirstName = FocusNode();
 


  TextEditingController userNameCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController confirmPasswordCon = TextEditingController();


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
