import 'package:bitriel_wallet/presentation/auth/passcode/ui_passcode.dart';
import 'package:flutter/material.dart';

class Pincode extends StatefulWidget {
  const Pincode({Key? key,}) : super(key: key);

  @override
  PincodeState createState() => PincodeState();
}

class PincodeState extends State<Pincode> {

  // Number Pin Pad
  final List<int> _numFirstRow = [1, 2, 3], _numSecRow = [4, 5 ,6], _numThirdRow = [7, 8, 9];

  final int _pinLength = 4;
  String _pinEntered = "";

  _numberClicked(int item) {
    _pinEntered = _pinEntered + item.toString();

    setState(() {});
  }

  _backSpace() {
    if(_pinEntered.isNotEmpty) {
      _pinEntered = _pinEntered.substring(0, _pinEntered.length - 1);
    }

    setState(() {});
  }

  // Confirm Verify PIN
  late bool _isFirst;
  String? _firstPin;


  Future<void> _setVerifyPin(String pin) async {
    if(_firstPin == null) {
      _firstPin = pin;

      setState(() {
        _isFirst = false;
        _pinEntered = "";
      });

    }
  }

  Future<void> _pinSetup() async {
    if (_pinEntered.length == _pinLength) {

      await _setVerifyPin(_pinEntered);
      
    }

  }
  
  @override
  void initState() {
    _isFirst = true;
    super.initState();
  }

  @override
  void dispose() {
    _isFirst = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PincodeBody(
      isFirst: _isFirst,
      pinLength: _pinLength,
      pinEntered: _pinEntered,
      numFirstRow: _numFirstRow,
      numSecRow: _numSecRow,
      numThirdRow: _numThirdRow,
      numberClicked: _numberClicked,
      backSpace: _backSpace,
      pinSetup: _pinSetup
    );
  }
}
