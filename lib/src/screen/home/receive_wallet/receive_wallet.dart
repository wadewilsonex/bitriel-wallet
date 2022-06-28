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

  String? symbol;

  String? ethAddr;

  @override
  void initState() {
    provider = Provider.of<ReceiveWalletProvider>(context, listen: false);
    provider!.initialValue = 0;
    provider!.globalKey = GlobalKey<ScaffoldState>();
    symbol = ApiProvider().isMainnet ? 'SEL (Selendra Chain)': 'SEL (Testnet)';
    ethAddr = Provider.of<ContractProvider>(context, listen: false).getEtherAddress;
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
    List<SmartContractModel> listCon = Provider.of<ContractProvider>(context, listen: false).sortListContract;
    provider!.lsContractSymbol = ContractService.getConSymbol(context, listCon);
    for(int i = 0; i< provider!.lsContractSymbol!.length; i++){
      if (provider!.lsContractSymbol![i]['symbol'] == symbol){
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
    if (provider!.lsContractSymbol![int.parse(value)]['symbol'] == 'BTC') {
      provider!.accountM!.address = Provider.of<ContractProvider>(context, listen: false).listContract[ApiProvider().btcIndex].address;
    } else if (provider!.lsContractSymbol![int.parse(value)]['symbol'] == symbol || provider!.lsContractSymbol![int.parse(value)]['symbol'] == 'DOT'){
      provider!.accountM!.address = Provider.of<ApiProvider>(context, listen: false).getAccount.address!;
    } else {
      provider!.accountM!.address = ethAddr;
    }
    provider!.notifyListeners();
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
