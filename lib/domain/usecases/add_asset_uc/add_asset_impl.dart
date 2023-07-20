import 'package:bitriel_wallet/index.dart';

class AddAssetUcImpl implements AddAssetUsecase{
  
  BuildContext? context;
  SDKProvier? sdkProvier;
  
  TextEditingController controller = TextEditingController();

  ValueNotifier<bool> isEnable = ValueNotifier(false);

  set setBuildContext(BuildContext ctx){
    context = ctx;
    sdkProvier = Provider.of(context!, listen: false);
  }
  
  @override
  Future<void> validateWeb3Address() async {

    try {

      await sdkProvier!.getSdkImpl.validateWeb3Address(controller.text).then((value) {
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

    print("addAsset");

    await _addBscToken();
        
  }


  Future<void> addEtherToken() async {
    
  }

  Future<void> _addBscToken() async {

    print("_addBscToken");
    try {

      print("addBscToken");
      await sdkProvier!.getSdkImpl.callWeb3ContractFunc(
        sdkProvier!.getSdkImpl.getBscClient, 
        sdkProvier!.getSdkImpl.bscDeployedContract!, 
        'decimals', 
        // params: [EthereumAddress.fromHex(controller.text)]
      ).then((value) {
        
        print("callWeb3ContractFunc ${value.toString()}");
      });
    } catch (e) {
      print("Error addBscToken $e");
    }
  }
}