import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/receive_wallet_p.dart';
import 'package:wallet_apps/src/service/contract.dart';

class ReceiveWallet extends StatefulWidget {
  //static const route = '/recievewallet';

  @override
  State<StatefulWidget> createState() {
    return ReceiveWalletState();
  }
}

class ReceiveWalletState extends State<ReceiveWallet> {

  ReceiveWalletProvider? provider;

  @override
  void initState() {
    provider = Provider.of<ReceiveWalletProvider>(context, listen: false);
    provider!.globalKey = GlobalKey<ScaffoldState>();

    findSEL();

    AppServices.noInternetConnection(provider!.globalKey!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // name = Provider.of<ApiProvider>(context, listen: false).accountM.name!;
    // wallet = Provider.of<ApiProvider>(context, listen: false).accountM.address!;
    super.didChangeDependencies();
  }

  void findSEL(){

    // final listCon = Provider.of<ContractProvider>(context, listen: false).sortListContract;
    // for(int i = 0; i< listCon.length; i++){
    //   if (listCon[i].symbol == 'SEL'){
    //     initialValue = i;
    //     setState(() { });
    //     break;
    //   }
    // }
    final listCon = Provider.of<ContractProvider>(context, listen: false).sortListContract;
    provider!.lsContractSymbol = ContractService.getConSymbol(context, listCon);
    for(int i = 0; i< provider!.lsContractSymbol!.length; i++){
      print(provider!.lsContractSymbol![i]);
      if (provider!.lsContractSymbol![i]['symbol'] == 'SEL (Testnet)'){
        provider!.initialValue = i;
        setState(() { });
        break;
      }
    }
  }

  void onChanged(String value) {
    setState(() {
      provider!.initialValue = int.parse(value);
    });

    changedEthAdd(value);
  }

  void changedEthAdd(String value) {
    // wallet = Provider.of<ContractProvider>(context, listen: false).sortListContract[int.parse(value)].address;
    if (provider!.lsContractSymbol![int.parse(value)]['symbol'] == 'BTC') {
      provider!.accountM!.address = Provider.of<ApiProvider>(context, listen: false).btcAdd;
    } else if (provider!.lsContractSymbol![int.parse(value)]['symbol'] == 'SEL (Testnet)' || provider!.lsContractSymbol![int.parse(value)]['symbol'] == 'DOT'){
      provider!.accountM!.address = Provider.of<ApiProvider>(context, listen: false).accountM.address!;
    } else {
      provider!.accountM!.address = Provider.of<ContractProvider>(context, listen: false).ethAdd;
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: provider!.globalKey,
      body: ReceiveWalletBody(
        onChanged: onChanged,
      ),
    );
  }
}
