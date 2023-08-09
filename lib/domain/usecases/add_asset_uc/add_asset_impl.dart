import 'package:bitriel_wallet/index.dart';
import 'package:easy_debounce/easy_debounce.dart';

class AddAssetUcImpl implements AddAssetUsecase{
  
  BuildContext? _context;

  SDKProvider? sdkProvider;

  WalletProvider? walletProvider;
  
  TextEditingController controller = TextEditingController();

  ValueNotifier<bool> isEnable = ValueNotifier(false);

  List<Map<String, dynamic>>? networkSymbol;

  /// Index 0 = BSC
  /// Index 1 = Ethereum
  ValueNotifier<int> networkIndex = ValueNotifier(0);

  /// Json From Github
  ValueNotifier<List<Map<String, dynamic>>> lstContractJson = ValueNotifier([]);

  ValueNotifier<List<Map<String, dynamic>?>> searched = ValueNotifier([]);

  ValueNotifier<bool> isSearching = ValueNotifier(false);
  
  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  set setBuildContext(BuildContext ctx){
    
    _context = ctx;
    sdkProvider = Provider.of<SDKProvider>(_context!, listen: false);
    walletProvider = Provider.of<WalletProvider>(_context!, listen: false);
    
    networkSymbol = [
      {"symbol": "BSC", "index": 0, "logo": "${sdkProvider!.dirPath}/token_logo/bnb.png"},
      {"symbol": "Ethereum", "index": 1, "logo": "${sdkProvider!.dirPath}/token_logo/eth.png"}
    ];

  }
  
  /// 1.
  /// Initailize Fetching Contract From Github 
  Future<void> fetchContracts() async {
    await HttpRequestImpl().fetchContractAddress().then((value) {
      lstContractJson.value = value;
    });
  }

  void searchContract(String searchValue) async {

    if (searchValue.isNotEmpty) {

      // Enable Dialog Searching
      resetState(isSearch: true);

      EasyDebounce.debounce(
        'my-debouncer',                 // <-- An ID for this particular debouncer
        const Duration(seconds: 1),    // <-- The debounce duration
        () {
            
          searched.value = lstContractJson.value.where((value) {

            // Check User Input Address
            if ( searchValue.contains('0x') ){

              // Check Which Network Choosen User
              if (networkIndex.value == 0){
                return true;
              } else {
                return true;
              }

            }
            return false;

          }).toList();

          // Enable Dialog Searching
          if(isSearching.value == true) {

            isSearching.value = false;
            
            // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
            searched.notifyListeners();
          }
        }                // <-- The target method
      );

    } else {
      resetState(isSearch: false, isNotify: true);
    }

  }

  void resetState({bool? isSearch, bool? isNotify = false}){

    if (isSearch != isSearching.value){

      isSearching.value = isSearch!;
    }

    if (searched.value.isNotEmpty) {

      searched.value.clear();

      if (isNotify == true){
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        searched.notifyListeners();
      }
    }
  }

  @override
  Future<void> validateWeb3Address() async {

    try {

      await sdkProvider!.getSdkImpl.validateWeb3Address(controller.text).then((value) {
        if (value == true) {
          isEnable.value = true;
        } else if (isEnable.value == true) {
          isEnable.value = false;
        }
      });

    } catch (e) {
      print("error validateWeb3Address $e");
    }
    
  }

  @override
  Future<bool> validateSubstrateAddress(String address) async {
    return false;
  }

  @override
  Future<void> addAsset() async {
    
    // Close Keyboard Focus On TextformField
    FocusScope.of(_context!).unfocus();

    dialogLoading(_context!, content: "Adding new tokens");

    if (networkIndex.value == 0) {

      sdkProvider!.getSdkImpl.bscDeployedContract = await sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", controller.text);
      await _addToken(dpContract: sdkProvider!.getSdkImpl.bscDeployedContract);

    } else {

      sdkProvider!.getSdkImpl.etherDeployedContract = await sdkProvider!.getSdkImpl.deployContract("assets/json/abi/erc20.json", controller.text);
      await _addToken(dpContract: sdkProvider!.getSdkImpl.bscDeployedContract);
    }
        
  }

