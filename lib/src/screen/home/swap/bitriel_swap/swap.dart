import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';
import 'package:wallet_apps/src/screen/home/swap/bitriel_swap/body_swap.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({ Key? key }) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {

  final SwapPageModel _model = SwapPageModel();

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
      _model.percentActive = index;
      // _model.myController!.text = calculateAmount(percentage, _model.percentActive! - 1, double.parse(_swapProvider!.balance1.replaceAll(RegExp('[^A-Za-z0-9]'), ""))).toString();
      _model.myController!.text = calculateAmount(percentage, _model.percentActive! - 1, double.parse(_swapProvider!.balance1.replaceAll(",", ""))).toStringAsFixed(5);
      _model.cursor = _model.myController!.text.length;
      setCursor();
    });
  }

  void onChanged(String value){
  }

  void onDeleteTxt() async {
    
    _model.cursor = _model.myController!.selection.base.offset;
    if (_model.myController!.text.isNotEmpty){

      if (_model.myController!.text.contains("0.")){
        if (_model.myController!.text == "0."){
          _model.myController!.text = _model.myController!.text.replaceRange(0, _model.myController!.text.length, "");
          _model.cursor = _model.cursor!-1;
        }
        else {
          _model.myController!.text = _model.myController!.text.replaceRange(_model.cursor!-1, _model.cursor!, "");
        }
      }
      else if (isCursorMove()){
        _model.myController!.text = _model.myController!.text.replaceRange(_model.cursor!-1, _model.cursor!, "");
      } 
      else {
        _model.myController!.text = _model.myController!.text.replaceRange(_model.myController!.text.length-1, _model.myController!.text.length, "");
        // setCursor();
      }
      _model.cursor = _model.cursor!-1;
      setCursor(newPos: _model.cursor);
      
      // if (_model.cursor != -1){
      //   _model.myController!.selection = TextSelection.fromPosition(TextPosition(offset: _model.cursor!-1));
      // }

    }
  }

  void onTabNum(String txt) async {
    _model.cursor = _model.myController!.selection.base.offset;

    if (checkCommaLength() == false && isMultiComma(txt) == false){
      if (_model.myController!.text.isEmpty){

        if ( _model.myController!.text.isEmpty && txt == "."){
          _model.myController!.text += "0";
        }
        _model.myController!.text += txt;
        _model.cursor = _model.myController!.text.length;

      } else {

        if (isCursorMove()){
          _model.lsTmp = _model.myController!.text.split("");
          _model.lsTmp.insert(_model.cursor!, txt);

          _model.myController!.text = _model.lsTmp.join();
        } 
        else {
          _model.myController!.text += txt;
        }
        _model.cursor = _model.cursor!+1;
      }
    }

    setCursor(newPos: _model.cursor);
  }
  

  void setCursor({ int? newPos}){
    _model.myController!.selection = TextSelection.fromPosition(TextPosition(offset: newPos ?? _model.myController!.text.length));
    _model.cursor = _model.myController!.text.length;
    setState(() { });
  }
  
  /* -- Validation -- */

  bool isCursorMove(){
    if (_model.cursor == -1) return false;
    return _model.cursor != _model.length;
  }

  bool isMultiComma(String txt){
    
    for (int i = 0; i< _model.myController!.text.length; i++){
      if (txt != ".") break;
      if (_model.myController!.text[i] == "."){
        return true;
      }
    }
    return false;
  }

  bool checkCommaLength(){

    int dotPosition = _model.myController!.text.indexOf(".");

    if (dotPosition != -1 && dotPosition != _model.myController!.text.length) {
      // print(int.parse((_model.myController!.text[dotPosition])));

      if ( (_model.myController!.text.length - dotPosition) > 5){

        _model.myController!.text = double.parse(_model.myController!.text).toStringAsFixed(5);

        setState(() {});
      
        return true;
      }
    } 
    return false;
  }

  void resetCursor(){

    // When Input Over 2 number
    // if (_model.myController!.selection.base.offset != -1){

    //   if( _model.myController!.selection.base.offset != _model.cursor){
    //     _model.cursor = _model.myController!.selection.base.offset;
    //   }
    //   else {
    //     _model.cursor = _model.cursor! - 1;
    //   }
    //   _model.myController!.selection = TextSelection.fromPosition(TextPosition(offset: _model.cursor!));
    // }

    // setState(() { });
  }

  @override
  void initState() {

    _swapProvider = Provider.of<SwapProvider>(context, listen: false);
    _swapProvider!.contractProvider = Provider.of<ContractProvider>(context, listen: false);
    _swapProvider!.apiProvider = Provider.of<ApiProvider>(context, listen: false);
    
    _swapProvider!.initList(context: context);
    _swapProvider!.setList();

    _model.myController!.addListener(() {
      _model.length = _model.myController!.text.length;
      if (_model.focusNode!.hasFocus == false){
        FocusScope.of(context).requestFocus(_model.focusNode!);
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
      swapPageModel: _model,
      percentTap: percentTap,
      onTabNum: onTabNum,
      calculateAmount: calculateAmount,
    );
  }
}