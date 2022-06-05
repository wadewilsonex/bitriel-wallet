import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/swap_m.dart';
import 'package:wallet_apps/src/screen/home/swap/body_swap.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({ Key? key }) : super(key: key);

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {

  SwapPageModel _model = SwapPageModel();

  void percentTap(int index){

    setState(() {
      _model.percentActive = index;
    });
  }

  void onChanged(String value){ }

  void onDeleteTxt(String txt) async {

    print("${_model.myController!.selection.base}");
    print("${_model.myController!.text}");

    await Future.delayed(Duration(milliseconds: 50), (){

      setState(() {
        
        if (_model.myController!.text != "0") {
          _model.myController!.text = _model.myController!.text.substring(0, _model.myController!.text.length - 1);

          _model.length = _model.myController!.text.length;
          _model.cursor = _model.myController!.selection.base.offset;

          // Remove Cursor
          if (_model.myController!.selection.base != (_model.myController!.text.length-1)){
            _model.myController!.text.replaceRange(_model.cursor!-1, _model.cursor!-1, "");
          }
        }
      });
    });
    print("_model.myController!.text.isEmpty) _model.myController!.text ${_model.myController!.text.isEmpty}");
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SwapPageBody(
      onChanged: onChanged,
      onDeleteTxt: onDeleteTxt,
      swapPageModel: _model,
      percentTap: percentTap,
    );
  }
}