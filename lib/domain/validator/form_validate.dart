class FormValidator {

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
}