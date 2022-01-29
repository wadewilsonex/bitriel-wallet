import 'package:provider/provider.dart';
import 'package:wallet_apps/core/service/contract.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';

class ReceiveWallet extends StatefulWidget {
  //static const route = '/recievewallet';

  @override
  State<StatefulWidget> createState() {
    return ReceiveWalletState();
  }
}

class ReceiveWalletState extends State<ReceiveWallet> {
  
  GlobalKey<ScaffoldState>? _globalKey;
  final GlobalKey _keyQrShare = GlobalKey();

  final GetWalletMethod _method = GetWalletMethod();
  String name = 'username';
  String wallet = 'wallet address';
  int initialValue = 0;

  List<Map<String, dynamic>>? lsContractSymbol;

  @override
  void initState() {
    _globalKey = GlobalKey<ScaffoldState>();
    findSEL();
    name = Provider.of<ApiProvider>(context, listen: false).accountM.name!;
    wallet = Provider.of<ApiProvider>(context, listen: false).accountM.address!;

    AppServices.noInternetConnection(_globalKey!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    name = Provider.of<ApiProvider>(context, listen: false).accountM.name!;
    wallet = Provider.of<ApiProvider>(context, listen: false).accountM.address!;
    super.didChangeDependencies();
  }

  void findSEL(){
    print("findSEL");
    final listCon = Provider.of<ContractProvider>(context, listen: false).sortListContract;
    print(listCon);
    lsContractSymbol = ContractService.getConSymbol(listCon);
    for(int i = 0; i< lsContractSymbol!.length; i++){
      print(lsContractSymbol![i]);
      if (lsContractSymbol![i]['symbol'] == 'SEL (Testnet)'){
        print("True");
        initialValue = i;

        // name = Provider.of<ApiProvider>(context, listen: false).accountM.name!;
        // wallet = Provider.of<ApiProvider>(context, listen: false).accountM.address!;
        setState(() { });
        break;
      }
    }
  }

  void onChanged(String value) {
    print("On changed $value");
    setState(() {
      initialValue = int.parse(value);
    });

    changedEthAdd(value);
  }

  void changedEthAdd(String value) {
    if (lsContractSymbol![int.parse(value)]['symbol'] == 'BTC') {
      wallet = Provider.of<ApiProvider>(context, listen: false).btcAdd;
    } else if (lsContractSymbol![int.parse(value)]['symbol'] == 'SEL (Testnet)' || lsContractSymbol![int.parse(value)]['symbol'] == 'DOT'){
      wallet = Provider.of<ApiProvider>(context, listen: false).accountM.address!;
    } else {
      wallet = Provider.of<ContractProvider>(context, listen: false).ethAdd;
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: ReceiveWalletBody(
        keyQrShare: _keyQrShare,
        globalKey: _globalKey,
        method: _method,
        name: name,
        wallet: wallet,
        initialValue: initialValue,
        onChanged: onChanged,
      ),
    );
  }
}