  void onChanged(Map<String, dynamic> value){
    networkIndex.value = value['index'];
    Navigator.pop(_context!, networkSymbol![value['index']]);

  }

  Future<void> _addToken({required DeployedContract? dpContract}) async {
    print("_addToken");
    try {

      String name = (await sdkProvider!.getSdkImpl.callWeb3ContractFunc(
        sdkProvider!.getSdkImpl.getBscClient, 
        sdkProvider!.getSdkImpl.bscDeployedContract!, 
        'name', 
        // params: [EthereumAddress.fromHex(controller.text)]
      ))[0];

      // String decimal = (await sdkProvider!.getSdkImpl.callWeb3ContractFunc(
      //   sdkProvider!.getSdkImpl.getBscClient, 
      //   sdkProvider!.getSdkImpl.bscDeployedContract!, 
      //   'decimals', 
      //   // params: [EthereumAddress.fromHex(controller.text)]
      // )).toString();

      String symbol = (await sdkProvider!.getSdkImpl.callWeb3ContractFunc(
        sdkProvider!.getSdkImpl.getBscClient, 
        sdkProvider!.getSdkImpl.bscDeployedContract!, 
        'symbol', 
        // params: [EthereumAddress.fromHex(controller.text)]
      ))[0];

      BigInt balance = (await sdkProvider!.getSdkImpl.callWeb3ContractFunc(
        sdkProvider!.getSdkImpl.getBscClient, 
        sdkProvider!.getSdkImpl.bscDeployedContract!, 
        'balanceOf', 
        params: [EthereumAddress.fromHex(controller.text)]
      ))[0];

      print("balance $balance");
      
      SmartContractModel newToken = SmartContractModel(
        // id: _marketProvider!.lsCoin!.isEmpty ? name[0] : _marketProvider!.queried!['id'],
        // name: _marketProvider!.lsCoin!.isEmpty ? name[0] : _marketProvider!.queried!['name'],
        name: name,
        symbol: symbol[0],
        chainDecimal: 18,
        balance: Fmt.bigIntToDouble(
          balance,
          18,
          // int.parse(18.toString()),
        ).toString(),
        address: sdkProvider!.getSdkImpl.evmAddress,
        // logo: _marketProvider!.lsCoin!.isEmpty ? '${AppConfig.assetsPath}circle.png' : _marketProvider!.queried!['image'],// AppConfig.assetsPath+'circle.png',
        // listActivity: [],
        // lineChartModel: LineChartModel(),
        type: '',
        org: networkIndex.value == 1 ? 'ERC-20' : 'BEP-20',
        // marketData: Market(),
        lineChartList: [],
        // change24h: _marketProvider!.lsCoin!.isEmpty ? '0' : _marketProvider!.queried!['price_change_percentage_24h'].toString(),
        // marketPrice: _marketProvider!.lsCoin!.isEmpty ? '' : _marketProvider!.queried!['current_price'].toString(),
        contract: controller.text,
        show: true
      );

      if (networkIndex.value == 0) {
        newToken.isBep20 = true;
        walletProvider!.listBep20!.add(newToken);
      }
      else {
        newToken.isErc20 = true;
        walletProvider!.listErc20!.add(newToken);
      }

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      // walletProvider!.notifyListeners();

      await storeAddedAsset(newToken);

      walletProvider!.sortAsset();

      // Close Dialog
      Navigator.pop(_context!);

      await dialogMessage(_context!, 'Message', 'Successfully', txtButton: 'Close');

    } catch (e) {

      Navigator.pop(_context!);

      await dialogMessage(_context!, 'Oops', '$e', txtButton: 'Close');
      print("Error addBscToken $e");
    }

  }

  Future<void> storeAddedAsset(SmartContractModel newToken) async {

    walletProvider!.addedContract!.clear();
    walletProvider!.addedContract!.add(newToken);

    await _secureStorageImpl.writeSecure(DbKey.addedContract, json.encode(SmartContractModel.encode( walletProvider!.addedContract!)));
    await SecureStorage.readData(key: DbKey.addedContract).then((value) {
      print("read after write $value");
    });
  }
}