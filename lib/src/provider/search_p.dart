import 'package:wallet_apps/index.dart';

class SearchProvider with ChangeNotifier{

  List<SmartContractModel>? _searchLs = [];

  void set setSearchedLs(List<SmartContractModel> ls){
    _searchLs!.clear();
    _searchLs!.addAll(ls);

    notifyListeners();
  }

  List<SmartContractModel> get getSchLs => _searchLs!;
  
}