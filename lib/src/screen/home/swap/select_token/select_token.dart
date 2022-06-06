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

  @override
  initState(){
    
    Provider.of<SwapProvider>(context, listen: false).setList();
    super.initState();
  }
  
  @override
  dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectSwapTokenBody(
      searchController: _searchController,
    );
  }
}