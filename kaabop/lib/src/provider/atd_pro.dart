import 'package:wallet_apps/index.dart';
import 'package:web3dart/web3dart.dart';

class Attendance extends ChangeNotifier {

  String _atdContract = "0xF3a8002d76Acff8162A95892f7d6C8a7963Eed26";

  DeployedContract attDeployContract;
  
  Future<DeployedContract> initPresaleContract() async {
    try {
      final String abiCode = await rootBundle.loadString('assets/abi/atd.json');
      final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'ATTToken'),
        EthereumAddress.fromHex(_atdContract),
      );

      notifyListeners();
      return contract;
    } catch (e) {
      print("Error init presale contract $e");
    }
    return null;
  }

  Future<double> checkBalanceAdd({@required BuildContext context}) async {
    try {

      final contractPro = Provider.of<ContractProvider>(context, listen: false);

      // print(contractPro.listContract.length);

      attDeployContract = await initPresaleContract();

      final myAddr = await StorageServices().readSecure('etherAdd');
      if (myAddr != null){
        final balance = await ContractProvider().query(
          _atdContract,
          'balanceOf',
          [EthereumAddress.fromHex(myAddr)],
        ); //.balance = balance.toString();

        contractPro.listContract[7].balance = balance[0].toString();
        contractPro.listContract[7].lineChartModel = LineChartModel().prepareGraphChart(contractPro.listContract[7]);
        
        notifyListeners();
        return Fmt.bigIntToDouble(balance[0] as BigInt, 18);
      }
    } catch (e) {
      print("Err checkBalanceAdd $e");
    }
  }

} 