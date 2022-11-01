import 'package:wallet_apps/index.dart';

class SearchProvider with ChangeNotifier{

  final List<SmartContractModel> _searchLs = [];

  set setSearchedLs(List<SmartContractModel> ls){
    _searchLs.clear();
    _searchLs.addAll(ls);

    notifyListeners();
  }

  List<SmartContractModel> get getSchLs => _searchLs;
  
}