import 'package:wallet_apps/index.dart';

class EmailModel {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get getFmKey => _formKey;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  
}