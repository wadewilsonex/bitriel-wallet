import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/select_swap_token_c.dart';
import 'package:wallet_apps/src/models/select_swap_token_m.dart';

class SwapProvider extends ChangeNotifier{
  
  String label = "";

  int index1 = 0;
  int index2 = 1;

  String name1 = "";
  String logo1 = "";

  String name2 = "";
  String logo2 = "";

  String balance1 = "";
  String balance2 = "";

  List<SwapTokenListModel> ls = [];
  List<SwapTokenListModel> ls2 = [];
  List<SwapTokenListModel> searched = [];

  SwapTokenListModel swapTokenListModel = SwapTokenListModel();
  SwapTokenListModel swapTokenListModel2 = SwapTokenListModel();

  ContractProvider? contractProvider;
  ApiProvider? apiProvider;

  initList({required BuildContext? context}){
    
    ls.clear();
    ls2.clear();

    // Init Token
    name1 = contractProvider!.sortListContract[0].symbol!;
    logo1 = contractProvider!.sortListContract[0].logo!;
    name2 = contractProvider!.sortListContract[1].symbol!;
    logo2 = contractProvider!.sortListContract[1].logo!;
    balance1 = contractProvider!.sortListContract[0].balance!;
    balance2 = contractProvider!.sortListContract[1].balance!;
  }

  void setList(){

    ls.clear();
    ls2.clear();

    for(int i = 0; i < contractProvider!.sortListContract.length; i++){

      ls.add(
        SwapTokenListModel(
          title: contractProvider!.sortListContract[i].symbol,
          subtitle: contractProvider!.sortListContract[i].name,
          isActive: index2 == i ? true : false,
          image: Image.asset(contractProvider!.sortListContract[i].logo!, width: 10.w),
          balance: contractProvider!.sortListContract[i].balance,
          
        )
      );

      ls2.add(
        SwapTokenListModel(
          title: contractProvider!.sortListContract[i].symbol,
          subtitle: contractProvider!.sortListContract[i].name,
          isActive: index1 == i ? true : false,
          image: Image.asset(contractProvider!.sortListContract[i].logo!, width: 10.w),
          balance: contractProvider!.sortListContract[i].balance,
        )
      );

    }

  }

  void setNewAsset(int index){
    if (label == "first"){

      name1 = contractProvider!.sortListContract[index].symbol!;
      logo1 = contractProvider!.sortListContract[index].logo!;
      index1 = index;
      balance1 = contractProvider!.sortListContract[index].balance!;

    } else {

      name2 = contractProvider!.sortListContract[index].symbol!;
      logo2 = contractProvider!.sortListContract[index].logo!;
      index2 = index;
      balance2 = contractProvider!.sortListContract[index].balance!;

    }

    setList();
    label = "";
    
    notifyListeners();
  }
}