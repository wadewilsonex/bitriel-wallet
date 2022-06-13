import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/constants/db_key_con.dart';
import 'package:wallet_apps/src/service/contract.dart';
import 'package:web3dart/web3dart.dart';

class Attendance extends ChangeNotifier {

  String _atdContract = "0xF3a8002d76Acff8162A95892f7d6C8a7963Eed26";

  DeployedContract? attDeployContract;

  ContractService? contractService;

  ContractProvider? _contractProvider;
  ApiProvider? _apiProvider;
  
  // Second Run
  Future<DeployedContract?> initAttContract({@required BuildContext? context}) async {
    _contractProvider = Provider.of<ContractProvider>(context!, listen: false);
    _apiProvider = Provider.of<ApiProvider>(context, listen: false);
    try {
      final String abiCode = await rootBundle.loadString(AppConfig.abiPath+'atd.json');
      final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'ATTToken'),
        EthereumAddress.fromHex(_atdContract),
      );

      notifyListeners();
      return contract;
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error initAttContract $e");
    }
    return null;
  }

  // Third Run
  Future<void> getChainDecimal({@required BuildContext? context, DeployedContract? deployedContract}) async {
    try {
      contractService = ContractService(_contractProvider!.bscClient, deployedContract!);
      BigInt decimal = await contractService!.getChainDecimal();
      _contractProvider!.listContract[_apiProvider!.attIndex].chainDecimal = decimal.toString();
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Error getChainDecimal $e");
    }
  }

  // First Run
  Future<double?> getAttBalance({@required BuildContext? context}) async {
    try {

      attDeployContract = await initAttContract(context: context);
      await getChainDecimal(context: context, deployedContract: attDeployContract);

      final myAddr = await StorageServices().readSecure(DbKey.ethAddr);
      if (myAddr != ''){
        final balance = await ContractProvider().query(
          _atdContract,
          'balanceOf',
          [EthereumAddress.fromHex(myAddr!)],
        ); //.balance = balance.toString();

        _contractProvider!.listContract[_apiProvider!.attIndex].balance = balance[0].toString();
        _contractProvider!.listContract[_apiProvider!.attIndex].lineChartModel = LineChartModel().prepareGraphChart(_contractProvider!.listContract[_apiProvider!.attIndex]);
        
        notifyListeners();
        return Fmt.bigIntToDouble(balance[0] as BigInt, int.parse(_contractProvider!.listContract[_apiProvider!.attIndex].chainDecimal!));
      }
    } catch (e) {
      if (ApiProvider().isDebug == true) print("Err checkBalanceAdd $e");
    }
    return null;
  }

} 