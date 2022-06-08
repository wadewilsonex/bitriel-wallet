import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';
import 'package:wallet_apps/src/screen/home/swap/body_swap.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({ Key? key }) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {

  SwapPageModel _model = SwapPageModel();

  SwapProvider? _swapProvider;
  ContractProvider? _contractProvider;

  void percentTap(int index){

    setState(() {
      _model.percentActive = index;
    });
  }

  void onChanged(String value){
  }

  void onDeleteTxt() async {
    
    _model.cursor = _model.myController!.selection.base.offset;
    if (_model.myController!.text.isNotEmpty){

      if (_model.myController!.text.contains("0.")){
        print("onDeleteTxt ${_model.myController!.text.length}");
        print(_model.myController!.text == "0.");
        if (_model.myController!.text == "0."){
          _model.myController!.text = _model.myController!.text.replaceRange(0, _model.myController!.text.length, "");
          _model.cursor = _model.cursor!-1;
        }
        else  
          _model.myController!.text = _model.myController!.text.replaceRange(_model.cursor!-1, _model.cursor!, "");
      }
      else if (isCursorMove()){
        print("Start delete on cursor");
        _model.myController!.text = _model.myController!.text.replaceRange(_model.cursor!-1, _model.cursor!, "");
      } 
      else {
        _model.myController!.text = _model.myController!.text.replaceRange(_model.myController!.text.length-1, _model.myController!.text.length, "");
        // setCursor();
      }
      _model.cursor = _model.cursor!-1;
      print("new _model.cursor ${_model.cursor}");
      setCursor(newPos: _model.cursor);
      
      // if (_model.cursor != -1){
      //   _model.myController!.selection = TextSelection.fromPosition(TextPosition(offset: _model.cursor!-1));
      // }

    }
    print("onDeleteTxt _model.cursor ${_model.cursor}");
  }
  void onTabNum(String txt) async {
    print("_model.myController!.selection.base.offset ${_model.myController!.selection.base.offset}");
    _model.cursor = _model.myController!.selection.base.offset;
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

        _model.myController!.text = _model.lsTmp.join();;
      } 
      else {
        _model.myController!.text += txt;
      }
      _model.cursor = _model.cursor!+1;
    }
    setCursor(newPos: _model.cursor);
    // resetCursor();

    // await Future.delayed(Duration(milliseconds: 50), (){

    //   setState(() {
        
    //     if (_model.myController!.text != "0") {
    //       _model.myController!.text = _model.myController!.text.substring(0, _model.myController!.text.length - 1);

    //       // Remove Cursor
    //       // if (_model.myController!.selection.base != (_model.myController!.text.length-1)){
    //       //   _model.myController!.text.replaceRange(_model.cursor!-1, _model.cursor!-1, "");
    //       // }
    //     }
    //   });
    // });
  }

  void setCursor({ int? newPos}){
    print("setCursor _model.cursor ${_model.cursor}");
    _model.myController!.selection = TextSelection.fromPosition(TextPosition(offset: newPos ?? _model.myController!.text.length));
    _model.cursor = _model.myController!.text.length;;
    setState(() { });
  }
  
  bool isCursorMove(){

    print("_model.length ${_model.length}");
    print("_model.cursor ${_model.cursor}");
    if (_model.cursor == -1) return false;
    return _model.cursor != _model.length;
  }

  void resetCursor(){
    print("selection.base.offset ${_model.myController!.selection.base.offset}");

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

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SwapPageBody(
      onChanged: onChanged,
      onDeleteTxt: onDeleteTxt,
      swapPageModel: _model,
      percentTap: percentTap,
      onTabNum: onTabNum,
    );
  }
}