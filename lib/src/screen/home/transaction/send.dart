import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/search_p.dart';
import 'package:wallet_apps/src/screen/home/transaction/body_send.dart';

class Send extends StatefulWidget {
  const Send({ Key? key }) : super(key: key);

  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {

  SearchProvider? searchPro;

  void query(String value, Function mySetState){
    final lsContract = Provider.of<ContractProvider>(context, listen: false).sortListContract;
    searchPro!.setSearchedLs = lsContract.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    setState(() {
      
    });
  }

  @override
  void initState() {
    searchPro = Provider.of<SearchProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SendBody(query: query);
  }
}