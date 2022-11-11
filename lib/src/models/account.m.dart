
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/index.dart';
class AccountM {

  String? name;
  String? address;
  String? pubKey;
  String? addressIcon;

  KeyPairData? currentAcc;
  TextEditingController pinController = TextEditingController();
  TextEditingController oldPinController = TextEditingController();
  TextEditingController newPinController = TextEditingController();
  TextEditingController editNameController = TextEditingController();
  GlobalKey<FormState> editNameKey = GlobalKey<FormState>();
  GlobalKey<FormState> changePinKey = GlobalKey<FormState>();
  GlobalKey<FormState> backupKey = GlobalKey<FormState>();
  FocusNode pinNode = FocusNode();
  FocusNode oldNode = FocusNode();
  FocusNode newNode = FocusNode();

  bool loading = false;

  AccountM({this.name, this.address, this.pubKey, this.addressIcon});
}

