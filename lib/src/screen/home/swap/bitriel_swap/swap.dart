import 'dart:math';

import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/get_request.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';
import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/body_swap.dart';
import 'package:wallet_apps/src/screen/home/swap/confirm_swap.dart';
import 'package:http/http.dart' as _http;

Map m = {
	"is_float": false,
	"status": "wait",
	"coin_from": "BAT",
	"coin_to": "USDT",
	"deposit_amount": "360",
	"withdrawal": "0xe11175d356d20b70abcec858c6b82b226e988941",
	"withdrawal_extra_id": null,
	"return": "0xe11175d356d20b70abcec858c6b82b226e988941",
	"return_extra_id": null,
	"extra_fee_from": 0,
	"extra_fee_to": 0,
	"coin_from_network": "ERC20",
	"coin_to_network": "BEP20",
	"deposit": "0xae1F4085B8A5B0c4b9992926cdFfcCFE65896604",
	"deposit_extra_id": null,
	"withdrawal_amount": "99.02333403",
	"rate": "0.275064816750",
	"fee": "0",
	"revert": false,
	"transaction_id": "643e45813785c",
	"expired_at": 1681804425,
	"created_at": "2023-04-18 10:23:45",
	"execution_time": null,
	"is_available": true,
	"coin_from_explorer_url": "https:\/\/etherscan.io\/tx\/",
	"coin_to_explorer_url": "https:\/\/bscscan.com\/tx\/",
	"coin_from_icon": "https:\/\/letsexchange.s3.eu-central-1.amazonaws.com\/coins\/5651e7594769444e85f15aa097bd6327.svg",
	"coin_from_extra_name": null,
	"coin_to_icon": "https:\/\/letsexchange.s3.eu-central-1.amazonaws.com\/coins\/9a086127589d7c0279610e20bc0bfaac.svg",
	"coin_to_extra_name": null,
	"coin_from_name": "Basic Attention Token",
	"coin_to_name": "Tether USD",
	"need_confirmations": 0,
	"confirmations": 0,
	"email": null,
	"aml_error_signals": [],
	"bonus": 1.62
};

