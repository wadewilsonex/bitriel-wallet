import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/main/verify_key/verify_key_body.dart';


class VerifyPassphrase extends StatefulWidget {

  final String? seed;
  
  VerifyPassphrase({this.seed});

  @override
  State<VerifyPassphrase> createState() => _VerifyPassphraseState();
}

class _VerifyPassphraseState extends State<VerifyPassphrase> {

  final TextEditingController passphraseController = TextEditingController();

  List<String>? _lsSeed = [];

  // Random 3 Each Number
  String? _rd1, _rd2, _rd3;


  @override
  void initState() {

    _splitSeed();
    _randomThreeEachNumber();
    super.initState();
  }

  void _randomThreeEachNumber(){
    _rd1 = Random().nextInt(12).toString();
    while(_rd1 == "0"){
      _rd1 = Random().nextInt(12).toString();
    }
    _rd2 = Random().nextInt(12).toString();
    
    while(_rd2 == _rd1 || _rd2 == "0"){
      _rd2 = Random().nextInt(12).toString();
      if (_rd2 != _rd1) break;
    }
    _rd3 = Random().nextInt(12).toString();
    while(_rd3 == _rd1 || _rd3 == _rd2 || _rd3 == "0"){
      _rd3 = Random().nextInt(12).toString();
      if (_rd2 != _rd1 && _rd3 != _rd2) break;
    }

    setState(() { });
  }
  

  void _splitSeed(){
    _lsSeed = widget.seed!.split(" ");
    print("_splitSeed $_lsSeed");
  }

  @override
  Widget build(BuildContext context) {
    return VerifyPassphraseBody(
      rd1: _rd1,
      rd2: _rd2,
      rd3: _rd3,
      seed: widget.seed!,
    );
  }
}
