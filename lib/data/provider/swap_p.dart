import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/data/models/select_swap_token_m.dart';
import 'package:wallet_apps/data/models/swap_m.dart';

class SwapProvider extends ChangeNotifier{
  
  String label = "";

  int index1 = 0;
  int index2 = 1;

  String name1 = "";
  Widget? logo1;
  String network1 = "";
  String networkFrom = "";

  String name2 = "";
  Widget? logo2;
  String network2 = "";
  String networkTo = "";

  String balance1 = "";
  String balance2 = "";

  Widget? imgConversion;

  List<SwapTokenListModel> ls = [];
  // List<SwapTokenListModel> ls2 = [];
  List<SwapTokenListModel> searched = [];

  /// From LetsExchange API
  List<dynamic>? lstCoins = [];

  Map<dynamic, dynamic>? lstConvertCoin = {};

  SwapPageModel? model = SwapPageModel();

  SwapTokenListModel? swapTokenListModel = SwapTokenListModel();
  SwapTokenListModel? swapTokenListModel2 = SwapTokenListModel();
  InfoTwoCoinModel? twoCoinModel;
  ResInfoTwoCoinModel? resTwoCoinModel;
  ConvertCoinModel? convertCoinModel;

  ContractProvider? contractProvider;
  ApiProvider? apiProvider;

  initList({required BuildContext? context}){

    searched.clear();

    List<SmartContractModel> found1 = contractProvider!.sortListContract.where((element) {
      if (element.id == "tether") return true;
      return false;
    }).toList();
    

    List<SmartContractModel> found2 = contractProvider!.sortListContract.where((element) {
      if (element.id == "ethereum") return true;
      return false;
    }).toList();

    if (found1.isNotEmpty && found2.isNotEmpty){
      // Init Token
      name1 = found1[0].symbol!;
      logo1 = found1[0].logo!.contains('http') && found1[0].logo!.contains('svg') ? SvgPicture.network(found1[0].logo!) : Image.file(File(found1[0].logo!));
      network1 = found1[0].org!;
      networkFrom = found1[0].org!;

      name2 = found2[0].symbol!;
      logo2 = found2[0].logo!.contains('http') && found2[0].logo!.contains('svg') ? SvgPicture.network(found2[0].logo!) : Image.file(File(found2[0].logo!));
      network2 = found2[0].org!;
      networkTo = found2[0].org!;
      
      balance1 = "0";//found1[0].balance!;
      balance2 = "0";//found2[0].balance!;
    }
  }

  void setList() async {

    ls.clear();

    for(int i = 0; i < lstCoins!.length; i++){

      for (int j = 0; j < lstCoins![i]['networks'].length; j++){
        addCoinByIndex(i, j);
      }

    }

    await Future.delayed(const Duration(milliseconds: 200), (){});
    notifyListeners();

  }

  void addCoinByIndex(int i, int j) {

    if (lstCoins![i]['icon'] != null){

      if (lstCoins![i]['icon'].contains('svg')){
        imgConversion = SvgPicture.network(lstCoins![i]['icon'], width: 10);
      } else if (lstCoins![i]['icon'] != null){
        imgConversion = Image.network(lstCoins![i]['icon'], width: 10);
      }
    }
    // Null 
    else {
      imgConversion = CircleAvatar(child: Container(width: 10, height: 10, color: Colors.green,),);
    }

    ls.add(
      SwapTokenListModel(
        title: lstCoins![i]['code'],
        subtitle: lstCoins![i]['name'],
        isActive: index2 == i ? true : false,
        image: imgConversion,
        // lstCoins![i]['icon'] == null 
        // ? 
        // : SvgPicture.network(lstCoins![i]['icon'], width: 10),
        network: lstCoins![i]['networks'][j]['name'],
        networkCode: lstCoins![i]['networks'][j]['code'],
        // lstCoins![i]['icon'].contains('http') 
        // ? Image.network(lstCoins![i]['icon'], width: 10)
        // : Image.asset(lstCoins![i]['icon'], width: 10),
        balance: "0"//contractProvider!.sortListContract[i].balance,
        
      )
    );
  }

  void setNewAsset(int index){
    
    if (label == "first"){

      name1 = ls[index].title!;
      logo1 = ls[index].image!;
      network1 = ls[index].network!;
      networkFrom = ls[index].networkCode!;
      // balance1 = "0";
      index1 = index;

    } else {

      name2 = ls[index].title!;
      logo2 = ls[index].image!;
      network2 = ls[index].network!;
      networkTo = ls[index].networkCode!;
      // balance2 = "0";
      index2 = index;

    }

    // setList();
    label = "";
    
    notifyListeners();
  }

  Future<void> confirmSwapW3() async {

    // final contractAddr = ApiProvider().isMainnet ?  contractProvider!.sortListContract[_scanPayM.assetValue].contract : trxFunc!.contract!.sortListContract[_scanPayM.assetValue].contractTest;
    
    // await contractProvider!.bscClient.sendTransaction(
    //   cred, transaction
    // );
  }

  void init(){

    label = "";
    index1 = 0;
    index2 = 1;

    name1 = "";
    logo1;
    network1 = "";

    name2 = "";
    logo2;
    network2 = "";

    balance1 = "";
    balance2 = "";

    ls = [];
    searched = [];

    /// From LetsExchange API
    // lstCoins = [];

    model = SwapPageModel();

    swapTokenListModel = SwapTokenListModel();
    swapTokenListModel2 = SwapTokenListModel();
    twoCoinModel = InfoTwoCoinModel();
    resTwoCoinModel = ResInfoTwoCoinModel();
    convertCoinModel = ConvertCoinModel();
  }

  void reset(){
    label = "";
    index1 = 0;
    index2 = 1;

    name1 = "";
    logo1;
    network1 = "";

    name2 = "";
    logo2;
    network2 = "";

    balance1 = "";
    balance2 = "";

    ls = [];
    searched = [];

    /// From LetsExchange API
    lstCoins = [];

    model = null;

    swapTokenListModel = null;
    swapTokenListModel2 = null;
    twoCoinModel = null;
    resTwoCoinModel = null;
    convertCoinModel = null;

    contractProvider = null;
    apiProvider = null;
  }

  void notifyDataChanged(){
    notifyListeners();
  }
}