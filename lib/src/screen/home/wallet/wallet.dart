

import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/search_p.dart';
import 'package:wallet_apps/src/screen/home/wallet/wallet_body.dart';

class Wallet extends StatefulWidget {
  const Wallet({ Key? key }) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  SearchProvider? searchPro;

  void query(String value, Function mySetState){
    final lsContract = Provider.of<ContractProvider>(context, listen: false).sortListContract;
    searchPro!.setSearchedLs = lsContract.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    mySetState(() { });
  }

  @override
  initState(){
    super.initState();
    searchPro = Provider.of<SearchProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WalletBody(query: query);
  }
}