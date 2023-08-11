import 'package:bitriel_wallet/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
// import 'package:easy_debounce/easy_debounce.dart';

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

  SmartContractModel? searched;

  ValueNotifier<bool> isSearching = ValueNotifier(false);
  
  final SecureStorageImpl _secureStorageImpl = SecureStorageImpl();

  set setBuildContext(BuildContext ctx){
    
    _context = ctx;
    _initState();
  }

  void _initState(){
    
    sdkProvider = Provider.of<SDKProvider>(_context!, listen: false);
    walletProvider = Provider.of<WalletProvider>(_context!, listen: false);
    
    networkSymbol = [
      {"symbol": "BSC", "index": 0, "logo": "assets/logo/bnb-logo.png"},
      {"symbol": "Ethereum", "index": 1, "logo": "assets/logo/eth-logo.png"}
    ];

    searched = SmartContractModel();
  }

  void dispose(){
    controller.clear();
    searched = null;
    isSearching.dispose();
    lstContractJson.dispose();
    isEnable.dispose();
  }
  
  /// 1.
  /// Initailize Fetching Contract From Github 
  Future<void> fetchContracts() async {
    if (lstContractJson.value.isEmpty){
      
      await HttpRequestImpl().fetchContractAddress().then((value) {
        lstContractJson.value = value;
      });
    }
  }

  void onAddrChanged(String? value){
    EasyDebounce.debounce("tag", const Duration(milliseconds: 300), () { 
      if (isSearching.value == true) isSearching.value = false;
    });
  }

  void onChanged(int value){
    networkIndex.value = value;
    resetController();
  }

  Future<void> submitSeach() async {
    print("submitSeach");
    print("networkIndex.value ${networkIndex.value}");
    try {
      if (networkIndex.value == 0){

        sdkProvider!.getSdkImpl.bscDeployedContract = await sdkProvider!.getSdkImpl.deployContract("assets/json/abi/bep20.json", controller.text);

        await searchContract(sdkProvider!.getSdkImpl.getBscClient, sdkProvider!.getSdkImpl.bscDeployedContract!);

      } else {
        print("ERC");
        sdkProvider!.getSdkImpl.etherDeployedContract = await sdkProvider!.getSdkImpl.deployContract("assets/json/abi/erc20.json", controller.text);

        await searchContract(sdkProvider!.getSdkImpl.getEthClient, sdkProvider!.getSdkImpl.etherDeployedContract!);
      }
    } catch (e) {
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        text: '$e',
      );
    }
  }

  Future<void> searchContract(Web3Client client, DeployedContract deployedContract) async {
    print("searchContract");
    String name = (await sdkProvider!.getSdkImpl.callWeb3ContractFunc(
      client, 
      deployedContract, 
      'name', 
    ))[0];

    String symbol = (await sdkProvider!.getSdkImpl.callWeb3ContractFunc(
      client, 
      deployedContract, 
      'symbol', 
    ))[0];

    searched = SmartContractModel(
      name: name,
      symbol: symbol,
      chainDecimal: 18,
      address: sdkProvider!.getSdkImpl.evmAddress,
      type: '',
      org: networkIndex.value == 1 ? 'ERC-20' : 'BEP-20',
      lineChartList: [],
      contract: controller.text,
      show: true
    );

    isSearching.value = true;
  }

  void resetController(){

    controller.clear();
    if (isSearching.value == true) isSearching.value = false;
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
    // FocusScope.of(_context!).unfocus();

    dialogLoading(_context!, content: "Adding new tokens");
    try {

      if (networkIndex.value == 0) {

        await _addToken(dpContract: sdkProvider!.getSdkImpl.bscDeployedContract);

      } else {
        await _addToken(dpContract: sdkProvider!.getSdkImpl.etherDeployedContract);
        
      }
        
    } catch (e) {
      // Pop dialogLoading
      Navigator.pop(_context!);
      
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        text: '$e',
      );

    }

    resetController();
        
  }

  Future<void> _addToken({required DeployedContract? dpContract}) async {
    print("_addToken");
    try {

      BigInt balance = (await sdkProvider!.getSdkImpl.callWeb3ContractFunc(
        sdkProvider!.getSdkImpl.getBscClient, 
        sdkProvider!.getSdkImpl.bscDeployedContract!, 
        'balanceOf', 
        params: [EthereumAddress.fromHex(controller.text)]
      ))[0];

      searched!.balance = Fmt.bigIntToDouble(
        balance,
        18,
        // int.parse(18.toString()),
      ).toString();
      
      searched!.address = sdkProvider!.getSdkImpl.evmAddress;
      searched!.type = '';
      searched!.org = networkIndex.value == 1 ? 'ERC-20' : 'BEP-20';
      searched!.lineChartList = [];
      searched!.contract = controller.text;
      searched!.show = true;

      if (networkIndex.value == 0) {
        searched!.isBep20 = true;
        walletProvider!.listBep20!.add(searched!);
      }
      else {
        searched!.isErc20 = true;
        walletProvider!.listErc20!.add(searched!);
      }

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      // walletProvider!.notifyListeners();

      await storeAddedAsset(searched!);

      walletProvider!.sortAsset();

      // Close Dialog
      Navigator.pop(_context!);

      // await dialogMessage(_context!, 'Message', 'Successfully', txtButton: 'Close');
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.success,
        text: 'Successfully added ${searched!.name} to wallet',
      );

    } catch (e) {

      Navigator.pop(_context!);

      // await dialogMessage(_context!, 'Oops', '$e', txtButton: 'Close');
      await QuickAlert.show(
        context: _context!,
        type: QuickAlertType.error,
        text: '$e',
      );
      print("Error addBscToken $e");
    }

  }

  Future<void> storeAddedAsset(SmartContractModel searched) async {

    walletProvider!.addedContract!.clear();
    walletProvider!.addedContract!.add(searched!);

    await _secureStorageImpl.writeSecure(DbKey.addedContract, json.encode(SmartContractModel.encode( walletProvider!.addedContract!)));
    await SecureStorage.readData(key: DbKey.addedContract).then((value) {
      print("read after write $value");
    });
  }
}