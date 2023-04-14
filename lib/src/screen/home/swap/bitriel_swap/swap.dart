import 'package:get_storage/get_storage.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/backend/post_request.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';
import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/body_swap.dart';
import 'package:wallet_apps/src/screen/home/swap/confirm_swap.dart';
import 'package:http/http.dart' as _http;

class SwapPage extends StatefulWidget {
  const SwapPage({ Key? key }) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {

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

  void onChanged(String value){
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
    print("Calling swapping function");
    try {

      dialogLoading(context);
      print("_swapProvider!.model.toJsonSwap(_swapProvider!, _swapProvider!.contractProvider!.ethAdd) ${_swapProvider!.model.toJsonSwap(_swapProvider!, _swapProvider!.contractProvider!.ethAdd)}");
      await PostRequest.swap(_swapProvider!.model.toJsonSwap(_swapProvider!, _swapProvider!.contractProvider!.ethAdd)).then((value) {
        print("value ${value.body}");
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
    
    _swapProvider!.initList(context: context);
    _swapProvider!.setList();

    _swapProvider!.model.myController!.addListener(() {
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
    // _swapProvider!.model.myController!.clear();
    // _swapProvider!.dispose();
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