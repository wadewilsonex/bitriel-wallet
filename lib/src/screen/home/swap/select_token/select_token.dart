import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/swap_p.dart';
import 'package:wallet_apps/src/screen/home/swap/select_token/body_select_token.dart';

class SelectSwapToken extends StatefulWidget {

  const SelectSwapToken({ Key? key}) : super(key: key);

  @override
  State<SelectSwapToken> createState() => _SelectSwapTokenState();
}

class _SelectSwapTokenState extends State<SelectSwapToken> {

  final TextEditingController _searchController = TextEditingController();
  SwapProvider? _swapProvider;

  @override
  initState(){
    
    Provider.of<SwapProvider>(context, listen: false).setList();
    super.initState();
  }
  
  @override
  dispose(){
    super.dispose();
  }

  void query(String? label, String value){
    print("query $value");
    _swapProvider = Provider.of<SwapProvider>(context, listen: false);
    _swapProvider!.searched = [];
    if (label == "first"){
      _swapProvider!.searched = _swapProvider!.ls.where((element) {
        element.subtitle!.toLowerCase();
        if ( element.subtitle!.toLowerCase().contains(value.toLowerCase()) == true){

          return element.subtitle!.toLowerCase().contains(value.toLowerCase());
        }
        else if (element.title!.toLowerCase().contains(value.toLowerCase())){

          return element.title!.toLowerCase().contains(value.toLowerCase());
        }
        return false;
      }).toList();
    } else {
      _swapProvider!.searched = _swapProvider!.ls2.where((element) => element.subtitle!.toLowerCase().contains(value.toLowerCase())).toList();

    }

    print("_swapProvider!.searched ${_swapProvider!.searched}");
    setState(() { });
    // mySetState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return SelectSwapTokenBody(
      searchController: _searchController,
      query: query
    );
  }
}