class SwapPage extends StatefulWidget {
  const SwapPage({ Key? key }) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {

  int count = 2;

  SwapProvider? _swapProvider;

  List<double> percentage = [
    0.25,
    0.50,
    0.75,
    1.00
  ];

  double calculateAmount(List<double> percentage, int index, double amount){
    double calculate = percentage[index] * amount;
    
    return calculate;

  }

  void percentTap(int index){

    setState(() {
      _swapProvider!.model.percentActive = index;
      // _swapProvider!.model.myController!.text = calculateAmount(percentage, _swapProvider!.model.percentActive! - 1, double.parse(_swapProvider!.balance1.replaceAll(RegExp('[^A-Za-z0-9]'), ""))).toString();
      _swapProvider!.model.myController!.text = calculateAmount(percentage, _swapProvider!.model.percentActive! - 1, double.parse(_swapProvider!.balance1.replaceAll(",", ""))).toStringAsFixed(5);
      _swapProvider!.model.cursor = _swapProvider!.model.myController!.text.length;
      setCursor();
    });
  }

  void onChanged(String value) async {
    print("hello chnage");
    // Timer.periodic(
    //   Duration(seconds: count),
    //   (Timer timer) {
    //     print("hello time");
    //     print(timer.tick);
    //   },
    // );
  }

  void onDeleteTxt() async {
    
    _swapProvider!.model.cursor = _swapProvider!.model.myController!.selection.base.offset;
    if (_swapProvider!.model.myController!.text.isNotEmpty){

      if (_swapProvider!.model.myController!.text.contains("0.")){
        if (_swapProvider!.model.myController!.text == "0."){
          _swapProvider!.model.myController!.text = _swapProvider!.model.myController!.text.replaceRange(0, _swapProvider!.model.myController!.text.length, "");
          _swapProvider!.model.cursor = _swapProvider!.model.cursor!-1;
        }
        else {
          _swapProvider!.model.myController!.text = _swapProvider!.model.myController!.text.replaceRange(_swapProvider!.model.cursor!-1, _swapProvider!.model.cursor!, "");
        }
      }
      else if (isCursorMove()){
        _swapProvider!.model.myController!.text = _swapProvider!.model.myController!.text.replaceRange(_swapProvider!.model.cursor!-1, _swapProvider!.model.cursor!, "");
      } 
      else {
        _swapProvider!.model.myController!.text = _swapProvider!.model.myController!.text.replaceRange(_swapProvider!.model.myController!.text.length-1, _swapProvider!.model.myController!.text.length, "");
        // setCursor();
      }
      _swapProvider!.model.cursor = _swapProvider!.model.cursor!-1;
      setCursor(newPos: _swapProvider!.model.cursor);
      
      // if (_swapProvider!.model.cursor != -1){
      //   _swapProvider!.model.myController!.selection = TextSelection.fromPosition(TextPosition(offset: _swapProvider!.model.cursor!-1));
      // }

    }
  }

  void onTabNum(String txt) async {
    _swapProvider!.model.cursor = _swapProvider!.model.myController!.selection.base.offset;

    if (checkCommaLength() == false && isMultiComma(txt) == false){
      if (_swapProvider!.model.myController!.text.isEmpty){

        if ( _swapProvider!.model.myController!.text.isEmpty && txt == "."){
          _swapProvider!.model.myController!.text += "0";
        }
        _swapProvider!.model.myController!.text += txt;
        _swapProvider!.model.cursor = _swapProvider!.model.myController!.text.length;

      } else {

        if (isCursorMove()){
          _swapProvider!.model.lsTmp = _swapProvider!.model.myController!.text.split("");
          _swapProvider!.model.lsTmp.insert(_swapProvider!.model.cursor!, txt);

          _swapProvider!.model.myController!.text = _swapProvider!.model.lsTmp.join();
        } 
        else {
          _swapProvider!.model.myController!.text += txt;
        }
        _swapProvider!.model.cursor = _swapProvider!.model.cursor!+1;
      }
    }

    setCursor(newPos: _swapProvider!.model.cursor);
  }
  

  void setCursor({ int? newPos}){

    _swapProvider!.model.myController!.selection = TextSelection.fromPosition(TextPosition(offset: newPos ?? _swapProvider!.model.myController!.text.length));
    _swapProvider!.model.cursor = _swapProvider!.model.myController!.text.length;
    setState(() { });
  }
  
  /* -- Validation -- */

  bool isCursorMove(){
    if (_swapProvider!.model.cursor == -1) return false;
    return _swapProvider!.model.cursor != _swapProvider!.model.length;
  }

  bool isMultiComma(String txt){
    
    for (int i = 0; i< _swapProvider!.model.myController!.text.length; i++){
      if (txt != ".") break;
      if (_swapProvider!.model.myController!.text[i] == "."){
        return true;
      }
    }
    return false;
  }

  bool checkCommaLength(){

    int dotPosition = _swapProvider!.model.myController!.text.indexOf(".");

    if (dotPosition != -1 && dotPosition != _swapProvider!.model.myController!.text.length) {
      // print(int.parse((_swapProvider!.model.myController!.text[dotPosition])));

      if ( (_swapProvider!.model.myController!.text.length - dotPosition) > 5){

        _swapProvider!.model.myController!.text = double.parse(_swapProvider!.model.myController!.text).toStringAsFixed(5);

        setState(() {});
      
        return true;
      }
    } 
    return false;
  }

  void resetCursor(){

    // When Input Over 2 number
    // if (_swapProvider!.model.myController!.selection.base.offset != -1){

    //   if( _swapProvider!.model.myController!.selection.base.offset != _swapProvider!.model.cursor){
    //     _swapProvider!.model.cursor = _swapProvider!.model.myController!.selection.base.offset;
    //   }
    //   else {
    //     _swapProvider!.model.cursor = _swapProvider!.model.cursor! - 1;
    //   }
    //   _swapProvider!.model.myController!.selection = TextSelection.fromPosition(TextPosition(offset: _swapProvider!.model.cursor!));
    // }

    // setState(() { });
  }

  Future<void> swapping() async {
    // print("Calling swapping function");
    try {

      dialogLoading(context);
      // _http.Response value = _http.Response(json.encode(m), 200);
      await PostRequest.swap(_swapProvider!.model.toJsonSwap(_swapProvider!, _swapProvider!.contractProvider!.ethAdd)).then((value) {
        if (value.statusCode == 200){
          // Close Dialog
          Navigator.pop(context);
          Navigator.push(context, Transition(child: ConfirmSwap(res: SwapResponseObj.fromJson(json.decode(value.body))),  transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        } else {
          throw Exception(json.decode(value.body)['error']);
        }
        
      });
      
    }
    on Exception catch (ex){
      print("Exception");
      // customDialog(context, "Error", "${ex}", txtButton: "Close").then((value) {
       
      // });
      // Close Dialog
      Navigator.pop(context);
      print(ex);
      
    } 
    catch (e) {
      // Close Dialog
      Navigator.pop(context);
      print("Something wrong $e");
    }

  }

  @override
  void initState() {

    _swapProvider = Provider.of<SwapProvider>(context, listen: false);
    _swapProvider!.contractProvider = Provider.of<ContractProvider>(context, listen: false);
    _swapProvider!.apiProvider = Provider.of<ApiProvider>(context, listen: false);

    coins().then((value) {
      _swapProvider!.lstCoins = List.from(json.decode(value.body));
    });
    
    _swapProvider!.initList(context: context);
    _swapProvider!.setList();

    _swapProvider!.model.myController!.addListener(() {

      print("fuck");

      // count = 0;
      
      _swapProvider!.model.length = _swapProvider!.model.myController!.text.length;
      if (_swapProvider!.model.focusNode!.hasFocus == false){
        FocusScope.of(context).requestFocus(_swapProvider!.model.focusNode!);
      }

      setState(() { });

    });

    AppServices.noInternetConnection(context: context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SwapPageBody(
      onChanged: onChanged,
      onDeleteTxt: onDeleteTxt,
      swapPageModel: _swapProvider!.model,
      percentTap: percentTap,
      onTabNum: onTabNum,
      calculateAmount: calculateAmount,
      swapping: swapping,
    );
  }
}