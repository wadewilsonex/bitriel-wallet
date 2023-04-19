import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/select_swap_token_m.dart';
import 'package:wallet_apps/src/models/swap_m.dart';

class SwapProvider extends ChangeNotifier{
  
  String label = "";

  int index1 = 0;
  int index2 = 1;

  String name1 = "";
  Widget? logo1;
  String network1 = "";

  String name2 = "";
  Widget? logo2;
  String network2 = "";

  String balance1 = "";
  String balance2 = "";

  List<SwapTokenListModel> ls = [];
  List<SwapTokenListModel> ls2 = [];
  List<SwapTokenListModel> searched = [];

  /// From LetsExchange API
  List<dynamic>? lstCoins = [];

  SwapPageModel model = SwapPageModel();

  SwapTokenListModel swapTokenListModel = SwapTokenListModel();
  SwapTokenListModel swapTokenListModel2 = SwapTokenListModel();
  InfoTwoCoinModel? twoCoinModel;
  ResInfoTwoCoinModel? resTwoCoinModel;

  ContractProvider? contractProvider;
  ApiProvider? apiProvider;

  initList({required BuildContext? context}){
    
    ls.clear();
    ls2.clear();
    twoCoinModel = InfoTwoCoinModel();
    resTwoCoinModel = ResInfoTwoCoinModel();

    searched.clear();

    List<SmartContractModel> found1 = contractProvider!.sortListContract.where((element) {
      if (element.id == "tether") return true;
      return false;
    }).toList();

    List<SmartContractModel> found2 = contractProvider!.sortListContract.where((element) {
      if (element.id == "ethereum") return true;
      return false;
    }).toList();

    print("found1[0].logo! ${found1[0].logo!}");

    // Init Token
    name1 = found1[0].symbol!;
    logo1 = found1[0].logo!.contains('http') && found1[0].logo!.contains('svg') ? SvgPicture.network(found1[0].logo!) : Image.network(found1[0].logo!);
    network1 = found1[0].org!;

    name2 = found2[0].symbol!;
    logo2 = found2[0].logo!.contains('http') && found2[0].logo!.contains('svg') ? SvgPicture.network(found2[0].logo!) : Image.asset(found2[0].logo!);
    network2 = found2[0].org!;
    
    balance1 = "0";//found1[0].balance!;
    balance2 = "0";//found2[0].balance!;
  }

  void setList(){

    ls.clear();
    ls2.clear();

    for(int i = 0; i < lstCoins!.length; i++){

      for (int j = 0; j < lstCoins![i]['networks'].length; j++){
        addCoinByIndex(i, j);
      }

    }
    // for(int i = 0; i < contractProvider!.sortListContract.length; i++){

    //   ls.add(
    //     SwapTokenListModel(
    //       title: contractProvider!.sortListContract[i].symbol,
    //       subtitle: contractProvider!.sortListContract[i].name,
    //       isActive: index2 == i ? true : false,
    //       image: contractProvider!.sortListContract[i].logo!.contains('http') 
    //       ? Image.network(contractProvider!.sortListContract[i].logo!, width: 10)
    //       : Image.asset(contractProvider!.sortListContract[i].logo!, width: 10),
    //       balance: contractProvider!.sortListContract[i].balance,
          
    //     )
    //   );

    //   ls2.add(
    //     SwapTokenListModel(
    //       title: contractProvider!.sortListContract[i].symbol,
    //       subtitle: contractProvider!.sortListContract[i].name,
    //       isActive: index1 == i ? true : false,
    //       image: contractProvider!.sortListContract[i].logo!.contains('http') 
    //       ? Image.network(contractProvider!.sortListContract[i].logo!, width: 10)
    //       : Image.asset(contractProvider!.sortListContract[i].logo!, width: 10),
    //       balance: contractProvider!.sortListContract[i].balance,
    //     )
    //   );

    // }

  }

  void addCoinByIndex(int i, int j) {

    ls.add(
      SwapTokenListModel(
        title: lstCoins![i]['code'],
        subtitle: lstCoins![i]['name'],
        isActive: index2 == i ? true : false,
        image: lstCoins![i]['icon'] == null 
        ? CircleAvatar(child: Container(width: 10, height: 10, color: Colors.green,),) 
        : SvgPicture.network(lstCoins![i]['icon'], width: 10),
        network: lstCoins![i]['networks'][j]['name'],
        // lstCoins![i]['icon'].contains('http') 
        // ? Image.network(lstCoins![i]['icon'], width: 10)
        // : Image.asset(lstCoins![i]['icon'], width: 10),
        balance: "0"//contractProvider!.sortListContract[i].balance,
        
      )
    );

    ls2.add(
      SwapTokenListModel(
        title: lstCoins![i]['code'],
        subtitle: lstCoins![i]['name'],
        isActive: index2 == i ? true : false,
        image: lstCoins![i]['icon'] == null 
        ? CircleAvatar(child: Container(width: 10, height: 10, color: Colors.green,),) 
        : SvgPicture.network(lstCoins![i]['icon'], width: 10),
        network: lstCoins![i]['networks'][j]['name'],
        //lstCoins![i]['icon'].contains('http') 
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
      // balance1 = "0";
      index1 = index;

    } else {

      name2 = ls[index].title!;
      logo2 = ls[index].image!;
      // balance2 = "0";
      index2 = index;

    }

    setList();
    label = "";
    
    notifyListeners();
  }

  Future<void> confirmSwapW3() async {

    // final contractAddr = ApiProvider().isMainnet ?  contractProvider!.sortListContract[_scanPayM.assetValue].contract : trxFunc!.contract!.sortListContract[_scanPayM.assetValue].contractTest;
    
    // await contractProvider!.bscClient.sendTransaction(
    //   cred, transaction
    // );
  }

  void notifyDataChanged(){
    notifyListeners();
  }
}