class Validator {

  static String? _text;

  static String? seedValidator(String? value){
    if (value!.isEmpty) {
      _text = "Please fill your twelve seeds";
    }
    else if (value.split(" ").toList().length != 12 || value.split(" ").toList().last == "") {
      _text = "Invalid seeds";
    } else {
      _text = null;
    }
    return _text;
  }

  static bool? swapValidator(String coin1, String coin2, String amt){
    
    if (coin1.isNotEmpty && coin2.isNotEmpty && amt.isNotEmpty ) return true;
    return false;
  }
}