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

  List<SwapTokenListModel> ls = [];
  List<SwapTokenListModel> ls2 = [];

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
    
  }

  void setList(){

    ls.clear();
    ls2.clear();

    for(int i = 0; i < contractProvider!.sortListContract.length; i++){

      ls.add(
        SwapTokenListModel(
          title: apiProvider!.isMainnet ? contractProvider!.sortListContract[i].org : contractProvider!.sortListContract[i].orgTest,
          subtitle: contractProvider!.sortListContract[i].symbol,
          isActive: index2 == i ? true : false,
          image: Image.asset(contractProvider!.sortListContract[i].logo!, width: 4.w, height: 4.h),
        )
      );

      ls2.add(
        SwapTokenListModel(
          title: apiProvider!.isMainnet ? contractProvider!.sortListContract[i].org : contractProvider!.sortListContract[i].orgTest,
          subtitle: contractProvider!.sortListContract[i].symbol,
          isActive: index1 == i ? true : false,
          image: Image.asset(contractProvider!.sortListContract[i].logo!, width: 4.w, height: 4.h),
        )
      );

      // l2.add(
      //   SwapTokenList(
      //     title: apiProvider.isMainnet ? ls[i].org : ls[i].orgTest,
      //     subtitle: sortLs[i].symbol,
      //     isActive: index2 == i ? true : false,
      //     image: Image.asset(sortLs[i].logo!, width: 4.w, height: 4.h),
      //     action: (){

      //       name1 = sortLs[i].symbol!;
      //       logo1 = sortLs[i].logo!;
      //       index1 = i;

      //       Provider.of<SwapProvider>(context, listen: false).label = "";

      //       notifyListeners();
      //       Navigator.pop(context);
      //     }
      //   )
      // );

      // swapTokenListModel2.lsSwapToken.add(
      //   SwapTokenList(
      //     title: apiProvider.isMainnet ? ls[i].org : ls[i].orgTest,
      //     subtitle: sortLs[i].symbol,
      //     isActive: index1 == i ? true : false,
      //     image: Image.asset(sortLs[i].logo!, width: 4.w, height: 4.h),
      //     action: (){

      //       name2 = sortLs[i].symbol!;
      //       logo2 = sortLs[i].logo!;
      //       index2 = i;

      //       Provider.of<SwapProvider>(context, listen: false).label = "";

      //       notifyListeners();
      //       Navigator.pop(context);
      //     }
      //   )
      // );

    }

  }
}